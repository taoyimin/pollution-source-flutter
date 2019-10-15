import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/module/common/common_model.dart';

//异常申报
class Report extends Equatable {
  //企业名称
  final String enterName;

  //监控点名称
  final String outletName;

  //异常类型
  final String abnormalType;

  //区域
  final String area;

  //申报开始时间
  final String startTime;

  //申报结束时间
  final String endTime;

  //申报时间
  final String reportTime;

  //审核状态
  final String state;

  //停产原因
  final String reason;

  //异常因子 只有因子异常申报才有值
  final String abnormalFactor;

  //标签集合
  final List<Label> labelList;

  Report({
    this.enterName = '',
    this.outletName = '',
    this.abnormalType = '',
    this.area = '',
    this.startTime = '',
    this.endTime = '',
    this.reportTime = '',
    this.state = '',
    this.reason = '',
    this.abnormalFactor = '',
    this.labelList,
  }) : super([
          enterName,
          outletName,
          abnormalType,
          area,
          startTime,
          endTime,
          reportTime,
          state,
          reason,
          abnormalFactor,
          labelList,
        ]);

  static Report fromJson(dynamic json) {
    return Report(
      enterName: '江西大唐国际新余发电有限责任公司',
      outletName: '1#机组',
      abnormalType: '其他原因',
      area: '新余市 市辖区',
      startTime: '2019-10-10 00:00',
      endTime: '2019-10-11 08:45',
      reportTime: '2019-10-11',
      state: '待审核',
      reason:
          '2号机组7:02并网发电，2号脱硫、除尘系统随机组启动运行，8:45达到脱硝投运条件，投入脱硝系统运行，2号机组启机期间氮氧化物超标2小时。',
      abnormalFactor: '二氧化硫 臭氧',
      labelList: TextUtil.isEmpty('二氧化硫 臭氧') ? [] : _getLabelList('二氧化硫 臭氧'),
    );
  }

  //将异常因子string转化成List
  static List<Label> _getLabelList(String string) {
    return string.trimLeft().trimRight().split(' ').map((string) {
      return Label(
        name: string,
        color: () {
          //获取随机颜色
          return Color.fromARGB(255, Random.secure().nextInt(255),
              Random.secure().nextInt(255), Random.secure().nextInt(255));
        }(),
      );
    }).toList();
  }
}
