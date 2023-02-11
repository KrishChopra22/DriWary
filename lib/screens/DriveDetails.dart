import 'package:exception/screens/Driving.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DriveDetails extends StatelessWidget {
  const DriveDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Center(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Driving()));
            },
          ),

        ),
      ),
    );
  }
}