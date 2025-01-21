import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? username;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
    };
  }

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> document,
      ) {
    Map<String, dynamic> data = document.data()!;
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      username: data['username'],
    );
  }
}