import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';

part 'factor_report_list_model.g.dart';

//因子异常申报列表
@JsonSerializable()
class FactorReport extends Equatable {
  @JsonKey(name: 'id')
  final int reportId; //申报单ID
  @JsonKey(name: 'enterpriseName')
  final String enterName; //企业名称
  @JsonKey(name: 'disMonitorName')
  final String monitorName; //监控点名称
  final String alarmTypeStr; //报警类型
  final String cityName; // 所属市
  final String areaName; // 所属区
  @JsonKey(name: 'startTime')
  final String startTimeStr; //开始时间
  @JsonKey(name: 'endTime')
  final String endTimeStr; //结束时间
  @JsonKey(name: 'updateTime')
  final String reportTimeStr; //申报时间
  @JsonKey(name: 'factorCode')
  final String factorCodeStr; //异常因子

  const FactorReport({
    this.reportId,
    this.enterName,
    this.monitorName,
    this.alarmTypeStr,
    this.cityName,
    this.areaName,
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
        cityName,
        areaName,
        startTimeStr,
        endTimeStr,
        reportTimeStr,
        factorCodeStr,
        //labelList,
      ];

  List<Label> get labelList {
    return TextUtil.isEmpty(factorCodeStr)
        ? const []
        : _getLabelList(factorCodeStr);
  }

  // 所属区域
  String get districtName {
    return '${cityName ?? ''}${areaName ?? ''}';
  }

  factory FactorReport.fromJson(Map<String, dynamic> json) =>
      _$FactorReportFromJson(json);

  Map<String, dynamic> toJson() => _$FactorReportToJson(this);

  /*static FactorReport fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spUseJavaApi, defValue: Constant.defaultUseJavaApi)) {
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
