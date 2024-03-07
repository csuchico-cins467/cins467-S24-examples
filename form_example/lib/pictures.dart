import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_example/login.dart';
import 'package:form_example/photoform.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({Key? key}) : super(key: key);

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photos'), actions: <Widget>[
        Tooltip(
            message: 'Logout',
            child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  GoogleSignIn().signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                }))
      ]),
      body: const Center(
        child: Text('Photos go here'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PhotoForm()),
          );
        },
        tooltip: 'Add Photo',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
