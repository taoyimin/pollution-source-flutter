// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  return Attachment(
    fileName: json['fileName'] as String,
    url: json['showUrl'] as String,
    size: json['size'] as String,
  );
}

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'showUrl': instance.url,
      'size': instance.size,
    };

PointData _$PointDataFromJson(Map<String, dynamic> json) {
  return PointData(
    x: (json['x'] as num)?.toDouble(),
    y: (json['y'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PointDataToJson(PointData instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };

SystemConfig _$SystemConfigFromJson(Map<String, dynamic> json) {
  return SystemConfig(
    desc: json['dicDesc'] as String,
    value: json['dicValue'] as String,
  );
}

Map<String, dynamic> _$SystemConfigToJson(SystemConfig instance) =>
    <String, dynamic>{
      'dicDesc': instance.desc,
      'dicValue': instance.value,
    };
