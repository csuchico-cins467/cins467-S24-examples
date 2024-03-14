import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navstack/first.dart';
import 'package:navstack/second.dart';

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FirstRoute(),
    ),
    GoRoute(
      path: '/second',
      builder: (context, state) => const SecondRoute(),
    ),
  ],
);

void main() {
  runApp(MaterialApp.router(
    title: 'Navigation Basics',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    routerConfig: _router,
  ));
}
