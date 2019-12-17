// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'long_stop_report_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LongStopReportDetail _$LongStopReportDetailFromJson(Map<String, dynamic> json) {
  return LongStopReportDetail(
      reportId: json['reportId'].toString(),
      enterId: json['enterId'].toString(),
      enterName: json['enterName'].toString(),
      enterAddress: json['enterAddress'].toString(),
      districtName: json['districtName'].toString(),
      reportTimeStr: json['reportTimeStr'].toString(),
      startTimeStr: json['startTimeStr'].toString(),
      endTimeStr: json['endTimeStr'].toString(),
      remark: json['remark'].toString());
}

Map<String, dynamic> _$LongStopReportDetailToJson(
        LongStopReportDetail instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'enterId': instance.enterId,
      'enterName': instance.enterName,
      'enterAddress': instance.enterAddress,
      'districtName': instance.districtName,
      'reportTimeStr': instance.reportTimeStr,
      'startTimeStr': instance.startTimeStr,
      'endTimeStr': instance.endTimeStr,
      'remark': instance.remark
    };
