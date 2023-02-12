import 'package:exception/screens/Driving.dart';
import 'package:exception/screens/face_detector_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

import 'drive_mode.dart';

class DriveDetails extends StatelessWidget {
  const DriveDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drive Details',style: TextStyle(color: Colors.white),),
        elevation: 0,
        backgroundColor: Color(0xff14122a),

      ),
      backgroundColor:  Color(0xff14122a),
      body: Center(
          child: Container(
            width: 400,
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
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // FloatingActionButton(
                //   onPressed: () {
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (context) => Driving()));
                //   },
                // ),
                InkWell(
                  child: Container(
                    child: Text('Drive Now',
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
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => FaceDetectorPage()));
                  },
                ),
              ],
            ),

          ),
        ),
      
    );
  }
}

