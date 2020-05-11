import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/collection/law/mobile_law_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';

/// 报警管理单流程上报
class ProcessUpload extends Equatable {
  final int orderId; // 报警管理单单Id
  final String alarmState; // 报警管理单状态
  final String operateType; // 操作类型 -1:处理 0:审核通过 1:审核不通过
  final List<DataDict> alarmCauseList; // 报警原因
  final List<MobileLaw> mobileLawList; // 移动执法
  final String operateDesc; // 操作描述
  final List<Asset> attachments; // 附件

  const ProcessUpload({
    this.orderId,
    this.alarmState,
    this.operateType,
    this.alarmCauseList = const <DataDict>[],
    this.mobileLawList = const <MobileLaw>[],
    this.operateDesc,
    this.attachments = const <Asset>[],
  });

  @override
  List<Object> get props => [
        orderId,
        alarmState,
        operateType,
        alarmCauseList,
        mobileLawList,
        operateDesc,
        attachments,
      ];

  ProcessUpload copyWith({
    int orderId,
    String alarmState,
    String operateType,
    List<DataDict> alarmCauseList,
    List<MobileLaw> mobileLawList,
    String operateDesc,
    List<Asset> attachments,
  }) {
    return ProcessUpload(
      orderId: orderId ?? this.orderId,
      alarmState: alarmState ?? this.alarmState,
      operateType: operateType ?? this.operateType,
      alarmCauseList: alarmCauseList ?? this.alarmCauseList,
      mobileLawList: mobileLawList ?? this.mobileLawList,
      operateDesc: operateDesc ?? this.operateDesc,
      attachments: attachments ?? this.attachments,
    );
  }
}
