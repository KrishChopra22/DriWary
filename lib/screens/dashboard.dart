import 'package:audioplayers/audioplayers.dart';
import 'package:exception/screens/DriveDetails.dart';
import 'package:exception/screens/face_detector_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';

import '../firebase/firebase_manager.dart';
import 'emergency_contact.dart';

String message = "This is a test message!";
List<String> recipients = ["+919425253909", "8720068368"];

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseManager.auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () => signOut(context),
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: Color(0xff14122a),
        ),
        backgroundColor: Color(0xff14122a),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: 400,
                padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Color(0xff14122a),
                      Color(0xff13132d),
                      Color(0xff13132f),
                      Color(0xff1b1a3c),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ElevatedButton(
                      //     onPressed: () => signOut(context),
                      //     child: const Text('SignOut')),
                      const Text("Hello"),
                      Text(auth.currentUser!.uid),
                      // ElevatedButton(
                      //     onPressed: () => call(context), child: const Text('Call')),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       _sendSMS(message, recipients);
                      //     },
                      //     child: const Text('Location')),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       playSound(context);
                      //     },
                      //     child: const Text('sound')),

                      // ElevatedButton(
                      //     onPressed: () => popup(context),
                      //     child: const Text('PopUP')),
                      // ElevatedButton(
                      //     onPressed: () => _sendSMS(message, recipients),
                      //     child: const Text('SMS')),
                      // FloatingActionButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const DriveDetails()));
                      //   },
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DriveDetails()));
                        },
                        child: Container(
                          child: Text('Start Drive',
                          style: TextStyle(
                            color: Colors.white, fontSize: 20
                          ),),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Color(0xff13132d),
                              border: GradientBoxBorder(
                                  gradient:LinearGradient(
                                      colors: [
                                        Color(0xff13132d),
                                        Colors.white
                                      ]
                                  )
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          ),
        ),
        
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => const FaceDetectorPage()));
        //   },
        // )
    );
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

  static call(BuildContext context) {
    FlutterPhoneDirectCaller.callNumber("+916261934855");
  }

  static location(BuildContext context) async {
    print("LOC");
    await Permission.location.serviceStatus.isEnabled;
    print(Permission.location.serviceStatus.isEnabled);
    _sendSMS(message, recipients);
  }

  static void _sendSMS(String message, List<String> recipients) async {
    String _result = await sendSMS(
            message: message, recipients: recipients, sendDirect: true)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  static void playSound(BuildContext context) {
    final player = AudioPlayer();
    player.play(AssetSource('alarm.mpeg'));
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        onConfirmBtnTap: () {
          player.stop();
          Navigator.pop(context);
        });
  }
}
