import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mobile_law_model.g.dart';

/// 移动执法类
@JsonSerializable()
class MobileLaw extends Equatable {
  final int id;
  @JsonKey(name: 'zfid', defaultValue: '')
  final String lawId;
  @JsonKey(name: 'wrymc', defaultValue: '')
  final String enterName;
  @JsonKey(name: 'rwlx', defaultValue: '')
  final String taskTypeStr;
  @JsonKey(name: 'jcr', defaultValue: '')
  final String lawPersonStr;
  @JsonKey(name: 'kssj', defaultValue: '')
  final String startTimeStr;
  @JsonKey(name: 'jssj', defaultValue: '')
  final String endTimeStr;

  MobileLaw({
    this.id,
    this.lawId,
    this.enterName,
    this.taskTypeStr,
    this.lawPersonStr,
    this.startTimeStr,
    this.endTimeStr,
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
      ];

  factory MobileLaw.fromJson(Map<String, dynamic> json) =>
      _$MobileLawFromJson(json);

  Map<String, dynamic> toJson() => _$MobileLawToJson(this);
}
