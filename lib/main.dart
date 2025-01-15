import 'package:fe_connect_backend/views/basescreen.dart';
import 'package:fe_connect_backend/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/activity_controller.dart';
import 'views/basescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyANEoFc_B7phin9uj5N4nyDnuXRVBd22d0",
    authDomain: "proj-gr-2-wellness-app.firebaseapp.com",
    projectId: "proj-gr-2-wellness-app",
    storageBucket: "proj-gr-2-wellness-app.firebasestorage.app",
    messagingSenderId: "790467964193",
    appId: "1:790467964193:web:957d1d30cf55ee96dde260",
    measurementId: "G-RBYQE8ENR8",
  );

  await Firebase.initializeApp(options: firebaseOptions);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActivityController(),
      child: MaterialApp(
        title: 'Mindfulness and Wellness',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginPage(),
      ),
    );
  }
}
