import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';

import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:encrypt/encrypt.dart' as XYQ;

class CommonUtils {
  /// 获取一个数组中的最大数
  static double getMax(List<double> items) {
    if (items.length == 0) return 0;
    double temp = items[0];
    items.forEach((item) {
      if (item > temp) {
        temp = item;
      }
    });
    return temp;
  }

  /// 获取一个数组中的最小数
  static double getMin(List<double> items) {
    if (items.length == 0) return 0;
    double temp = items[0];
    items.forEach((item) {
      if (item < temp) {
        temp = item;
      }
    });
    return temp;
  }

  /// 获取Y轴的间隔（坐标轴默认显示5个坐标）
  static double getYAxisInterval(List<ChartData> chartDataList) {
    double maxY = getMax(
        chartDataList.where((chartData) => chartData.checked).map((chartData) {
          return chartData.maxY;
        }).toList());
    double minY = getMin(
        chartDataList.where((chartData) => chartData.checked).map((chartData) {
          return chartData.minY;
        }).toList());
    return (maxY - minY) / (4);
  }

  /// 获取X轴的间隔（坐标轴默认显示7个坐标）
  static double getXAxisInterval(List<ChartData> chartDataList) {
    double maxX = getMax(
        chartDataList.where((chartData) => chartData.checked).map((chartData) {
          return chartData.maxX;
        }).toList());
    double minX = getMin(
        chartDataList.where((chartData) => chartData.checked).map((chartData) {
          return chartData.minX;
        })?.toList());
    return (maxX - minX) / (6);
  }

  /// 判断String是否是数字
  static bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  /// 获取定位信息的详细描述
  static String getDetailAddress(BaiduLocation baiduLocation) {
    if(baiduLocation == null){
      return '无';
    }else{
      return baiduLocation.province + baiduLocation.city + baiduLocation.district + baiduLocation.street + baiduLocation.address;
    }
  }

  /// 获取两个时间中更小的时间
  static DateTime getMaxDateTime(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime1 == null)
      return dateTime2;
    else if (dateTime2 == null)
      return dateTime1;
    else if (dateTime1.isAfter(dateTime2))
      return dateTime1;
    else
      return dateTime2;
  }

  /// 格式化文件大小
  static String formatSize(double value) {
    if (null == value) {
      return '未知大小';
    }
    List<String> unitArr = List()..add('B')..add('KB')..add('MB')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  /// 检查密码是否符合规范
  static bool checkPassword(String password){
    RegExp regExp = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[~!^&@#$%.?\*-\+=:,\\?\[\]\{}]).{8,}$');
    return regExp.hasMatch(password);
  }

  /// 对字符串进行MD5加密
  static String generateMD5(String string) {
    var content = new Utf8Encoder().convert(string);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  /// 对字符串进行AES加密
  static String generateAES(String string) {
    final key = XYQ.Key.fromUtf8(Constant.aesKey);
    final encrypter = XYQ.Encrypter(XYQ.AES(key, mode: XYQ.AESMode.ecb));
    return encrypter.encrypt(string).base64;
  }

  /// 根据当前用户级别返回默认查询的监控点类型
  static String getOutTypeByGobalLevel(){
    if(SpUtil.getString(Constant.spGobalLevel) == 'province'){
      // 省及用户默认查进口
      return '0';
    }else{
      // 其他用户默认差全部
      return '';
    }
  }
}
