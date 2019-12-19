import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discharge_report_list_model.g.dart';

//排口异常申报列表
@JsonSerializable()
class DischargeReport extends Equatable {
  final String reportId; //申报单ID
  final String enterName; //企业名称
  final String monitorName; //监控点名称
  final String stopTypeStr; //异常类型
  final String districtName; //区域
  final String startTimeStr; //开始时间
  final String endTimeStr; //结束时间
  final String reportTimeStr; //申报时间

  const DischargeReport({
    this.reportId,
    this.enterName,
    this.monitorName,
    this.stopTypeStr,
    this.districtName,
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
        districtName,
        startTimeStr,
        endTimeStr,
        reportTimeStr,
      ];

  factory DischargeReport.fromJson(Map<String, dynamic> json) => _$DischargeReportFromJson(json);

  Map<String, dynamic> toJson() => _$DischargeReportToJson(this);

  /*static DischargeReport fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spUseJavaApi, defValue: Constant.defaultUseJavaApi)) {
      return DischargeReport(
        reportId: json['stopApplyId'].toString(),
        enterName: json['enterpriseName'],
        monitorName: json['disMonitorName'],
        stopTypeStr: json['stopTypeStr'],
        districtName: json['cityName']+json['areaName'],
        startTimeStr: json['startTimeStr'],
        endTimeStr: json['endTimeStr'],
        reportTimeStr: json['applayTimeStr'],
      );
    } else {
      return DischargeReport(
        reportId: json['reportId'],
        enterName: json['enterName'],
        monitorName: json['monitorName'],
        stopTypeStr: json['stopTypeStr'],
        districtName: json['districtName'],
        startTimeStr: json['startTimeStr'],
        endTimeStr: json['endTimeStr'],
        reportTimeStr: json['reportTimeStr'],
      );
    }
  }*/
}
