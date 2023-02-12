import 'package:exception/screens/dashboard.dart';
import 'package:exception/utils/face_detector_painter.dart';

import 'camera_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({Key? key}) : super(key: key);

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  int alarmCount = 0;
  int drowsyCount = 0;
  int yawningCount = 0;

  //create face detector object
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);
      },
      initialDirection: CameraLensDirection.front,
    );
  }

  Future<void> processImage(final InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = "";
    });
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);

      for (final face in faces) {
        double averageEyeOpenProb =
            (face.leftEyeOpenProbability! + face.rightEyeOpenProbability!) /
                2.0;
        if (averageEyeOpenProb < 0.6 ||
            (face.leftEyeOpenProbability! < 0.3 &&
                face.rightEyeOpenProbability! < 0.3)) {
          print("\n........SLEEPING........\n");
          setState(() {
            // widget.alertSleepingText = "Driver is feeling drowsy";
            drowsyCount = drowsyCount + 1;
          });
          if (drowsyCount > 8) {
            setState(() {
              alarmCount = alarmCount + 1;
            });
            Dashboard.playSound(context);
            print(" ALARM !!!    WAKE UP DUDE...");
            //drowsy count is set back to 0
            if (alarmCount > 2) {
              setState(() {
                alarmCount = 0;
              });
            }

            //maintain alramCount,    if alarm is played more than 2 times,   send sms/call
          }
        }
        if (drowsyCount > 8) {
          setState(() {
            drowsyCount = 0;
            // widget.alertSleepingText = "Driver is not feeling drowsy";
          });
        }

        print(face.smilingProbability);
        if ((0.02 < face.smilingProbability! &&
                face.smilingProbability! < 0.2) &&
            (face.leftEyeOpenProbability! < 0.86 &&
                face.rightEyeOpenProbability! < 0.86)) {
          print("\n........YAWNING........\n");
          setState(() {
            // widget.alertYawningText = "Driver is Yawning";
            yawningCount = yawningCount + 1;
          });

          if (yawningCount > 5) {
            Dashboard.playSound(context);
            setState(() {
              alarmCount = alarmCount + 1;
            });
            //play alarm sound until driver stops it
            // if driver stops the alarm, yawning count is set back to 0
            print(" ALARM !!!    WAKE UP DUDE...");
            if (alarmCount > 2) {
              // SEND SMS/CALL
              setState(() {
                alarmCount = 0;
              });
            }

            //maintain alramCount,    if alarm is played more than 2 times,   send sms/call
          }
        }
        if (yawningCount > 5) {
          setState(() {
            yawningCount = 0;
            // widget.alertYawningText = "Driver is not yawning";
          });
        }
      }
    } else {
      String text = 'face found ${faces.length}\n\n';

      for (final face in faces) {
        text += 'face ${face.boundingBox}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
