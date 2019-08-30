import 'package:flutter/material.dart';
import 'package:pollution_source/page/login.dart';
import 'package:pollution_source/res/colors.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colours.primary_color,
        accentColor: Colours.accent_color,
      ),
      title: _title,
      home: LoginPage(),
    );
  }
}