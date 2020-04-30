import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';

/// 报警管理单流程上报
class ProcessUpload extends Equatable {
  final int orderId; // 报警管理单单Id
  final String alarmState; // 报警管理单状态
  final String operatePerson; // 操作人
  final String operateType; // 操作类型 -1:处理 0:审核通过 1:审核不通过
  final List<DataDict> alarmCauseList; // 报警原因
  final String operateDesc; // 操作描述
  final List<Asset> attachments; // 附件

  const ProcessUpload({
    this.orderId,
    this.alarmState,
    this.operatePerson,
    this.operateType,
    this.alarmCauseList,
    this.operateDesc,
    this.attachments,
  });

  @override
  List<Object> get props => [
        orderId,
        alarmState,
        operatePerson,
        operateType,
        alarmCauseList,
        operateDesc,
        attachments,
      ];

  ProcessUpload copyWith({
    int orderId,
    String alarmState,
    String operatePerson,
    String operateType,
    List<DataDict> alarmCauseList,
    String operateDesc,
    List<Asset> attachments,
  }) {
    return ProcessUpload(
      orderId: orderId ?? this.orderId,
      alarmState: alarmState ?? this.alarmState,
      operatePerson: operatePerson ?? this.operatePerson,
      operateType: operateType ?? this.operateType,
      alarmCauseList: alarmCauseList ?? this.alarmCauseList,
      operateDesc: operateDesc ?? this.operateDesc,
      attachments: attachments ?? this.attachments,
    );
  }
}
