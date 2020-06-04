import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';

//异常申报单详情
class DischargeReportUpload extends Equatable {
  final Enter enter; //企业
  final Monitor monitor; //监控点
  final DateTime startTime; //开始时间
  final DateTime endTime; //结束时间
  final DataDict stopType; //异常类型
  final bool isShutdown; // 是否关停设备
  final String stopReason; //停产原因
  final List<Asset> attachments; //证明材料

  const DischargeReportUpload({
    this.enter,
    this.monitor,
    this.startTime,
    this.endTime,
    this.stopType,
    this.isShutdown,
    this.stopReason,
    this.attachments,
  });

  @override
  List<Object> get props => [
        enter,
        monitor,
        startTime,
        endTime,
        stopType,
        isShutdown,
        stopReason,
        attachments,
      ];

  DischargeReportUpload copyWith({
    Enter enter,
    Monitor monitor,
    DateTime reportTime,
    DateTime startTime,
    DateTime endTime,
    DataDict stopType,
    bool isShutdown,
    String stopReason,
    List<Asset> attachments,
  }) {
    return DischargeReportUpload(
      enter: enter ?? this.enter,
      monitor: monitor ?? this.monitor,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      stopType: stopType ?? this.stopType,
      stopReason: stopReason ?? this.stopReason,
      isShutdown: isShutdown ?? this.isShutdown,
      attachments: attachments ?? this.attachments,
    );
  }
}
