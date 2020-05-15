import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';

/// 异常申报单详情
class FactorReportUpload extends Equatable {
  final Enter enter; // 企业
  final Monitor monitor; // 监控点
  final List<DataDict> factorCodeList; // 异常因子
  final DateTime startTime; // 开始时间
  final DateTime endTime; // 结束时间
  final List<DataDict> alarmTypeList; // 异常类型
  final String exceptionReason; // 异常原因
  final List<Asset> attachments; // 证明材料

  const FactorReportUpload({
    this.enter,
    this.monitor,
    this.factorCodeList,
    this.startTime,
    this.endTime,
    this.alarmTypeList,
    this.exceptionReason,
    this.attachments,
  });

  @override
  List<Object> get props => [
        enter,
        monitor,
        factorCodeList,
        startTime,
        endTime,
        alarmTypeList,
        exceptionReason,
        attachments,
        // 传入时间戳，使得每次选择完异常类型和异常因子都触发状态改变
        DateTime.now(),
      ];

  FactorReportUpload copyWith({
    Enter enter,
    Monitor monitor,
    List<DataDict> factorCodeList,
    DateTime startTime,
    DateTime endTime,
    List<DataDict> alarmTypeList,
    String exceptionReason,
    List<Asset> attachments,
  }) {
    return FactorReportUpload(
      enter: enter ?? this.enter,
      monitor: monitor ?? this.monitor,
      factorCodeList: factorCodeList ?? this.factorCodeList,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      alarmTypeList: alarmTypeList ?? this.alarmTypeList,
      exceptionReason: exceptionReason ?? this.exceptionReason,
      attachments: attachments ?? this.attachments,
    );
  }
}
