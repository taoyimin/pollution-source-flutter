import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/common_model.dart';

part 'process_detail_model.g.dart';

/// 报警管理单处理流程
@JsonSerializable()
class Process extends Equatable {
  @JsonKey(name: 'dicSubName', defaultValue: '')
  final String operateTypeStr; // 操作类型
  @JsonKey(name: 'operateTime', defaultValue: '')
  final String operateTimeStr; // 操作时间
  @JsonKey(name: 'operatePersonName', defaultValue: '')
  final String operatePerson; // 反馈人
  @JsonKey(defaultValue: '')
  final String alarmCauseStr; // 报警原因
  @JsonKey(name: 'operateDesc', defaultValue: '')
  final String operateDesc; // 核时情况
  @JsonKey(name: 'attachmentList', defaultValue: [])
  final List<Attachment> attachments; // 附件

  const Process({
    @required this.operateTypeStr,
    @required this.operatePerson,
    @required this.alarmCauseStr,
    @required this.operateTimeStr,
    @required this.operateDesc,
    @required this.attachments,
  });

  @override
  List<Object> get props => [
        operateTypeStr,
        operatePerson,
        alarmCauseStr,
        operateTimeStr,
        operateDesc,
        attachments,
      ];

  factory Process.fromJson(Map<String, dynamic> json) =>
      _$ProcessFromJson(json);

  Map<String, dynamic> toJson() => _$ProcessToJson(this);
}
