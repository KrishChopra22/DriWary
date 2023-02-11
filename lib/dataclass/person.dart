import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../firebase/firebase_manager.dart';

final FirebaseAuth auth = FirebaseManager.auth;
final FirebaseDatabase database = FirebaseManager.database;

class Person{
  late String name;
  late String email;
  late String phone;
  late String uid;
  late List<String>? emergencyContact;
  // Person(
  //     {
  //       required this.name,
  //       required this.email,
  //       required this.phone,
  //       required this.uid,
  //       this.emergencyContact,
  //     }
  //     );

  void fromJson(Map<String?, dynamic> json) {
     // return Person(
     //   name : json['name'],
     //   email : json['email'],
     //   phone : json['phone'],
     //   uid : json['uid'],
     // );
     name = json['name'];
     phone = json['phone'];
     email = json['email'];
     uid = json['uid'];
     emergencyContact = json['emergencyContact'];
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
        'phone': phone,
        'uid': uid,
        'emergencyContact' : emergencyContact,
      };

  Future<void> addGroup(Person p) async {
    p.emergencyContact?.add(this as String);
    await database.ref('Users/${auth.currentUser?.uid}').update(toJson());
    print("User Upated");
  }

}