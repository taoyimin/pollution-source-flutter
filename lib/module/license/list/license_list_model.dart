import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'license_list_model.g.dart';

//排污许可证列表
@JsonSerializable()
class License extends Equatable {
  final String licenseId; //排污许可证ID
  final String enterName; //企业名称
  final String issueUnitStr; //发证单位
  final String issueTimeStr; //发证时间
  final String licenseTimeStr; //领证时间
  final String validTimeStr; //有效期
  final String licenseManagerTypeStr; //许可证管理类别
  final String licenseNumber; //许可证编号

  const License({
    this.licenseId,
    this.enterName,
    this.issueUnitStr,
    this.issueTimeStr,
    this.licenseTimeStr,
    this.validTimeStr,
    this.licenseManagerTypeStr,
    this.licenseNumber,
  });

  @override
  List<Object> get props => [
        licenseId,
        enterName,
        issueUnitStr,
        issueTimeStr,
        licenseTimeStr,
        validTimeStr,
        licenseManagerTypeStr,
        licenseNumber,
      ];

  factory License.fromJson(Map<String, dynamic> json) =>
      _$LicenseFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseToJson(this);

  Map<String, dynamic> getMapInfo() => <String, dynamic>{
        '企业名称': this.enterName,
        '发证单位': this.issueUnitStr,
        '发证时间': this.issueTimeStr,
        '领证时间': this.licenseTimeStr,
        '有效期': this.validTimeStr,
        '许可证管理类别': this.licenseManagerTypeStr,
        '许可证编号': this.licenseNumber,
      };
}
