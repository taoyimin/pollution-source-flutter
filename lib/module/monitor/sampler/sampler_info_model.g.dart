// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sampler_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SamplerInfo _$SamplerInfoFromJson(Map<String, dynamic> json) {
  return SamplerInfo(
    monitorTime: json['monitor_time'] as String ?? '',
    status: json['i42001'] as String ?? '',
    mode: json['i42003'] as String ?? '',
    password: json['i42103'] as String ?? '',
    number: json['i43001'] as String ?? '',
    time: json['i43002'] as String ?? '',
    capacity: json['i43003'] as String ?? '',
  );
}

Map<String, dynamic> _$SamplerInfoToJson(SamplerInfo instance) =>
    <String, dynamic>{
      'monitor_time': instance.monitorTime,
      'i42001': instance.status,
      'i42003': instance.mode,
      'i42103': instance.password,
      'i43001': instance.number,
      'i43002': instance.time,
      'i43003': instance.capacity,
    };
