import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'long_stop_report_detail_model.g.dart';

//异常申报单详情
@JsonSerializable()
class LongStopReportDetail extends Equatable {
  @JsonKey(name: 'id')
  final int reportId; //排口异常申报ID
  final int enterId; //企业ID
  @JsonKey(name: 'enterpriseName')
  final String enterName; //企业名称
  @JsonKey(name: 'entAddress')
  final String enterAddress; //企业地址
  final String cityName; // 所属市
  final String areaName; // 所属区
  final String reportTimeStr; //申报时间
  final String startTimeStr; //开始时间
  final String endTimeStr; //结束时间
  final String remark; //备注

  const LongStopReportDetail({
    this.reportId,
    this.enterId,
    this.enterName,
    this.enterAddress,
    this.cityName,
    this.areaName,
    this.reportTimeStr,
    this.startTimeStr,
    this.endTimeStr,
    this.remark,
  });

  @override
  List<Object> get props => [
        reportId,
        enterId,
        enterName,
        enterAddress,
        cityName,
        areaName,
        reportTimeStr,
        startTimeStr,
        endTimeStr,
        remark,
      ];

  String get districtName {
    return '${cityName??''}${areaName??''}';
  }

  factory LongStopReportDetail.fromJson(Map<String, dynamic> json) =>
      _$LongStopReportDetailFromJson(json);

  Map<String, dynamic> toJson() => _$LongStopReportDetailToJson(this);
}
