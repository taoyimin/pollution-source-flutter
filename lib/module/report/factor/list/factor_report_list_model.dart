import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';

part 'factor_report_list_model.g.dart';

//因子异常申报列表
@JsonSerializable()
class FactorReport extends Equatable {
  final String reportId; //申报单ID
  final String enterName; //企业名称
  final String monitorName; //监控点名称
  final String alarmTypeStr; //报警类型
  final String districtName; //区域
  final String startTimeStr; //开始时间
  final String endTimeStr; //结束时间
  final String reportTimeStr; //申报时间
  final String factorCodeStr; //异常因子

  const FactorReport({
    this.reportId,
    this.enterName,
    this.monitorName,
    this.alarmTypeStr,
    this.districtName,
    this.startTimeStr,
    this.endTimeStr,
    this.reportTimeStr,
    this.factorCodeStr,
    //this.labelList,
  });

  @override
  List<Object> get props => [
        reportId,
        enterName,
        monitorName,
        alarmTypeStr,
        districtName,
        startTimeStr,
        endTimeStr,
        reportTimeStr,
        factorCodeStr,
        //labelList,
      ];

  List<Label> get labelList{
    return TextUtil.isEmpty(factorCodeStr)
        ? const []
        : _getLabelList(factorCodeStr);
  }

  factory FactorReport.fromJson(Map<String, dynamic> json) =>
      _$FactorReportFromJson(json);

  Map<String, dynamic> toJson() => _$FactorReportToJson(this);

  /*static FactorReport fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return FactorReport(
        reportId: json['stopApplyId'].toString(),
        enterName: json['enterpriseName'],
        monitorName: json['disMonitorName'],
        alarmTypeStr: json['stopTypeStr'],
        districtName: json['cityName']+json['areaName'],
        startTimeStr: json['startTimeStr'],
        endTimeStr: json['endTimeStr'],
        reportTimeStr: json['applayTimeStr'],
        labelList: TextUtil.isEmpty(json['factorName']) ? const [] : _getLabelList(json['factorName']),
      );
    } else {
      return FactorReport(
        reportId: json['reportId'],
        enterName: json['enterName'],
        monitorName: json['monitorName'],
        alarmTypeStr: json['alarmTypeStr'],
        districtName: json['districtName'],
        startTimeStr: json['startTimeStr'],
        endTimeStr: json['endTimeStr'],
        reportTimeStr: json['reportTimeStr'],
        labelList: TextUtil.isEmpty(json['factorCodeStr'])
            ? const []
            : _getLabelList(json['factorCodeStr']),
      );
    }
  }*/

  //将异常因子string转化成List
  static List<Label> _getLabelList(String string) {
    return string.trim().split(' ').map((string) {
      return Label(
        name: string,
        color: Colors.pink,
      );
    }).toList();
  }
}
