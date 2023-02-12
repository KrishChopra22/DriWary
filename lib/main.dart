import 'package:camera/camera.dart';
import 'package:exception/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase/firebase_manager.dart';
import 'route_generator.dart';
import 'firebase/firebase_options.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Permission.camera.request();
  await Permission.microphone.request();
  await Permission.location.request();
  await Permission.audio.request();
  await Permission.notification.request();
  await Permission.sms.request();
  await Permission.phone.request();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await checkUser();
  runApp(MyApp());
}

Future<void> checkUser() async {
  if (FirebaseManager.auth.currentUser != null) {
    final snapshot = await FirebaseManager.database
        .ref('Users')
        .get();
    print(snapshot.value);
    if (!snapshot.exists) {
      await FirebaseManager.auth.signOut();
      Fluttertoast.showToast(
          msg: "^_^ You Got Deleted ^_^", toastLength: Toast.LENGTH_LONG);
    }
  }
}

class MyApp extends StatelessWidget {
  final FirebaseAuth auth = FirebaseManager.auth;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Open LoginPage if auth is null else go to home
    if (auth.currentUser == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'verify',
        onGenerateRoute: RouteGenerator.generateRoute,
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'home',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Dashboard();
  }
}
