import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/res/constant.dart';

//异常申报单详情
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

  static LongStopReportDetail fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return LongStopReportDetail(
        reportId: '-',
        enterId: '-',
        enterName: '-',
        enterAddress: '-',
        districtName: '-',
        reportTimeStr: '-',
        startTimeStr: '-',
        endTimeStr: '-',
        remark: '-',
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
  }
}
