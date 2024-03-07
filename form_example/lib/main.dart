import 'package:flutter/material.dart';
import 'package:form_example/firebase_options.dart';
import 'package:form_example/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  // runApp(const MyApp());
  runApp(const MaterialApp(title: "Login Example", home: LoginPage()));
}
