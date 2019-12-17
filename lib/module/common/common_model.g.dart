// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  return Attachment(
      fileName: json['fileName'].toString(),
      url: json['url'].toString(),
      size: json['size'] as int);
}

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'url': instance.url,
      'size': instance.size
    };

Process _$ProcessFromJson(Map<String, dynamic> json) {
  return Process(
      operateTypeStr: json['operateTypeStr'].toString(),
      operatePerson: json['operatePerson'].toString(),
      operateTimeStr: json['operateTimeStr'].toString(),
      operateDesc: json['operateDesc'].toString(),
      attachments: (json['attachments'] as List)
          ?.map((e) =>
              e == null ? null : Attachment.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ProcessToJson(Process instance) => <String, dynamic>{
      'operateTypeStr': instance.operateTypeStr,
      'operatePerson': instance.operatePerson,
      'operateTimeStr': instance.operateTimeStr,
      'operateDesc': instance.operateDesc,
      'attachments': instance.attachments
    };
