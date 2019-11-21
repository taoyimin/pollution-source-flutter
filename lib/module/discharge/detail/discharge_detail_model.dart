import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discharge_detail_model.g.dart';

//排口详情
@JsonSerializable()
class DischargeDetail extends Equatable {
  final String dischargeId; //排口ID
  final String enterId; //企业ID
  final String enterName; //企业名称
  final String enterAddress; //企业地址
  final String dischargeName; //排口名称
  final String dischargeShortName; //排口简称
  final String dischargeAddress; //排口地址
  final String dischargeNumber; //排口编号
  final String dischargeRuleStr; //排放规律
  final String denoterInstallTypeStr; //标志牌安装形式
  final String dischargeTypeStr; //排口类型
  final String dischargeCategoryStr; //排口类别
  final String outTypeStr; //排放类别
  final String longitude; //经度
  final String latitude; //纬度
  final String dischargeReportTotalCount; //排口异常申报个数
  final String factorReportTotalCount; //因子异常申报个数

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

  /*static DischargeDetail fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return DischargeDetail(
        dischargeId: '-',
        enterId: '-',
        enterName: '-',
        enterAddress: '-',
        dischargeName: '-',
        dischargeShortName: '-',
        dischargeAddress: '-',
        dischargeNumber: '-',
        dischargeTypeStr: '-',
        dischargeCategoryStr: '-',
        dischargeRuleStr: '-',
        outTypeStr: '-',
        denoterInstallTypeStr: '-',
        longitude: '-',
        latitude: '-',
        dischargeReportTotalCount: '-',
        factorReportTotalCount: '-',
      );
    } else {
      return DischargeDetail(
        dischargeId: json['dischargeId'],
        enterId: json['enterId'],
        enterName: json['enterName'],
        enterAddress: json['enterAddress'],
        dischargeName: json['dischargeName'],
        dischargeShortName: json['dischargeShortName'],
        dischargeAddress: json['dischargeAddress'],
        dischargeNumber: json['dischargeNumber'],
        dischargeTypeStr: json['dischargeTypeStr'],
        dischargeCategoryStr: json['dischargeCategoryStr'],
        dischargeRuleStr: json['dischargeRuleStr'],
        outTypeStr: json['outTypeStr'],
        denoterInstallTypeStr: json['denoterInstallTypeStr'],
        longitude: json['longitude'],
        latitude: json['latitude'],
        dischargeReportTotalCount: json['dischargeReportTotalCount'],
        factorReportTotalCount: json['factorReportTotalCount'],
      );
    }
  }*/
}
