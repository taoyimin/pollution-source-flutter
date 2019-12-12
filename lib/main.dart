import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';

void main() async {
  //初始化SpUtil
  await SpUtil.getInstance();
  runApp(MyApp());
  //状态栏白色字体
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppState() {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        //设置中文本地化
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
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
        onGenerateRoute: Application.router.generator,
      ),
    );
  }
}

/*class MyApp extends StatelessWidget {
  MyApp() {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        //设置中文本地化
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
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
        onGenerateRoute: Application.router.generator,
      ),
    );
  }
}*/
