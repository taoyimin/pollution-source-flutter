// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

License _$LicenseFromJson(Map<String, dynamic> json) {
  return License(
      licenseId: json['licenseId'] as int,
      enterName: json['enterpriseName'] as String,
      issueUnitStr: json['issueUnitName'] as String,
      issueTimeStr: json['issueTime'] as String,
      licenseTimeStr: json['licenseTime'] as String,
      validStartTime: json['validStartTime'] as String,
      validEndTime: json['validEndTime'] as String,
      licenseManagerTypeStr: json['licenceManagementType'] as String,
      licenseNumber: json['licenseNumber'] as String);
}

Map<String, dynamic> _$LicenseToJson(License instance) => <String, dynamic>{
      'licenseId': instance.licenseId,
      'enterpriseName': instance.enterName,
      'issueUnitName': instance.issueUnitStr,
      'issueTime': instance.issueTimeStr,
      'licenseTime': instance.licenseTimeStr,
      'validStartTime': instance.validStartTime,
      'validEndTime': instance.validEndTime,
      'licenceManagementType': instance.licenseManagerTypeStr,
      'licenseNumber': instance.licenseNumber
    };
