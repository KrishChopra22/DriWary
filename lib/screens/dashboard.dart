import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';

import '../firebase/firebase_manager.dart';
import 'camera_page.dart';

String message = "This is a test message!";
List<String> recipients = ["+919425253909", "8720068368"];

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseManager.auth;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        body: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () => signOut(context), child: Text('SignOut')),
                Text("Hello"),
                Text(auth.currentUser!.uid),
                ElevatedButton(
                    onPressed: () => call(context), child: Text('Call')),
                ElevatedButton(
                    onPressed: () { _sendSMS(message, recipients);}, child: Text('Location')),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CameraPage()));
          },
        ));
  }

  signOut(BuildContext context) {
    FirebaseManager.auth.signOut();
    NavigatorState state = Navigator.of(context);
    state.pushNamedAndRemoveUntil('verify', (Route route) => false);
  }

  camera(BuildContext context) {
    NavigatorState state = Navigator.of(context);
    state.pushNamedAndRemoveUntil('camera', (Route route) => false);
  }

  call(BuildContext context){
    FlutterPhoneDirectCaller.callNumber("+916261934855");
  }

  location(BuildContext context) async {
    print("LOC");
    await Permission.location.serviceStatus.isEnabled;
    print(Permission.location.serviceStatus.isEnabled);
    _sendSMS(message, recipients);
  }

  void _sendSMS(String message, List<String> recipients) async {
    String _result = await sendSMS(message: message, recipients: recipients, sendDirect: true)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}
