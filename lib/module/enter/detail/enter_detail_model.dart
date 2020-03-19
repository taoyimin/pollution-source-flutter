import 'package:equatable/equatable.dart';

//part 'enter_detail_model.g.dart';

/// 企业详情
// @JsonSerializable()
class EnterDetail extends Equatable {
  final int enterId; // 企业id
  // @JsonKey(name: 'enterpriseName')
  final String enterName; // 企业名称
  // @JsonKey(name: 'entAddress')
  final String enterAddress; // 企业地址
  // @JsonKey(name: 'entLinkPhone')
  final String enterTel; // 企业电话
  // @JsonKey(name: 'envirLinkMan')
  final String contactPerson; // 企业联系人
  // @JsonKey(name: 'envirLinkPhone')
  final String contactPersonTel; // 联系人电话
  final String legalPerson; // 法人
  // @JsonKey(name: 'legalLinkPhone')
  final String legalPersonTel; // 法人电话
  final String attentionLevelStr; // 关注程度
  final String cityName; // 所属市
  final String areaName; // 所属区
  final String industryTypeStr; // 行业类别
  // @JsonKey(name: 'legalPersonCode')
  final String creditCode; // 信用代码
  final int orderCompleteCount; // 报警管理单已办结个数
  final int orderTotalCount; // 报警管理单总数
  final int orderDealCount; // 报警管理单待处理数
  final int orderOverdueCount; // 报警管理单待处理超期数
  final int orderReturnCount; // 报警管理单已退回数
  final int longStopReportTotalCount; // 长期停产申报总数
  final int dischargeReportTotalCount; // 排口异常申报总数
  final int factorReportTotalCount; // 因子异常申报总数
  final int monitorTotalCount; // 监控点总数
  final int monitorOnlineCount; // 监控点在线数
  final int monitorAlarmCount; // 监控点预警数
  final int monitorOverCount; // 监控点超标数
  final int monitorOfflineCount; // 监控点离线数
  final int monitorStopCount; // 监控点异常数
  final int monitorZeroCount; // 监控点零值数
  final int monitorLargeCount; // 监控点超大值数
  final int monitorNegativeCount; // 监控点负值数
  final String licenseNumber; // 排污许可证编码
  final String buildProjectCount; // 建设项目总数
  final String sceneLawCount; // 现场执法总数
  final String environmentVisitCount; // 环境信访总数

  EnterDetail({
    this.enterId,
    this.enterName,
    this.enterAddress,
    this.enterTel,
    this.contactPerson,
    this.contactPersonTel,
    this.legalPerson,
    this.legalPersonTel,
    this.attentionLevelStr,
    this.cityName,
    this.areaName,
    this.industryTypeStr,
    this.creditCode,
    this.orderCompleteCount,
    this.orderTotalCount,
    this.orderDealCount,
    this.orderOverdueCount,
    this.orderReturnCount,
    this.longStopReportTotalCount,
    this.dischargeReportTotalCount,
    this.factorReportTotalCount,
    this.monitorTotalCount,
    this.monitorOnlineCount,
    this.monitorAlarmCount,
    this.monitorOverCount,
    this.monitorOfflineCount,
    this.monitorStopCount,
    this.monitorZeroCount,
    this.monitorLargeCount,
    this.monitorNegativeCount,
    this.licenseNumber,
    this.buildProjectCount,
    this.sceneLawCount,
    this.environmentVisitCount,
  });

  @override
  List<Object> get props => [
        enterId,
        enterName,
        enterAddress,
        enterTel,
        contactPerson,
        contactPersonTel,
        legalPerson,
        legalPersonTel,
        attentionLevelStr,
        cityName,
        areaName,
        industryTypeStr,
        creditCode,
        orderCompleteCount,
        orderTotalCount,
        orderDealCount,
        orderOverdueCount,
        orderReturnCount,
        longStopReportTotalCount,
        dischargeReportTotalCount,
        factorReportTotalCount,
        monitorTotalCount,
        monitorOnlineCount,
        monitorAlarmCount,
        monitorOverCount,
        monitorOfflineCount,
        monitorStopCount,
        monitorZeroCount,
        monitorLargeCount,
        monitorNegativeCount,
        licenseNumber,
        buildProjectCount,
        sceneLawCount,
        environmentVisitCount,
      ];

  // 所属区域
  String get districtName {
    return '${cityName ?? ''}${areaName ?? ''}';
  }

  factory EnterDetail.fromJson(Map<String, dynamic> json) =>
      _$EnterDetailFromJson(json);

