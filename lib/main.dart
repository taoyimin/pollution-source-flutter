import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';

/// 应用程序入口
///
/// 在这里初始化[SpUtil]实例，并且设置系统UI样式为[SystemUiOverlayStyle.light]
/// 全局状态栏使用白色字体
void main() async {
  await SpUtil.getInstance();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(MyApp());
}

/// 应用程序最外层Widget
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

/// 应用程序最外层Widget状态
///
/// 在构造方法中初始化[Router]路由类和[Application]
/// [build]方法最外层包裹一层[OKToast]用于弹出吐司
/// 并且在[MaterialApp]中设置程序的中文本地化，主题样式和路由
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
