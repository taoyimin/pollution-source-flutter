import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';

//part 'monitor_detail_model.g.dart';

//监控点详情
//@JsonSerializable()
class MonitorDetail extends Equatable {
  final int enterId; //企业ID
  @JsonKey(name: 'outId')
  final int dischargeId; //排口ID
  final int monitorId; //监控点ID
  @JsonKey(name: 'enterpriseName')
  final String enterName; //企业名称
  @JsonKey(name: 'entAddress')
  final String enterAddress; //企业地址
  @JsonKey(name: 'disMonitorName')
  final String monitorName; //监控点名称
  @JsonKey(name: 'disMonitorTypeStr')
  final String monitorTypeStr; //监控点类型
  @JsonKey(name: 'outletTypeStr')
  final String monitorCategoryStr; //监控点类别
  @JsonKey(name: 'networkTypeName')
  final String networkTypeStr; //网络类型
  @JsonKey(name: 'disMonitorAddress')
  final String monitorAddress; //监控点地
  final String mnCode; //数采仪编码
  final String orderCompleteCount; //报警管理单已办结数量
  final String orderTotalCount; //报警管理单全部数量
  final String dischargeReportTotalCount; //排口异常申报单全部数量
  final String factorReportTotalCount; //因子异常申报单全部数量
  final List<ChartData> chartDataList; //图表数据

  const MonitorDetail({
    this.enterId,
    this.dischargeId,
    this.monitorId,
    this.enterName,
    this.enterAddress,
    this.monitorName,
    this.monitorTypeStr,
    this.monitorCategoryStr,
    this.networkTypeStr,
    this.monitorAddress,
    this.mnCode,
    this.orderCompleteCount,
    this.orderTotalCount,
    this.dischargeReportTotalCount,
    this.factorReportTotalCount,
    this.chartDataList,
  });

  @override
  List<Object> get props => [
        enterId,
        dischargeId,
        monitorId,
        enterName,
        enterAddress,
        monitorName,
        monitorTypeStr,
        monitorCategoryStr,
        networkTypeStr,
        monitorAddress,
        mnCode,
        orderCompleteCount,
        orderTotalCount,
        dischargeReportTotalCount,
        factorReportTotalCount,
        chartDataList,
      ];

  MonitorDetail copyWith({
    List<ChartData> chartDataList,
  }) {
    return MonitorDetail(
      enterId: this.enterId,
      dischargeId: this.dischargeId,
      monitorId: this.monitorId,
      enterName: this.enterName,
      enterAddress: this.enterAddress,
      monitorName: this.monitorName,
      monitorTypeStr: this.monitorTypeStr,
      monitorCategoryStr: this.monitorCategoryStr,
      networkTypeStr: this.networkTypeStr,
      monitorAddress: this.monitorAddress,
      mnCode: this.mnCode,
      orderCompleteCount: this.orderCompleteCount,
      orderTotalCount: this.orderTotalCount,
      dischargeReportTotalCount: this.dischargeReportTotalCount,
      factorReportTotalCount: this.factorReportTotalCount,
      chartDataList: chartDataList ?? this.chartDataList,
    );
  }

  factory MonitorDetail.fromJson(Map<String, dynamic> json) =>
      _$MonitorDetailFromJson(json);

  Map<String, dynamic> toJson() => _$MonitorDetailToJson(this);
}

MonitorDetail _$MonitorDetailFromJson(Map<String, dynamic> json) {
  return MonitorDetail(
      enterId: json['disChargeMonitor']['enterId'] as int,
      dischargeId: json['disChargeMonitor']['outId'] as int,
      monitorId: json['disChargeMonitor']['monitorId'] as int,
      enterName: json['disChargeMonitor']['enterpriseName'] as String,
      enterAddress: json['disChargeMonitor']['entAddress'] as String,
      monitorName: json['disChargeMonitor']['disMonitorName'] as String,
      monitorTypeStr: json['disChargeMonitor']['disMonitorTypeStr'] as String,
      monitorCategoryStr: json['disChargeMonitor']['outletTypeStr'] as String,
      networkTypeStr: json['disChargeMonitor']['networkTypeName'] as String,
      monitorAddress: json['disChargeMonitor']['disMonitorAddress'] as String,
      mnCode: json['disChargeMonitor']['mnCode'] as String,
      orderCompleteCount: json['disChargeMonitor']['orderCompleteCount'] as String,
      orderTotalCount: json['disChargeMonitor']['orderTotalCount'] as String,
      dischargeReportTotalCount: json['disChargeMonitor']['dischargeReportTotalCount'] as String,
      factorReportTotalCount: json['disChargeMonitor']['factorReportTotalCount'] as String,
      chartDataList: (json['chartDataList'] as List)
          ?.map((e) =>
      e == null ? null : ChartData.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$MonitorDetailToJson(MonitorDetail instance) =>
    <String, dynamic>{
      'enterId': instance.enterId,
      'outId': instance.dischargeId,
      'monitorId': instance.monitorId,
      'enterpriseName': instance.enterName,
      'entAddress': instance.enterAddress,
      'disMonitorName': instance.monitorName,
      'disMonitorTypeStr': instance.monitorTypeStr,
      'outletTypeStr': instance.monitorCategoryStr,
      'networkTypeName': instance.networkTypeStr,
      'disMonitorAddress': instance.monitorAddress,
      'mnCode': instance.mnCode,
      'orderCompleteCount': instance.orderCompleteCount,
      'orderTotalCount': instance.orderTotalCount,
      'dischargeReportTotalCount': instance.dischargeReportTotalCount,
      'factorReportTotalCount': instance.factorReportTotalCount,
      'chartDataList': instance.chartDataList
    };
