// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitor_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonitorStatistics _$MonitorStatisticsFromJson(Map<String, dynamic> json) {
  return MonitorStatistics(
      name: json['name'] as String,
      code: json['code'] as String,
      count: json['cnt'] as int);
}

Map<String, dynamic> _$MonitorStatisticsToJson(MonitorStatistics instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'cnt': instance.count
    };
