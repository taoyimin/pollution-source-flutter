import 'package:flutter/material.dart';
import 'package:pollution_source/module/login/login_page.dart';
import 'package:pollution_source/module/login/login_page_city.dart';

class ConfigUtils {
  static const String config = '江西';

  // static const String config = '高安';

  // static const String config = '万年';

  // static const String config = '贵溪';

  // static const String config = '测试';

  /// 获取污染源接口地址
  static String getPollutionBaseUrl() {
    switch (config) {
      case '江西':
        return 'http://111.75.227.207:19551/';
        // return 'http://106.225.129.166:8839/';
      case '高安':
        return 'http://115.149.164.211:9180/';
      case '万年':
        return 'http://223.83.222.189:9281/';
      case '贵溪':
        return 'http://115.153.156.134:9502/';
      default:
        return 'http://182.106.189.190:9999/';
      // return 'http://kevin.cn1.utools.club/';
    }
  }

  /// 获取运维接口地址
  static String getOperationBaseUrl() {
    switch (config) {
      case '江西':
        return 'http://111.75.227.207:19550/';
        // return 'http://106.225.129.166:8090/';
        // return 'http://taoyimin.iok.la:34261/';
      case '高安':
        return 'http://115.149.164.212:9181/';
        // return 'http://taoyimin.iok.la:34261/';
      case '万年':
        return '-';
      case '贵溪':
        return '-';
      default:
        return 'http://taoyimin.iok.la:34261/';
    }
  }

  /// 获取污染源更新接口地址
  static String getPollutionUpdateApi() {
    switch (config) {
      case '江西':
        return 'update/update-jiangxi.json';
      case '高安':
        return 'update/update-gaoan.json';
      case '万年':
        return 'update/update-wannian.json';
      case '贵溪':
        return 'update/update-guixi.json';
      default:
        return 'update/update-jiangxi.json';
    }
  }

  /// 获取运维更新接口地址
  static String getOperationUpdateApi() {
    switch (config) {
      case '江西':
        return 'app/update-jiangxi.json';
      case '高安':
        return 'app/update-gaoan.json';
      case '万年':
        return '-';
      case '贵溪':
        return '-';
      default:
        return 'app/update-jiangxi.json';
    }
  }

  /// 获取登录页面
  static Widget getLoginPage() {
    switch (config) {
      case '江西':
        return LoginPage();
      case '高安':
      case '万年':
      case '贵溪':
        return LoginPageCity();
      default:
        return LoginPage();
    }
  }

  /// 获取登录页面的标题
  static String getLoginTitle() {
    switch (config) {
      case '江西':
        return '江西污染源监控移动应用';
      case '高安':
        return '高安污染源监控移动应用';
      case '万年':
        return '万年污染源监控移动应用';
      case '贵溪':
        return '贵溪污染源监控移动应用';
      default:
        return '江西污染源监控移动应用';
    }
  }

  /// 获取登录页面的logo
  static String getLoginLogo() {
    switch (config) {
      case '江西':
        return 'assets/images/login_logo.png';
      case '高安':
      case '万年':
      case '贵溪':
        return 'assets/images/image_login_logo.png';
      default:
        return 'assets/images/login_logo.png';
    }
  }

  /// 获取登录页面的背景图片
  static String getLoginBackground() {
    switch (config) {
      case '江西':
        return 'assets/images/background_login.png';
      case '高安':
      case '万年':
      case '贵溪':
        return 'assets/images/background_login1.jpg';
      default:
        return 'assets/images/background_login.png';
    }
  }

  /// 获取环保用户首页图片
  static Widget getAdminIndexImageWidget() {
    switch (config) {
      case '江西':
        return Positioned(
          right: 0,
          bottom: 0,
          child: Image.asset(
            'assets/images/image_admin_index_header.png',
            width: 150,
            fit: BoxFit.fill,
          ),
        );
      case '高安':
      case '万年':
      case '贵溪':
        return Positioned(
          right: 16,
          bottom: 10,
          child: Image.asset(
            'assets/images/image_admin_index_header1.png',
            width: 150,
            fit: BoxFit.fill,
          ),
        );
      default:
        return Positioned(
          right: 0,
          bottom: 0,
          child: Image.asset(
            'assets/images/image_admin_index_header.png',
            width: 150,
            fit: BoxFit.fill,
          ),
        );
    }
  }

  /// 获取企业用户首页图片
  static Widget getEnterIndexImageWidget() {
    switch (config) {
      case '江西':
        return Positioned(
          right: 20,
          bottom: 10,
          child: Image.asset(
            'assets/images/image_enter_index_header.png',
            height: 105,
          ),
        );
      case '高安':
      case '万年':
      case '贵溪':
        return Positioned(
          right: 20,
          bottom: 10,
          child: Image.asset(
            'assets/images/image_enter_index_header1.png',
            height: 110,
          ),
        );
      default:
        return Positioned(
          right: 20,
          bottom: 10,
          child: Image.asset(
            'assets/images/image_enter_index_header.png',
            height: 105,
          ),
        );
    }
  }

  /// 获取运维用户首页图片
  static Widget getOperationIndexImageWidget() {
    switch (config) {
      case '江西':
        return Positioned(
          right: 0,
          bottom: 20,
          child: Image.asset(
            'assets/images/image_operation_index_header.png',
            width: 180,
            fit: BoxFit.fill,
          ),
        );
      case '高安':
      case '万年':
      case '贵溪':
        return Positioned(
          right: 20,
          bottom: 10,
          child: Image.asset(
            'assets/images/image_operation_index_header1.png',
            width: 150,
            fit: BoxFit.fill,
          ),
        );
      default:
        return Positioned(
          right: 0,
          bottom: 20,
          child: Image.asset(
            'assets/images/image_operation_index_header.png',
            width: 150,
            fit: BoxFit.fill,
          ),
        );
    }
  }

  /// 获取应用页顶部图片
  static String getApplicationHeaderImage() {
    switch (config) {
      case '江西':
        return 'assets/images/image_application_header.png';
      case '高安':
      case '万年':
      case '贵溪':
        return 'assets/images/image_application_header1.png';
      default:
        return 'assets/images/image_application_header.png';
    }
  }

  /// 是否显示企业门户相关功能
  static bool showEnter() {
    switch (config) {
      case '江西':
        return true;
      case '高安':
        return true;
      case '万年':
        return false;
      case '贵溪':
        return false;
      default:
        return true;
    }
  }

  /// 是否显示运维系统相关功能
  static bool showOperation() {
    switch (config) {
      case '江西':
        return true;
      case '高安':
        return true;
      case '万年':
        return false;
      case '贵溪':
        return false;
      default:
        return true;
    }
  }

  /// 是否显示常规巡检
  static bool showRoutineInspection() {
    switch (config) {
      case '江西':
        return true;
      case '高安':
      case '万年':
      case '贵溪':
        return false;
      default:
        return true;
    }
  }

  /// 应用页是否显示地图
  static bool showMap() {
    switch (config) {
      case '江西':
        return false;
      case '高安':
      case '万年':
      case '贵溪':
        return false;
      default:
        return true;
    }
  }
}
