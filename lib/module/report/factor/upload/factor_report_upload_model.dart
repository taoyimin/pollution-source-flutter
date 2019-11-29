import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';

//异常申报单详情
class FactorReportUpload extends Equatable {
  final Discharge discharge; //排口
  final Monitor monitor; //监控点
  final String factorCode; //异常因子
  final DateTime startTime; //开始时间
  final DateTime endTime; //结束时间
  final int alarmType; //异常类型
  final String exceptionReason; //异常原因
  final List<Asset> attachments; //证明材料

  static List<String> alarmTypeList = [
    '联网异常',
    '超标异常',
    '连续恒指',
    '零值',
    '负值',
    '超大值'
  ];

  const FactorReportUpload({
    this.discharge,
    this.monitor,
    this.factorCode,
    this.startTime,
    this.endTime,
    this.alarmType,
    this.exceptionReason,
    this.attachments,
  });

  @override
  List<Object> get props => [
        discharge,
        monitor,
        factorCode,
        startTime,
        endTime,
        alarmType,
        exceptionReason,
        attachments,
      ];

  FactorReportUpload copyWith({
    Discharge discharge,
    Monitor monitor,
    String factorCode,
    DateTime startTime,
    DateTime endTime,
    int alarmType,
    String exceptionReason,
    List<Asset> attachments,
  }) {
    return FactorReportUpload(
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

enum AlarmType { lianwang, chaobiao, hengzhi, lingzhi, fuzhi, chaodazhi }
