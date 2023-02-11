import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../dataclass/person.dart';
import '../../firebase/firebase_manager.dart';
import '../../utils/auth_utils.dart';

class SignupScreen extends StatelessWidget {
  final String args;
  SignupScreen({super.key, required this.args});
  final FirebaseAuth auth = FirebaseManager.auth;
  final FirebaseDatabase database = FirebaseManager.database;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 300,
                    ),
                    Text('SignUp'),
                    const SizedBox(
                      height: 30,
                    ),

                    TextFormField (
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        labelText: "email",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        labelText: "name",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    TextFormField (
                      controller: dobController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        labelText: "dob",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    TextFormField (
                      controller: genderController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        labelText: "gender",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),


                    TextFormField (
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        labelText: "Password",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    ElevatedButton(onPressed: () => signup(context), child: Text('SignUp')),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  signup(BuildContext context) async {
    print("Sign-Up");

    NavigatorState state = Navigator.of(context);
    try{

    // Make User from the inbuilt func of Firebase
    final credentials = await auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    print("Args");
    print(args);
    print(credentials.user?.uid);

    // Make object of dataclass and push on DB
    Person person = Person();
    Map<String, dynamic> personJson = {};
    personJson['name'] = nameController.text;
    personJson['uid'] = credentials.user?.uid??"";
    personJson['email'] = emailController.text;
    personJson['phone'] = args;
    personJson['emergencyContact'] = ['0'];

    print(personJson['phone']);
    person.fromJson(personJson);
    print("Person Object Created");
    //Push on DB
    AuthUtils.showLoadingDialog(context);
    await database.ref('Users/${person.uid}').set(person.toJson());
    print("Pushed in DB");

    //Goto Home
    state.pushNamedAndRemoveUntil('home', (Route route) => false);
    print("Redirected to HomePage");

    }
    on FirebaseAuthException catch (e) {
      print('Error Found');
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: "The password provided is too weak.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "An account already exists for that email.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Invalid details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: 'Something is Wrong',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }
}
