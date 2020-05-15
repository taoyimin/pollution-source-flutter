import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';

/// 长期停产上报
class LongStopReportUpload extends Equatable {
  final Enter enter; // 企业
  final DateTime startTime; // 开始时间
  final DateTime endTime; // 结束时间
  final String remark; // 备注
  final List<Asset> attachments; // 证明材料

  const LongStopReportUpload({
    this.enter,
    this.startTime,
    this.endTime,
    this.remark,
    this.attachments,
  });

  @override
  List<Object> get props => [
        enter,
        startTime,
        endTime,
        remark,
        attachments,
      ];

  LongStopReportUpload copyWith({
    Enter enter,
    DateTime startTime,
    DateTime endTime,
    String remark,
    List<Asset> attachments,
  }) {
    return LongStopReportUpload(
      enter: enter ?? this.enter,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      remark: remark ?? this.remark,
      attachments: attachments ?? this.attachments,
    );
  }
}
