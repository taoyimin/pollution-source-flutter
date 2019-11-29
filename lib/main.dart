import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pollution_source/page/login.dart';
import 'package:pollution_source/res/colors.dart';

void main() async {
  //初始化SpUtil
  await SpUtil.getInstance();
  runApp(MyApp());
  //状态栏白色字体
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

//This Widget is the main application widget.
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale.fromSubtags(languageCode: 'zh'),
        ],
        theme: ThemeData(
          primaryColor: Colours.primary_color,
          accentColor: Colours.accent_color,
          brightness: Brightness.light,
          primaryColorBrightness: Brightness.dark,
        ),
        home: LoginPage(),
      ),
    );
  }
}
