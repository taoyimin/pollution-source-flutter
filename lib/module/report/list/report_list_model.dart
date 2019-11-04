import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/module/common/common_model.dart';

//异常申报列表
class Report extends Equatable {
  final String reportId; //申报单ID
  final String enterName; //企业名称
  final String outletName; //监控点名称
  final String abnormalType; //异常类型
  final String areaName; //区域
  final String startTime; //开始时间
  final String endTime; //结束时间
  final String reportTime; //申报时间
  final String state; //审核状态
  final String reason; //停产原因
  final String abnormalFactor; //异常因子 只有因子异常申报才有值
  final List<Label> labelList; //标签集合

  const Report({
    this.reportId,
    this.enterName,
    this.outletName,
    this.abnormalType,
    this.areaName,
    this.startTime,
    this.endTime,
    this.reportTime,
    this.state,
    this.reason,
    this.abnormalFactor,
    this.labelList,
  });

  @override
  List<Object> get props => [
        reportId,
        enterName,
        outletName,
        abnormalType,
        areaName,
        startTime,
        endTime,
        reportTime,
        state,
        reason,
        abnormalFactor,
        labelList,
      ];

  static Report fromJson(dynamic json) {
    return Report(
      reportId: '100',
      enterName: '江西大唐国际新余发电有限责任公司',
      outletName: '1#机组',
      abnormalType: '其他原因',
      areaName: '新余市 市辖区',
      startTime: '2019-10-10 00:00',
      endTime: '2019-10-11 08:45',
      reportTime: '2019-10-11',
      state: '待审核',
      reason:
          '2号机组7:02并网发电，2号脱硫、除尘系统随机组启动运行，8:45达到脱硝投运条件，投入脱硝系统运行，2号机组启机期间氮氧化物超标2小时。',
      abnormalFactor: '二氧化硫 臭氧',
      labelList:
          TextUtil.isEmpty('二氧化硫 臭氧') ? const [] : _getLabelList('二氧化硫 臭氧'),
    );
  }

  //将异常因子string转化成List
  static List<Label> _getLabelList(String string) {
    return string.trimLeft().trimRight().split(' ').map((string) {
      return Label(
        name: string,
        color: Colors.pink,
      );
    }).toList();
  }
}
