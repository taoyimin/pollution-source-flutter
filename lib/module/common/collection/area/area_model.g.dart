// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Area _$AreaFromJson(Map<String, dynamic> json) {
  return Area(
    name: json['name'] as String ?? '',
    code: json['code'] as String ?? '',
    level: json['level'] as String ?? '',
    parent: json['parent'] as String ?? '',
    children: (json['children'] as List)
            ?.map((e) =>
                e == null ? null : Area.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$AreaToJson(Area instance) => <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'level': instance.level,
      'parent': instance.parent,
      'children': instance.children,
    };
