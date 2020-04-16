// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  return Attachment(
      fileName: json['fileName'] as String,
      url: json['showUrl'] as String,
      size: json['size'] as String);
}

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'showUrl': instance.url,
      'size': instance.size
    };

Process _$ProcessFromJson(Map<String, dynamic> json) {
  return Process(
      operateTypeStr: json['operateTypeStr'] as String,
      operatePerson: json['operatePerson'] as String,
      operateTimeStr: json['operateTimeStr'] as String,
      operateDesc: json['operateDesc'] as String,
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

PointData _$PointDataFromJson(Map<String, dynamic> json) {
  return PointData(
      x: (json['x'] as num)?.toDouble(), y: (json['y'] as num)?.toDouble());
}

Map<String, dynamic> _$PointDataToJson(PointData instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y};

DataDict _$DataDictFromJson(Map<String, dynamic> json) {
  return DataDict(
      code: json['dicSubCode'] as String, name: json['dicSubName'] as String);
}

Map<String, dynamic> _$DataDictToJson(DataDict instance) =>
    <String, dynamic>{'dicSubCode': instance.code, 'dicSubName': instance.name};

SystemConfig _$SystemConfigFromJson(Map<String, dynamic> json) {
  return SystemConfig(
      desc: json['dicDesc'] as String, value: json['dicValue'] as String);
}

Map<String, dynamic> _$SystemConfigToJson(SystemConfig instance) =>
    <String, dynamic>{'dicDesc': instance.desc, 'dicValue': instance.value};
