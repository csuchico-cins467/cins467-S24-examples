import 'package:flutter/material.dart';

class PhotoForm extends StatefulWidget {
  const PhotoForm({super.key});

  @override
  State<PhotoForm> createState() => _PhotoFormState();
}

class _PhotoFormState extends State<PhotoForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Form')),
      body: const Center(
        child: Text('Form goes here'),
      ),
    );
  }
}
