import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/res/colors.dart';

//获取默认的阴影
BoxShadow getBoxShadow() {
  return const BoxShadow(
    offset: const Offset(0, 12),
    color: const Color(0xFFDFDFDF),
    blurRadius: 25,
    spreadRadius: -9,
  );
}

ClassicalHeader getRefreshClassicalHeader() {
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

ClassicalFooter getLoadClassicalFooter() {
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

//获取垂直分割线
Widget getVerticalDivider({
  double width: 0.6,
  double height: double.infinity,
  color: Colours.divider_color,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: DecoratedBox(
      decoration: BoxDecoration(color: color),
    ),
  );
}

//获取水平分割线
Widget getHorizontalDivider({
  double width: double.infinity,
  double height: 0.6,
  color: Colours.divider_color,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: DecoratedBox(
      decoration: BoxDecoration(color: color),
    ),
  );
}
