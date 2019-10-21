import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

///获取一些通用的样式
///通用widget不放在这里，放在common包中
///自定义widget不放在这里，放在widget包中

class UIUtils {
  //获取默认的阴影
  static BoxShadow getBoxShadow() {
    return const BoxShadow(
      offset: const Offset(0, 12),
      color: const Color(0xFFDFDFDF),
      blurRadius: 25,
      spreadRadius: -9,
    );
  }

  static Widget getSelectView(IconData icon, String text, String id) {
    return PopupMenuItem<String>(
      value: id,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(icon, color: Colors.blue),
          Text(text),
        ],
      ),
    );
  }

  //获取随机颜色
  static Color getRandomColor() {
    return Color.fromARGB(255, Random.secure().nextInt(255),
        Random.secure().nextInt(255), Random.secure().nextInt(255));
  }

  //下拉刷新header
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

  //上拉加载footer
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
}

//显示SnackBar
void showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  var snackBar = SnackBar(
    content: Text(message),
    action: SnackBarAction(
        label: '我知道了',
        onPressed: () {
          // do something to undo
        }),
  );
  scaffoldKey.currentState.showSnackBar(snackBar);
}
