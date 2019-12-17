// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

License _$LicenseFromJson(Map<String, dynamic> json) {
  return License(
      licenseId: json['licenseId'].toString(),
      enterName: json['enterName'].toString(),
      issueUnitStr: json['issueUnitStr'].toString(),
      issueTimeStr: json['issueTimeStr'].toString(),
      licenseTimeStr: json['licenseTimeStr'].toString(),
      validTimeStr: json['validTimeStr'].toString(),
      licenseManagerTypeStr: json['licenseManagerTypeStr'].toString(),
      licenseNumber: json['licenseNumber'].toString());
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
