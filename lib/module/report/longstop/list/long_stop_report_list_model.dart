import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'long_stop_report_list_model.g.dart';

//长期停产异常申报列表
@JsonSerializable()
class LongStopReport extends Equatable {
  final String reportId; //申报单ID
  final String enterName; //企业名称
  final String districtName; //区域
  final String startTimeStr; //开始时间
  final String endTimeStr; //结束时间
  final String reportTimeStr; //申报时间

  const LongStopReport({
    this.reportId,
    this.enterName,
    this.districtName,
    this.startTimeStr,
    this.endTimeStr,
    this.reportTimeStr,
  });

  @override
  List<Object> get props => [
        reportId,
        enterName,
        districtName,
        startTimeStr,
        endTimeStr,
        reportTimeStr,
      ];

  factory LongStopReport.fromJson(Map<String, dynamic> json) =>
      _$LongStopReportFromJson(json);

  Map<String, dynamic> toJson() => _$LongStopReportToJson(this);

  /*static LongStopReport fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return LongStopReport(
        reportId: json['stopApplyId'].toString(),
        enterName: json['enterpriseName'],
        districtName: json['cityName']+json['areaName'],
        startTimeStr: json['startTimeStr'],
        endTimeStr: json['endTimeStr'],
        reportTimeStr: json['applayTimeStr'],
      );
    } else {
      return LongStopReport(
        reportId: json['reportId'],
        enterName: json['enterName'],
        districtName: json['districtName'],
        startTimeStr: json['startTimeStr'],
        endTimeStr: json['endTimeStr'],
        reportTimeStr: json['reportTimeStr'],
      );
    }
  }*/
}
