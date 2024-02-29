import 'package:flutter/material.dart';
import 'package:navstack/first.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    home: const FirstRoute(),
  ));
}
