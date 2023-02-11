import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../dataclass/person.dart';
import '../../utils/auth_utils.dart';

class PhoneVerify extends StatelessWidget {
  PhoneVerify({Key? key}) : super(key: key);

  String verificationIDReceived = "";
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          Text("Phone Verify"),
          const SizedBox(
            height: 50,
          ),

          TextFormField (
            controller: phoneController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5)),
              labelText: "PhoneNumber",
            ),
          ),
          const SizedBox(
            height: 30,
          ),


          ElevatedButton(onPressed: (){
            verifyNumber(context);
          } ,
            child: Text('Verify Number'),
          ),
        ],
      ),
    );
  }


  verifyNumber(BuildContext context) {
    NavigatorState state = Navigator.of(context);

    auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          AuthUtils.showLoadingDialog(context);
          await auth.signInWithCredential(credential).then((value) =>{
            print("You are Logged in.")
          });
        },
        verificationFailed: (FirebaseAuthException e){
          print("Verification Failed");
          print(e.message);
        },
        codeSent: (String verifictionID, int? resendToken){
          print("Code Sent");
          verificationIDReceived = verifictionID;
          List<String> data_to_send = [verificationIDReceived,phoneController.text];
          Fluttertoast.showToast(
            msg: "OTP Sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          print("Redirect to OTP Verification Page");
          state.pushNamedAndRemoveUntil('/verifyOtp',arguments: data_to_send, (Route route) => false);
        },
        codeAutoRetrievalTimeout: (String verificationID){}
    );
  }
}
