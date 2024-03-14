import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';


class PhotoForm extends StatefulWidget {
  const PhotoForm({super.key});

  @override
  State<PhotoForm> createState() => _PhotoFormState();
}

class _PhotoFormState extends State<PhotoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _image;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  ImagePicker _picker = ImagePicker();
  late Future<Position> _futurePosition;

  @override
  initState() {
    super.initState();
    _futurePosition = _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Form')),
      body: Center(
        child: Form(key: _formKey, child: _buildForm()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Title'),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: 'Description'),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        SizedBox(
            height: 200,
            width: 200,
            child: _image != null
                ? Image.file(_image!)
                : Image.network(
                    "https://t3.ftcdn.net/jpg/02/48/42/64/360_F_248426448_NVKLywWqArG2ADUxDq6QprtIzsF82dMF.jpg")),
        FutureBuilder<Position>(
          future: _futurePosition,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                  'Latitude: ${snapshot.data!.latitude}, Longitude: ${snapshot.data!.longitude}');
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
        Text(FirebaseAuth.instance.currentUser!.uid),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  void _submitForm() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
      if (_image != null) {
        try {
          Position position = await _futurePosition;
          Uuid uuid = Uuid();
          String uuidString = uuid.v4();
          if (kDebugMode) {
            print(uuidString);
          }
          String downloadURL = await uploadFile(uuidString);
          await addItem(downloadURL, position);
          // Upload the image to Firebase Storage
          Navigator.pop(context);
        } catch (e) {
          if (kDebugMode) {
            print('Error getting position: $e');
          }
        }
        // Upload the image to Firebase Storage
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Take a Photo First')),
        );
      }
    }
  }

  Future<String> uploadFile(String uuidString) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('photos/$uuidString.jpg');
    final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: <String, String>{'file': 'image'},
        contentLanguage: 'en');
    UploadTask uploadTask = ref.putFile(_image!, metadata);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    if (kDebugMode) {
      print('File uploaded to $downloadURL');
    }
    return downloadURL;
  }

  Future<void> addItem(String downloadURL, Position position) async {
    CollectionReference photos =
        FirebaseFirestore.instance.collection('photos');
    await photos.add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imageURL': downloadURL,
      'location': GeoPoint(position.latitude, position.longitude),
      'user': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