  Map<String, dynamic> toJson() => _$EnterDetailToJson(this);
}

EnterDetail _$EnterDetailFromJson(Map<String, dynamic> json) {
  return EnterDetail(
      enterId: json['enterprise']['enterId'] as int,
      enterName: json['enterprise']['enterpriseName'] as String,
      enterAddress: json['enterprise']['entAddress'] as String,
      enterTel: json['enterprise']['entLinkPhone'] as String,
      contactPerson: json['enterprise']['envirLinkMan'] as String,
      contactPersonTel: json['enterprise']['envirLinkPhone'] as String,
      legalPerson: json['enterprise']['legalPerson'] as String,
      legalPersonTel: json['enterprise']['legalLinkPhone'] as String,
      attentionLevelStr: json['enterprise']['attentionLevelStr'] as String,
      cityName: json['enterprise']['cityName'] as String,
      areaName: json['enterprise']['areaName'] as String,
      industryTypeStr: json['enterprise']['industryTypeStr'] as String,
      creditCode: json['enterprise']['legalPersonCode'] as String,
      orderCompleteCount: json['orderCompleteCount'] as int,
      orderTotalCount: json['orderTotalCount'] as int,
      orderDealCount: json['orderDealCount'] as int,
      orderOverdueCount: json['orderOverdueCount'] as int,
      orderReturnCount: json['orderReturnCount'] as int,
      longStopReportTotalCount: json['longStopReportTotalCount'] as int,
      dischargeReportTotalCount: json['dischargeReportTotalCount'] as int,
      factorReportTotalCount: json['factorReportTotalCount'] as int,
      monitorTotalCount: json['monitorTotalCount'] as int,
      monitorOnlineCount: json['monitorOnlineCount'] as int,
      monitorAlarmCount: json['monitorAlarmCount'] as int,
      monitorOverCount: json['monitorOverCount'] as int,
      monitorOfflineCount: json['monitorOfflineCount'] as int,
      monitorStopCount: json['monitorStopCount'] as int,
      monitorZeroCount: json['monitorZeroCount'] as int,
      monitorLargeCount: json['monitorLargeCount'] as int,
      monitorNegativeCount: json['monitorNegativeCount'] as int,
      licenseNumber: json['licenseNumber'] as String,
      buildProjectCount: json['buildProjectCount'] as String,
      sceneLawCount: json['sceneLawCount'] as String,
      environmentVisitCount: json['environmentVisitCount'] as String);
}

Map<String, dynamic> _$EnterDetailToJson(EnterDetail instance) =>
    <String, dynamic>{
      'enterId': instance.enterId,
      'enterpriseName': instance.enterName,
      'entAddress': instance.enterAddress,
      'entLinkPhone': instance.enterTel,
      'envirLinkMan': instance.contactPerson,
      'envirLinkPhone': instance.contactPersonTel,
      'legalPerson': instance.legalPerson,
      'legalLinkPhone': instance.legalPersonTel,
      'attentionLevelStr': instance.attentionLevelStr,
      'cityName': instance.cityName,
      'areaName': instance.areaName,
      'industryTypeStr': instance.industryTypeStr,
      'legalPersonCode': instance.creditCode,
      'orderCompleteCount': instance.orderCompleteCount,
      'orderTotalCount': instance.orderTotalCount,
      'orderDealCount': instance.orderDealCount,
      'orderOverdueCount': instance.orderOverdueCount,
      'orderReturnCount': instance.orderReturnCount,
      'longStopReportTotalCount': instance.longStopReportTotalCount,
      'dischargeReportTotalCount': instance.dischargeReportTotalCount,
      'factorReportTotalCount': instance.factorReportTotalCount,
      'monitorTotalCount': instance.monitorTotalCount,
      'monitorOnlineCount': instance.monitorOnlineCount,
      'monitorAlarmCount': instance.monitorAlarmCount,
      'monitorOverCount': instance.monitorOverCount,
      'monitorOfflineCount': instance.monitorOfflineCount,
      'monitorStopCount': instance.monitorStopCount,
      'monitorZeroCount': instance.monitorZeroCount,
      'monitorLargeCount': instance.monitorLargeCount,
      'monitorNegativeCount': instance.monitorNegativeCount,
      'licenseNumber': instance.licenseNumber,
      'buildProjectCount': instance.buildProjectCount,
      'sceneLawCount': instance.sceneLawCount,
      'environmentVisitCount': instance.environmentVisitCount
    };
