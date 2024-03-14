import 'package:flutter/material.dart';
import 'package:navstack/first.dart';
import 'package:navstack/second.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => FirstRoute(),
      '/second': (context) => SecondRoute(),
      '/second/second': (context) => SecondRoute(),
    },
  ));
}
