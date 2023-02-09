import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase/firebase_manager.dart';

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
                ElevatedButton(onPressed: () => signOut(context), child: Text('SignOut')),
                Text("hello"),
              ],
            ),
          ),
        )
    );
  }

  signOut(BuildContext context) {
      FirebaseManager.auth.signOut();
      NavigatorState state = Navigator.of(context);
      state.pushNamedAndRemoveUntil('login', (Route route) => false);
  }
}
