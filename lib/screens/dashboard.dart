import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase/firebase_manager.dart';
import 'camera_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

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
                Text("hello"),
                ElevatedButton(
                    onPressed: () => camera(context), child: Text('Camera')),
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
    state.pushNamedAndRemoveUntil('login', (Route route) => false);
  }

  camera(BuildContext context) {
    NavigatorState state = Navigator.of(context);
    state.pushNamedAndRemoveUntil('camera', (Route route) => false);
  }
}
