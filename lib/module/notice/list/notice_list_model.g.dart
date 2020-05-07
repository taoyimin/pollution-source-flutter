// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notice _$NoticeFromJson(Map<String, dynamic> json) {
  return Notice(
    title: json['title'] as String ?? '',
    text: json['text'] as String ?? '',
    content: json['content'] as String ?? '',
    time: json['updateTime'] as String ?? '',
  );
}

Map<String, dynamic> _$NoticeToJson(Notice instance) => <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
      'content': instance.content,
      'updateTime': instance.time,
    };
