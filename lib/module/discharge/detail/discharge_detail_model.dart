import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discharge_detail_model.g.dart';

/// 排口详情
@JsonSerializable()
class DischargeDetail extends Equatable {
  @JsonKey(name: 'outId')
  final int dischargeId; // 排口ID
  final int enterId; // 企业ID
  @JsonKey(name: 'enterpriseName', defaultValue: '')
  final String enterName; // 企业名称
  @JsonKey(name: 'entAddress', defaultValue: '')
  final String enterAddress; // 企业地址
  @JsonKey(name: 'disOutName', defaultValue: '')
  final String dischargeName; // 排口名称
  @JsonKey(name: 'disOutId', defaultValue: '')
  final String dischargeNumber; // 排口编号
  @JsonKey(name: 'disOutRuleStr', defaultValue: '')
  final String dischargeRuleStr; // 排放规律
  @JsonKey(defaultValue: '')
  final String denoterInstallTypeStr; // 标志牌安装形式
  @JsonKey(name: 'disOutTypeStr', defaultValue: '')
  final String dischargeTypeStr; // 监测类型
  @JsonKey(name: 'outletTypeStr', defaultValue: '')
  final String dischargeCategoryStr; // 排口类型
  @JsonKey(defaultValue: '')
  final String outTypeStr; // 排放类别
  final int dischargeReportTotalCount; // 排口异常申报个数
  final int factorReportTotalCount; // 因子异常申报个数

  const DischargeDetail({
    this.dischargeId,
    this.enterId,
    this.enterName,
    this.enterAddress,
    this.dischargeName,
    this.dischargeNumber,
    this.dischargeTypeStr,
    this.dischargeCategoryStr,
    this.dischargeRuleStr,
    this.outTypeStr,
    this.denoterInstallTypeStr,
    this.dischargeReportTotalCount,
    this.factorReportTotalCount,
  });

  @override
  List<Object> get props => [
        dischargeId,
        enterId,
        enterName,
        enterAddress,
        dischargeName,
        dischargeNumber,
        dischargeTypeStr,
        dischargeCategoryStr,
        dischargeRuleStr,
        outTypeStr,
        denoterInstallTypeStr,
        dischargeReportTotalCount,
        factorReportTotalCount,
      ];

  factory DischargeDetail.fromJson(Map<String, dynamic> json) =>
      _$DischargeDetailFromJson(json);

  Map<String, dynamic> toJson() => _$DischargeDetailToJson(this);
}
