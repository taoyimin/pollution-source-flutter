import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pollution_source/page/login.dart';
import 'package:pollution_source/res/colors.dart';

void main() async {
  await SpUtil.getInstance();
  runApp(MyApp());
  //状态栏白色字体
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colours.primary_color,
        accentColor: Colours.accent_color,
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.dark,
      ),
      title: _title,
      home: LoginPage(),
    );
  }
}
