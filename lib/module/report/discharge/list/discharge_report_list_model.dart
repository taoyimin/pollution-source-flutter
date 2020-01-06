import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discharge_report_list_model.g.dart';

//排口异常申报列表
@JsonSerializable()
class DischargeReport extends Equatable {
  @JsonKey(name: 'stopApplyId')
  final int reportId; // 申报单ID
  @JsonKey(name: 'enterpriseName')
  final String enterName; // 企业名称
  @JsonKey(name: 'disMonitorName')
  final String monitorName; // 监控点名称
  final String stopTypeStr; // 异常类型
  final String cityName; // 所属市
  final String areaName; // 所属区
  final String startTimeStr; // 开始时间
  final String endTimeStr; // 结束时间
  @JsonKey(name: 'applayTimeStr')
  final String reportTimeStr; // 申报时间

  const DischargeReport({
    this.reportId,
    this.enterName,
    this.monitorName,
    this.stopTypeStr,
    this.cityName,
    this.areaName,
    this.startTimeStr,
    this.endTimeStr,
    this.reportTimeStr,
  });

  @override
  List<Object> get props => [
        reportId,
        enterName,
        monitorName,
        stopTypeStr,
        cityName,
        areaName,
        startTimeStr,
        endTimeStr,
        reportTimeStr,
      ];

  // 所属区域
  String get districtName {
    return '${cityName??''}${areaName??''}';
  }

  factory DischargeReport.fromJson(Map<String, dynamic> json) => _$DischargeReportFromJson(json);

  Map<String, dynamic> toJson() => _$DischargeReportToJson(this);
}
