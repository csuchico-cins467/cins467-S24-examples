import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navstack/components/drawer.dart';
import 'package:navstack/second.dart';

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      // drawer: getDrawer(context, context.widget),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            context.go('/second');
          },
        ),
      ),
    );
  }
}
