import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';

//异常申报单详情
class FactorReportUpload extends Equatable {
  final String enterId; //企业Id
  final Discharge discharge; //排口
  final Monitor monitor; //监控点
  final List<DataDict> factorCode; //异常因子
  final DateTime startTime; //开始时间
  final DateTime endTime; //结束时间
  final DataDict alarmType; //异常类型
  final String exceptionReason; //异常原因
  final List<Asset> attachments; //证明材料

  const FactorReportUpload({
    this.enterId,
    this.discharge,
    this.monitor,
    @required this.factorCode,
    this.startTime,
    this.endTime,
    this.alarmType,
    this.exceptionReason,
    this.attachments,
  }) : assert(factorCode != null);

  @override
  List<Object> get props => [
        enterId,
        discharge,
        monitor,
        factorCode?.length,
        startTime,
        endTime,
        alarmType,
        exceptionReason,
        attachments,
        // 传入时间戳，使得每次选择完异常因子都触发状态改变
        DateTime.now(),
      ];

  FactorReportUpload copyWith({
    String enterId,
    Discharge discharge,
    Monitor monitor,
    List<DataDict> factorCode,
    DateTime startTime,
    DateTime endTime,
    DataDict alarmType,
    String exceptionReason,
    List<Asset> attachments,
  }) {
    return FactorReportUpload(
      enterId: enterId ?? this.enterId,
      discharge: discharge ?? this.discharge,
      monitor: monitor ?? this.monitor,
      factorCode: factorCode ?? this.factorCode,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      alarmType: alarmType ?? this.alarmType,
      exceptionReason: exceptionReason ?? this.exceptionReason,
      attachments: attachments ?? this.attachments,
    );
  }
}
