import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navstack/components/drawer.dart';
import 'package:navstack/first.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      // drawer: getDrawer(context, context.widget),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //this will cause issues as second is the only thing here
            context.go('/');
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
