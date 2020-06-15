// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_law_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileLaw _$MobileLawFromJson(Map<String, dynamic> json) {
  return MobileLaw(
    number: json['number'] as String ?? '',
    lawId: json['zfid'] as String ?? '',
    enterName: json['wrymc'] as String ?? '',
    taskTypeStr: json['rwlx'] as String ?? '',
    lawPersonStr: json['jcr'] as String ?? '',
    startTimeStr: json['kssj'] as String ?? '',
    endTimeStr: json['jssj'] as String ?? '',
    summary: json['lhbjcxj'] as String ?? '',
  );
}

Map<String, dynamic> _$MobileLawToJson(MobileLaw instance) => <String, dynamic>{
      'number': instance.number,
      'zfid': instance.lawId,
      'wrymc': instance.enterName,
      'rwlx': instance.taskTypeStr,
      'jcr': instance.lawPersonStr,
      'kssj': instance.startTimeStr,
      'jssj': instance.endTimeStr,
      'lhbjcxj': instance.summary,
    };
