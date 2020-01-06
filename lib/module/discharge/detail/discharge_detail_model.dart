import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discharge_detail_model.g.dart';

//排口详情
@JsonSerializable()
class DischargeDetail extends Equatable {
  @JsonKey(name: 'outId')
  final int dischargeId; //排口ID
  final int enterId; //企业ID
  @JsonKey(name: 'enterpriseName')
  final String enterName; //企业名称
  @JsonKey(name: 'entAddress')
  final String enterAddress; //企业地址
  @JsonKey(name: 'disOutName')
  final String dischargeName; //排口名称
  @JsonKey(name: 'disOutShortName')
  final String dischargeShortName; //排口简称
  @JsonKey(name: 'disOutAddress')
  final String dischargeAddress; //排口地址
  @JsonKey(name: 'disOutId')
  final String dischargeNumber; //排口编号
  @JsonKey(name: 'disOutRuleStr')
  final String dischargeRuleStr; //排放规律
  final String denoterInstallTypeStr; //标志牌安装形式
  @JsonKey(name: 'disOutTypeStr')
  final String dischargeTypeStr; //排口类型
  @JsonKey(name: 'outletTypeStr')
  final String dischargeCategoryStr; //排口类别
  final String outTypeStr; //排放类别
  @JsonKey(name: 'disOutLongitude')
  final String longitude; //经度
  @JsonKey(name: 'disOutLatitude')
  final String latitude; //纬度
  final int dischargeReportTotalCount; //排口异常申报个数
  final int factorReportTotalCount; //因子异常申报个数

  const DischargeDetail({
    this.dischargeId,
    this.enterId,
    this.enterName,
    this.enterAddress,
    this.dischargeName,
    this.dischargeShortName,
    this.dischargeAddress,
    this.dischargeNumber,
    this.dischargeTypeStr,
    this.dischargeCategoryStr,
    this.dischargeRuleStr,
    this.outTypeStr,
    this.denoterInstallTypeStr,
    this.longitude,
    this.latitude,
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
        dischargeShortName,
        dischargeAddress,
        dischargeNumber,
        dischargeTypeStr,
        dischargeCategoryStr,
        dischargeRuleStr,
        outTypeStr,
        denoterInstallTypeStr,
        longitude,
        latitude,
        dischargeReportTotalCount,
        factorReportTotalCount,
      ];

  factory DischargeDetail.fromJson(Map<String, dynamic> json) =>
      _$DischargeDetailFromJson(json);

  Map<String, dynamic> toJson() => _$DischargeDetailToJson(this);
}
