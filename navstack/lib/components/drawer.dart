import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navstack/first.dart';
import 'package:navstack/second.dart';

Widget getDrawer(context, widget) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        ListTile(
          title: const Text('Page 1'),
          onTap: () {
            widget.goNamed('/');
          },
        ),
        ListTile(
          title: const Text('Page 2'),
          onTap: () {
            widget.goNamed('/second');
          },
        ),
      ],
    ),
  );
}
