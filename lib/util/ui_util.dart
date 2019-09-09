import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

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
