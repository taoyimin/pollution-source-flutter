import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notice_list_model.g.dart';

/// 消息通知
@JsonSerializable()
class Notice extends Equatable {
  @JsonKey(defaultValue: '')
  final String title; //通知标题
  @JsonKey(defaultValue: '')
  final String text; //通知描述
  @JsonKey(defaultValue: '')
  final String content; //通知内容
  @JsonKey(name: 'updateTime', defaultValue: '')
  final String time; //通知时间

  Notice({this.title, this.text, this.content, this.time});

  @override
  List<Object> get props => [title, text, content, time];

  factory Notice.fromJson(Map<String, dynamic> json) =>
      _$NoticeFromJson(json);

  Map<String, dynamic> toJson() => _$NoticeToJson(this);

  Map<String, dynamic> getMapInfo() => <String, dynamic>{
    '通知标题': this.title,
    '通知时间': this.time,
    '通知描述\n': this.text,
    '通知内容\n': this.content,
  };
}
