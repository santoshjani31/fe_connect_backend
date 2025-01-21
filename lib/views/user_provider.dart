import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  String? _userId;

  UserProvider() {
    // Listen for authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _userId = user.uid;
        getUserData(user.uid);
      } else {
        _user = null;
        _userId = null;
      }
      notifyListeners();
    });
  }

  UserModel? get user => _user;
  String? get userId => _userId;

  Future<void> getUserData(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      _user = UserModel.fromFirestore(documentSnapshot);
    } catch (e) {
      print('Error fetching user data: $e');
    }
    notifyListeners();
  }
}