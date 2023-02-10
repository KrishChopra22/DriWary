import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../dataclass/person.dart';

class verifyOtp extends StatefulWidget {
  final List<String> args;
  verifyOtp({Key? key, required this.args}) : super(key: key);

  @override
  State<verifyOtp> createState() => _verifyOtpState();
}

class _verifyOtpState extends State<verifyOtp> {
  final TextEditingController codeController = TextEditingController();
  late String verificationIDReceived;

  @override
  void initState() {
    verificationIDReceived = widget.args[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          TextFormField(
            controller: codeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5)),
              labelText: "Code",
            ),
          ),
          const SizedBox(
            height: 30,
          ),

          ElevatedButton(onPressed: (){
            verifyCode(context);
          },
            child: Text('Verify Code'),
          ),
        ],
      ),
    );
  }


  verifyCode(BuildContext context) async{

    NavigatorState state = Navigator.of(context);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationIDReceived,
      smsCode: codeController.text,
    );
    await auth.signInWithCredential(credential).then((value) {
        print("Logged in");
      },
    );
    if(await checkNumberIsRegistered(number: widget.args[1])){
      print("Already a User, Redirected to Homepage");
      state.pushNamedAndRemoveUntil('home', (Route route) => false);
    }
    else{
      print("New User, Redirected to SignUp");
      state.pushNamedAndRemoveUntil('/signup',arguments: widget.args[1], (Route route) => false);
    }

  }

  Future<bool> checkNumberIsRegistered({required String number}) async {
    bool isNumberRegistered = false;
    try {
      print("TRY");
      await database.ref("Users").once().then((data) {
        for (var i in data.snapshot.children) {
          String data = i.child("phone").value.toString();
          print(data);
          if (number == data) {
            isNumberRegistered = true;
            return isNumberRegistered;
          } else {
            isNumberRegistered = false;
          }
        }
      });
      return isNumberRegistered;
    } catch (e) {
      return false;
    }
  }

}
