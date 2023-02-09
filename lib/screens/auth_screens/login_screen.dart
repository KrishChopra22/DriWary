import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../firebase/firebase_manager.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseManager.auth;
  final FirebaseDatabase database = FirebaseManager.database;

  @override
  Widget build(BuildContext context) {
    NavigatorState state = Navigator.of(context);
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
                      height: 400,
                    ),
                    Text('Login'),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        labelText: "Email",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
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
                    ElevatedButton(onPressed: () => login(context), child: Text('Login'),),
                    ElevatedButton(
                      onPressed: () =>{
                        print('Redirected to SignUp'),
                      state.pushNamedAndRemoveUntil('/signup', (Route route) => false),
                      },
                      child: Text('Signup'),)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  login(BuildContext context) async {
    print('Login');
    NavigatorState state = Navigator.of(context);
    try{
      // Check for users email& password from firebase inbuilt func
      await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
      state.pushNamedAndRemoveUntil('home', (Route route) => false);
      print('Redirected to HomePage');
    }
    on FirebaseAuthException catch(e){
      print('Found Error');
      print(e.code);
      if (e.code == 'user-not-found') {
        print("user-not-found");
        Fluttertoast.showToast(
          msg: "No user found for that email.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
      else if (e.code == 'wrong-password') {
        print("wrong-password");
        Fluttertoast.showToast(
          msg: "Wrong Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
      else {
        Fluttertoast.showToast(
          msg: "Enter valid details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
    }
  }
}
