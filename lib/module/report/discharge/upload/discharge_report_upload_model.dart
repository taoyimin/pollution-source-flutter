import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';

//异常申报单详情
class DischargeReportUpload extends Equatable {
  final String enterId; //企业id
  final Discharge discharge; //排口
  final Monitor monitor; //监控点
  final DateTime reportTime; //申报时间
  final DateTime startTime; //开始时间
  final DateTime endTime; //结束时间
  final DataDict stopType; //异常类型
  final String stopReason; //停产原因
  final List<Asset> attachments; //证明材料

//  static List<String> stopTypeList = [
//    '停产',
//    '设备故障',
//    '未安装在线设备',
//    '无外排',
//    '其他原因',
//    '停产监察笔录'
//  ];

  const DischargeReportUpload({
    this.enterId,
    this.discharge,
    this.monitor,
    this.reportTime,
    this.startTime,
    this.endTime,
    this.stopType,
    this.stopReason,
    this.attachments,
  });

  @override
  List<Object> get props => [
        enterId,
        discharge,
        monitor,
        reportTime,
        startTime,
        endTime,
        stopType,
        stopReason,
        attachments,
      ];

  DischargeReportUpload copyWith({
    String enterId,
    Discharge discharge,
    Monitor monitor,
    DateTime reportTime,
    DateTime startTime,
    DateTime endTime,
    DataDict stopType,
    String stopReason,
    List<Asset> attachments,
  }) {
    return DischargeReportUpload(
      enterId: enterId ?? this.enterId,
      discharge: discharge ?? this.discharge,
      monitor: monitor ?? this.monitor,
      reportTime: reportTime ?? this.reportTime,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      stopType: stopType ?? this.stopType,
      stopReason: stopReason ?? this.stopReason,
      attachments: attachments ?? this.attachments,
    );
  }
}

//enum StopType { tingchan, guzhang, weianzhuang, wuwaipai, qita, jiancha }
