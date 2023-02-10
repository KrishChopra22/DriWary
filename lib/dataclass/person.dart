import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../firebase/firebase_manager.dart';

final FirebaseAuth auth = FirebaseManager.auth;
final FirebaseDatabase database = FirebaseManager.database;

class Person extends ChangeNotifier {
  late String name;
  late String email;
  late String phone;
  late String uid;

  void fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
        'phone': phone,
        'uid': uid,
      };
}