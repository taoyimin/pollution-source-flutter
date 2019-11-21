import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'long_stop_report_detail_model.g.dart';

//异常申报单详情
@JsonSerializable()
class LongStopReportDetail extends Equatable {
  final String reportId; //排口异常申报ID
  final String enterId; //企业ID
  final String enterName; //企业名称
  final String enterAddress; //企业地址
  final String districtName; //区域
  final String reportTimeStr; //申报时间
  final String startTimeStr; //开始时间
  final String endTimeStr; //结束时间
  final String remark; //备注

  const LongStopReportDetail({
    this.reportId,
    this.enterId,
    this.enterName,
    this.enterAddress,
    this.districtName,
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
        districtName,
        reportTimeStr,
        startTimeStr,
        endTimeStr,
        remark,
      ];

  factory LongStopReportDetail.fromJson(Map<String, dynamic> json) =>
      _$LongStopReportDetailFromJson(json);

  Map<String, dynamic> toJson() => _$LongStopReportDetailToJson(this);

  /*static LongStopReportDetail fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return LongStopReportDetail(
        reportId: json['stopApply']['stopApplyId'],
        enterId: json['stopApply']['enterId'],
        enterName: json['stopApply']['enterpriseName'],
        enterAddress: '-',
        districtName: json['cityName']+json['areaName'],
        reportTimeStr: json['stopApply']['applayTimeStr'],
        startTimeStr: json['stopApply']['startTimeStr'],
        endTimeStr: json['stopApply']['endTimeStr'],
        remark: json['stopApply']['remark'],
      );
    } else {
      return LongStopReportDetail(
        reportId: json['reportId'],
        enterId: json['enterId'],
        enterName: json['enterName'],
        enterAddress: json['enterAddress'],
        districtName: json['districtName'],
        reportTimeStr: json['reportTimeStr'],
        startTimeStr: json['startTimeStr'],
        endTimeStr: json['endTimeStr'],
        remark: json['remark'],
      );
    }
  }*/
}
