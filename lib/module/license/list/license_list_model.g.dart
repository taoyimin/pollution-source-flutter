// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

License _$LicenseFromJson(Map<String, dynamic> json) {
  return License(
      licenseId: json['licenseId'] as String,
      enterName: json['enterName'] as String,
      issueUnitStr: json['issueUnitStr'] as String,
      issueTimeStr: json['issueTimeStr'] as String,
      licenseTimeStr: json['licenseTimeStr'] as String,
      validTimeStr: json['validTimeStr'] as String,
      licenseManagerTypeStr: json['licenseManagerTypeStr'] as String,
      licenseNumber: json['licenseNumber'] as String);
}

Map<String, dynamic> _$LicenseToJson(License instance) => <String, dynamic>{
      'licenseId': instance.licenseId,
      'enterName': instance.enterName,
      'issueUnitStr': instance.issueUnitStr,
      'issueTimeStr': instance.issueTimeStr,
      'licenseTimeStr': instance.licenseTimeStr,
      'validTimeStr': instance.validTimeStr,
      'licenseManagerTypeStr': instance.licenseManagerTypeStr,
      'licenseNumber': instance.licenseNumber
    };
