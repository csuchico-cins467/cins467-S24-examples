import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      googleUser = googleUser;
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
        child: const Text('Sign in with Google'),
      ));
    } else {
      widgets.add(ListTile(
          leading: GoogleUserCircleAvatar(
            identity: googleUser!,
          ),
          title: Text(googleUser!.displayName ?? ""),
          subtitle: Text(googleUser!.email)));
      widgets.add(Text(FirebaseAuth.instance.currentUser?.uid ?? ""));
      widgets.add(ElevatedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          setState(() {
            googleUser = null;
          });
        },
        child: const Text('Logout'),
      ));
    }
    return widgets;
  }
}
