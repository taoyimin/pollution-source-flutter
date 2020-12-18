import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pollution_source/page/admin_home.dart';
import 'package:pollution_source/page/enter_home.dart';
import 'package:pollution_source/page/operation_home.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/config_utils.dart';
import 'module/common/list/list_bloc.dart';
import 'module/warn/list/warn_list_page.dart';
import 'module/warn/list/warn_list_repository.dart';

/// 应用程序入口
///
/// 在这里初始化[SpUtil]实例，并且设置系统UI样式为[SystemUiOverlayStyle.light]
/// 全局状态栏使用白色字体
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  /*if(Platform.isIOS){
    BMFMapSDK.setApiKeyAndCoordType(
        '请输入百度开放平台申请的iOS端API KEY', BMF_COORD_TYPE.BD09LL);
  }else if(Platform.isAndroid){
    BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);}*/
  await SpUtil.getInstance();
  runApp(MyApp());
}

/// 应用程序最外层Widget
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

/// 应用程序最外层Widget状态
///
/// 在构造方法中初始化[FluroRouter]路由类和[Application]
/// [build]方法最外层包裹一层[OKToast]用于弹出吐司
/// 并且在[MaterialApp]中设置程序的中文本地化，主题样式和路由
class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // 初始化路由
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
    // 初始化JPush
    JPush jpush = JPush();
    jpush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {},
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        navigatorKey.currentState.push(MaterialPageRoute(
            builder: (context) => BlocProvider<ListBloc>(
                  create: (BuildContext context) =>
                      ListBloc(listRepository: WarnListRepository()),
                  child: WarnListPage(),
                )));
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {},
    );
    jpush.setup(
      appKey: 'eb5a21dcceead742e52f47a5',
      production: Constant.inProduction,
      debug: !Constant.inProduction, // 设置是否打印 debug 日志
    );
    jpush.applyPushAuthority();
    // 初始化日志类
    LogUtil.init(isDebug: !Constant.inProduction);
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: MaterialApp(
          navigatorKey: navigatorKey,
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
            // 设置中文和英文的基准线一致
            textTheme: const TextTheme(
              subtitle1: TextStyle(textBaseline: TextBaseline.alphabetic),
            ),
          ),
//          onGenerateRoute: Application.router.generator,
          home: () {
            int userType = SpUtil.getInt(Constant.spUserType, defValue: -1);
            int userId = SpUtil.getInt(Constant.spUserId, defValue: -1);
            if (userType != -1 &&
                userId != -1 &&
                !TextUtil.isEmpty(
                    SpUtil.getString(Constant.spUsernameList[userType])) &&
                !TextUtil.isEmpty(
                    SpUtil.getString(Constant.spPasswordList[userType]))) {
              // 如果userType、userId、userName、passWord都不为空，则跳过登录直接进入主页
              switch (userType) {
                case 0:
                  return AdminHomePage();
                case 1:
                  return EnterHomePage(enterId: '$userId');
                case 2:
                  return OperationHomePage();
                default:
                  return ConfigUtils.getLoginPage();
              }
            } else {
              return ConfigUtils.getLoginPage();
            }
          }(),
        ),
      ),
    );
  }
}
