import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'warn_detail_model.g.dart';

/// 实时预警单详情
@JsonSerializable()
class WarnDetail extends Equatable {
  final int enterId; // 企业ID
  final int monitorId; // 监控点ID
  @JsonKey(defaultValue: '')
  final String enterName; // 企业名
  @JsonKey(defaultValue: '')
  final String monitorName; // 监控点名
  @JsonKey(name:'createDate', defaultValue: '')
  final String createTimeStr; // 生成时间
  @JsonKey(name:'startTime', defaultValue: '')
  final String startTimeStr; // 开始时间
  @JsonKey(name:'endTime', defaultValue: '')
  final String endTimeStr; // 结束时间
  @JsonKey(defaultValue: '')
  final String title; // 预警标题
  @JsonKey(defaultValue: '')
  final String text; // 预警详情
  @JsonKey(defaultValue: '')
  final String cityName; // 市名称
  @JsonKey(defaultValue: '')
  final String areaName; // 区名称
  @JsonKey(defaultValue: '')
  final String attentionLevelStr; // 关注程度

  WarnDetail({
    this.enterId,
    this.monitorId,
    this.enterName,
    this.monitorName,
    this.createTimeStr,
    this.startTimeStr,
    this.endTimeStr,
    this.title,
    this.text,
    this.cityName,
    this.areaName,
    this.attentionLevelStr,
  });

  @override
  List<Object> get props => [
        enterId,
        monitorId,
        enterName,
        monitorName,
        createTimeStr,
        startTimeStr,
        endTimeStr,
        title,
        text,
        cityName,
        areaName,
        attentionLevelStr,
      ];

  /// 所属区域
  String get districtName {
    return '${cityName ?? ''}${areaName ?? ''}';
  }

  factory WarnDetail.fromJson(Map<String, dynamic> json) =>
      _$WarnDetailFromJson(json);

  Map<String, dynamic> toJson() => _$WarnDetailToJson(this);
}
