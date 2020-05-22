import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/res/gaps.dart';

/// UI工具类
///
/// 用于获取通用样式，通用widget不放在这里，放在common包中
/// 自定义widget不放在这里，放在widget包中
class UIUtils {
  /// 获取默认的阴影
  static BoxShadow getBoxShadow() {
    return const BoxShadow(
      offset: const Offset(0, 12),
      color: const Color(0xFFDFDFDF),
      blurRadius: 25,
      spreadRadius: -9,
    );
  }

  /// 获取[PopupMenuButton]的下拉菜单
  ///
  /// [icon]是下拉菜单的图标，[text] 下拉菜单的文字
  /// [id]是下拉菜单的id，用于区分点击的菜单
  static Widget getSelectView(IconData icon, String text, String id) {
    return PopupMenuItem<String>(
      value: id,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(icon, color: Colors.blue),
          Gaps.hGap6,
          Text(text),
        ],
      ),
    );
  }

  /// 获取随机颜色
  static Color getRandomColor() {
    return Color.fromARGB(255, Random.secure().nextInt(255),
        Random.secure().nextInt(255), Random.secure().nextInt(255));
  }

  /// 获取下拉刷新header
  static ClassicalHeader getRefreshClassicalHeader() {
    return ClassicalHeader(
      refreshText: "拉动刷新",
      refreshReadyText: "释放刷新",
      refreshingText: "正在刷新...",
      refreshedText: "刷新完成",
      refreshFailedText: "刷新失败",
      noMoreText: "没有更多数据",
      infoText: "更新于 %T",
    );
  }

  /// 获取上拉加载footer
  static ClassicalFooter getLoadClassicalFooter() {
    return ClassicalFooter(
      loadText: "拉动加载",
      loadReadyText: "释放加载",
      loadingText: "正在加载...",
      loadedText: "加载完成",
      loadFailedText: "加载失败",
      noMoreText: "没有更多数据",
      infoText: "更新于 %T",
    );
  }

  static Color getAlarmFlagColor(String alarmFlag) {
    switch (alarmFlag) {
      case '0':
        // 正常
        return Colors.black;
      case '1':
        // 预警
        // return Color.fromRGBO(241, 190, 67, 1);
        return Colors.orangeAccent;
      case '2':
        // 超标
        // return Color.fromRGBO(233, 119, 111, 1);
        return Colors.red;
      case '3':
        // 负值（原极小值）
        // return Color.fromRGBO(0, 188, 212, 1);
        return Colors.red;
      case '4':
        // 超大值（原极大值）
        // return Color.fromRGBO(255, 87, 34, 1);
        return Colors.red;
      case '5':
        // 零值
        // return Color.fromRGBO(106, 106, 255, 1);
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  static Label getOrderAlarmIcon(String string) {
    switch (string) {
      case '连续恒值':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_type_constant_value.png',
            color: Colors.green);
      case '超标异常':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_type_outrange_error.png',
            color: Colors.red);
      case '超大值':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_type_large_value.png',
            color: Colors.pink);
      case '联网异常':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_type_connect_error.png',
            color: Colors.orange);
      case '零值':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_type_zero_value.png',
            color: Colors.blue);
      case '负值':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_type_negative_value.png',
            color: Colors.cyan);
      case '设备故障':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_cause_device_error.png',
            color: Colors.deepOrangeAccent);
      case '设备校准':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_cause_correct.png',
            color: Colors.lightGreen);
      case '接口松动':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_cause_device_offline.png',
            color: Colors.brown);
      case '超低排放':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_pollution_water_outlet.png',
            color: Colors.purpleAccent);
      case '低于检出限':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_cause_lower_limit.png',
            color: Colors.lightBlueAccent);
      case '停产':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_cause_stopline.png',
            color: Colors.pinkAccent);
      case '停电':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_cause_power_failure.png',
            color: Colors.amber);
      case '网络故障':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_cause_net_error.png',
            color: Colors.grey);
      case '稳定排放':
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_cause_stable_discharge.png',
            color: Colors.teal);
      default:
        return Label(
            name: string,
            imagePath: 'assets/images/icon_alarm_type_unknow.png',
            color: Colors.grey);
    }
  }
}
