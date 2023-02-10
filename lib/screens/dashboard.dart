import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../firebase/firebase_manager.dart';
import 'camera_page.dart';

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
                    onPressed: () => call(context), child: Text('CAll')),
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
    FlutterPhoneDirectCaller.callNumber("+919425253909");
  }
}
