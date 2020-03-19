import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';

part 'factor_report_detail_model.g.dart';

//因子异常申报单详情
@JsonSerializable()
class FactorReportDetail extends Equatable {
  @JsonKey(name: 'id')
  final int reportId; // 排口异常申报ID
  final int enterId; // 企业ID
  @JsonKey(name: 'outId')
  final int dischargeId; // 排口ID
  final int monitorId; // 监控点ID
  @JsonKey(name: 'enterpriseName', defaultValue: '')
  final String enterName; // 企业名称
  @JsonKey(name: 'entAddress', defaultValue: '')
  final String enterAddress; // 企业地址
  @JsonKey(name: 'disOutName', defaultValue: '')
  final String dischargeName; // 排口名称
  @JsonKey(name: 'disMonitorName', defaultValue: '')
  final String monitorName; // 监控点名称
  @JsonKey(defaultValue: '')
  final String cityName; // 所属市
  @JsonKey(defaultValue: '')
  final String areaName; // 所属区
  @JsonKey(name: 'updateTime', defaultValue: '')
  final String reportTimeStr; // 申报时间
  @JsonKey(name: 'startTime', defaultValue: '')
  final String startTimeStr; // 开始时间
  @JsonKey(name: 'endTime', defaultValue: '')
  final String endTimeStr; // 结束时间
  @JsonKey(defaultValue: '')
  final String alarmTypeStr; // 报警类型
  @JsonKey(defaultValue: '')
  final String factorCodeStr; // 异常因子
  @JsonKey(defaultValue: '')
  final String exceptionReason; // 异常原因
  @JsonKey(name: 'attachmentList')
  final List<Attachment> attachments; // 证明材料

  const FactorReportDetail({
    this.reportId,
    this.enterId,
    this.dischargeId,
    this.monitorId,
    this.enterName,
    this.enterAddress,
    this.dischargeName,
    this.monitorName,
    this.cityName,
    this.areaName,
    this.reportTimeStr,
    this.startTimeStr,
    this.endTimeStr,
    this.alarmTypeStr,
    this.factorCodeStr,
    this.exceptionReason,
    this.attachments,
  });

  @override
  List<Object> get props => [
        reportId,
        enterId,
        dischargeId,
        monitorId,
        enterName,
        enterAddress,
        dischargeName,
        monitorName,
        cityName,
        areaName,
        reportTimeStr,
        startTimeStr,
        endTimeStr,
        alarmTypeStr,
        factorCodeStr,
        exceptionReason,
        attachments,
      ];

  // 所属区域
  String get districtName {
    return '${cityName ?? ''}${areaName ?? ''}';
  }

  factory FactorReportDetail.fromJson(Map<String, dynamic> json) =>
      _$FactorReportDetailFromJson(json);

  Map<String, dynamic> toJson() => _$FactorReportDetailToJson(this);
}
