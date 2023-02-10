import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../dataclass/person.dart';

class verifyOtp extends StatefulWidget {
  final String args;
  verifyOtp({Key? key, required this.args}) : super(key: key);

  @override
  State<verifyOtp> createState() => _verifyOtpState();
}

class _verifyOtpState extends State<verifyOtp> {
  final TextEditingController codeController = TextEditingController();

  late String verificationIDReceived;

  @override
  void initState() {
    verificationIDReceived = widget.args;
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
      state.pushNamedAndRemoveUntil('home', (Route route) => false);
      print("Logged in");
    }
    );
  }
}
