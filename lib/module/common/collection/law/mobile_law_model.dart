import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mobile_law_model.g.dart';

/// 移动执法类
@JsonSerializable()
class MobileLaw extends Equatable {
  final int id;
  @JsonKey(name: 'zfid', defaultValue: '')
  final String lawId; //执法id
  @JsonKey(name: 'wrymc', defaultValue: '')
  final String enterName; // 污染源名称
  @JsonKey(name: 'rwlx', defaultValue: '')
  final String taskTypeStr; // 任务类型
  @JsonKey(name: 'jcr', defaultValue: '')
  final String lawPersonStr; // 检查人
  @JsonKey(name: 'kssj', defaultValue: '')
  final String startTimeStr; // 检查开始时间
  @JsonKey(name: 'jssj', defaultValue: '')
  final String endTimeStr; // 检查结束时间
  @JsonKey(name: 'lhbjcxj', defaultValue: '')
  final String summary; // 留痕表监察小结

  MobileLaw({
    this.id,
    this.lawId,
    this.enterName,
    this.taskTypeStr,
    this.lawPersonStr,
    this.startTimeStr,
    this.endTimeStr,
    this.summary,
  });

  @override
  List<Object> get props => [
        id,
        lawId,
        enterName,
        taskTypeStr,
        lawPersonStr,
        startTimeStr,
        endTimeStr,
        summary,
      ];

  factory MobileLaw.fromJson(Map<String, dynamic> json) =>
      _$MobileLawFromJson(json);

  Map<String, dynamic> toJson() => _$MobileLawToJson(this);

  Map<String, dynamic> getMapInfo() => <String, dynamic>{
        '执法ID': this.lawId,
        '污染源名称': this.enterName,
        '检查人': this.lawPersonStr,
        '任务类型': this.taskTypeStr,
        '开始时间': this.startTimeStr,
        '结束时间': this.endTimeStr,
        '留痕表监察小结': this.summary,
      };
}
