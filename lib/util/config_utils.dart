import 'package:flutter/material.dart';
import 'package:pollution_source/module/login/login_page.dart';
import 'package:pollution_source/module/login/login_page1.dart';

class ConfigUtils {
   static const String config = '江西';

  //static const String config = '高安';

  /// 获取登录页面
  static Widget getLoginPage() {
    switch (config) {
      case '江西':
        return LoginPage();
      case '高安':
        return LoginPage1();
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
        return '江西污染源监控移动应用';
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
        return false;
      default:
        return true;
    }
  }
}
