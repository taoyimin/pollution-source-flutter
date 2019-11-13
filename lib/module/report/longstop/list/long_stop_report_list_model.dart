import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/res/constant.dart';

//长期停产异常申报列表
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

  static LongStopReport fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return LongStopReport(
        reportId: '-',
        enterName: '-',
        districtName: '-',
        startTimeStr: '-',
        endTimeStr: '-',
        reportTimeStr: '-',
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
  }
}
