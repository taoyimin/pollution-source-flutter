import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'long_stop_report_list_model.g.dart';

//长期停产异常申报列表
@JsonSerializable()
class LongStopReport extends Equatable {
  @JsonKey(name: 'id')
  final int reportId; //申报单ID
  @JsonKey(name: 'enterpriseName')
  final String enterName; //企业名称
  final String cityName; // 所属市
  final String areaName; // 所属区
  final String startTimeStr; //开始时间
  final String endTimeStr; //结束时间
  final String reportTimeStr; //申报时间

  const LongStopReport({
    this.reportId,
    this.enterName,
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

  factory LongStopReport.fromJson(Map<String, dynamic> json) =>
      _$LongStopReportFromJson(json);

  Map<String, dynamic> toJson() => _$LongStopReportToJson(this);
}
