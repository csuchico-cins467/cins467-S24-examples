import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_example/pictures.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? googleUser;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    googleUser = await GoogleSignIn().signIn();

    if (kDebugMode) {
      print(googleUser!.displayName);
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    setState(() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PhotosPage()),
        (Route<dynamic> route) => false,
      );
    });

    // Once signed in, return the UserCredential
    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    List<Widget> widgets = [];
    if (googleUser == null) {
      widgets.add(ElevatedButton(
          onPressed: () async {
            await signInWithGoogle();
          },
          child: const Image(
            image: AssetImage('assets/android_dark_rd_SI@3x.png'),
            width: 200,
          )));
    } else {
      widgets.add(const Text("How'd you get here?"));
    }
    return widgets;
  }
}
