// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemConfig _$SystemConfigFromJson(Map<String, dynamic> json) {
  return SystemConfig(
      name: json['dicDesc'] as String, code: json['dicValue'] as String);
}

Map<String, dynamic> _$SystemConfigToJson(SystemConfig instance) =>
    <String, dynamic>{'dicDesc': instance.name, 'dicValue': instance.code};
