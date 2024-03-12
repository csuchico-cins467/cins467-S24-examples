import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: Center(
        child: getBody(),
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

  Widget getBody() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('photos').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.hasData) {
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Card(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(data['title']),
                  Text(data['description']),
                  Image.network(data['imageURL']),
                ],
              ));
            }).toList(),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
