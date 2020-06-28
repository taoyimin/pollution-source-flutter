import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';

part 'discharge_report_detail_model.g.dart';

/// 排口异常申报单详情
@JsonSerializable()
class DischargeReportDetail extends Equatable {
  @JsonKey(name: 'stopApplyId')
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
  @JsonKey(name: 'applayTimeStr', defaultValue: '')
  final String reportTimeStr; // 申报时间
  @JsonKey(defaultValue: '')
  final String startTimeStr; // 开始时间
  @JsonKey(defaultValue: '')
  final String endTimeStr; // 结束时间
  @JsonKey(defaultValue: '')
  final String stopTypeStr; // 异常类型
  @JsonKey(name: 'isShutdown', defaultValue: '')
  final String isShutdownStr; // 是否关停设备
  @JsonKey(defaultValue: '')
  final String stopReason; // 停产原因
  @JsonKey(name: 'attachmentList', defaultValue: [])
  final List<Attachment> attachments; // 证明材料

  const DischargeReportDetail({
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
    this.stopTypeStr,
    this.isShutdownStr,
    this.stopReason,
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
        stopTypeStr,
        isShutdownStr,
        stopReason,
        attachments,
      ];

  /// 所属区域
  String get districtName {
    return '${cityName ?? ''}${areaName ?? ''}';
  }

  factory DischargeReportDetail.fromJson(Map<String, dynamic> json) =>
      _$DischargeReportDetailFromJson(json);

  Map<String, dynamic> toJson() => _$DischargeReportDetailToJson(this);
}
