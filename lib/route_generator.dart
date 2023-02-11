import 'package:exception/screens/auth_screens/phone_verify.dart';
import 'package:exception/screens/auth_screens/signup_screen.dart';
import 'package:exception/screens/auth_screens/code_verify.dart';
import 'package:exception/screens/drive_mode.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case 'verify':
        return MaterialPageRoute(builder: (_) => PhoneVerify());
      case 'home':
        return MaterialPageRoute(builder: (_) => const HomePage());

      case '/signup':
        return MaterialPageRoute(
            builder: (_) => SignupScreen(args: args as String));
      case 'camera':
        return MaterialPageRoute(builder: (_) => const DriveModePage());
      case '/verifyOtp':
        return MaterialPageRoute(
            builder: (_) => verifyOtp(
                  args: args as List<String>,
                ));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
