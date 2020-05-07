import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/common_model.dart';

part 'process_detail_model.g.dart';

/// 报警管理单处理流程
@JsonSerializable()
class Process extends Equatable {
  @JsonKey(name: 'dicSubName', defaultValue: '')
  final String operateTypeStr; // 处理类型
  @JsonKey(name: 'operateTime', defaultValue: '')
  final String operateTimeStr; // 处理时间
  @JsonKey(name: 'operatePersonName', defaultValue: '')
  final String operatePerson; // 反馈人
  @JsonKey(defaultValue: '')
  final String alarmCauseStr; // 报警原因
  @JsonKey(defaultValue: '')
  final String operateResult; // 处理结果
  @JsonKey(name: 'operateDesc', defaultValue: '')
  final String operateDesc; // 核实情况
  @JsonKey(name: 'attachmentList', defaultValue: [])
  final List<Attachment> attachments; // 附件

  const Process({
    @required this.operateTypeStr,
    @required this.operatePerson,
    @required this.alarmCauseStr,
    @required this.operateResult,
    @required this.operateTimeStr,
    @required this.operateDesc,
    @required this.attachments,
  });

  @override
  List<Object> get props => [
        operateTypeStr,
        operatePerson,
        alarmCauseStr,
        operateResult,
        operateTimeStr,
        operateDesc,
        attachments,
      ];

  factory Process.fromJson(Map<String, dynamic> json) =>
      _$ProcessFromJson(json);

  Map<String, dynamic> toJson() => _$ProcessToJson(this);

  Map<String, dynamic> getMapInfo() => <String, dynamic>{
        '处理类型': this.operateTypeStr,
        '处理时间': this.operateTimeStr,
        '处理结果': this.operateResult,
        '反馈人': this.operatePerson,
        '报警原因': this.alarmCauseStr,
        '核实情况': this.operateDesc,
        '附件地址': this.attachments?.map((attachment) => attachment.url)?.join('\n') ?? '',
      };
}
