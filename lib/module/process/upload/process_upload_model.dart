import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

//报警管理单流程上报
class ProcessUpload extends Equatable {
  final String orderId; //报警管理单单Id
  final String operatePerson; //操作人
  final String operateType; //操作类型
  final String operateDesc; //操作描述
  final List<Asset> attachments; //附件

  const ProcessUpload({
    this.orderId,
    this.operatePerson,
    this.operateType,
    this.operateDesc,
    this.attachments,
  });

  @override
  List<Object> get props => [
        orderId,
        operatePerson,
        operateType,
        operateDesc,
        attachments,
      ];

  ProcessUpload copyWith({
    String orderId,
    String operatePerson,
    String operateType,
    String operateDesc,
    List<Asset> attachments,
  }) {
    return ProcessUpload(
      orderId: orderId ?? this.orderId,
      operatePerson: operatePerson ?? this.operatePerson,
      operateType: operateType ?? this.operateType,
      operateDesc: operateDesc ?? this.operateDesc,
      attachments: attachments ?? this.attachments,
    );
  }
}
