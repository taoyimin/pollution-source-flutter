import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'enter_detail_model.g.dart';

//企业详情
@JsonSerializable()
class EnterDetail extends Equatable {
  final String enterId; //企业id
  final String enterName; //企业名称
  final String enterAddress; //企业地址
  final String enterTel; //企业电话
  final String contactPerson; //企业联系人
  final String contactPersonTel; //联系人电话
  final String legalPerson; //法人
  final String legalPersonTel; //法人电话
  final String attentionLevelStr; //关注程度
  final String districtName; //区域
  final String industryTypeStr; //行业类别
  final String creditCode; //信用代码
  final String orderCompleteCount; //报警管理单已办结个数
  final String orderTotalCount; //报警管理单总数
  final String longStopReportTotalCount; //长期停产申报总数
  final String dischargeReportTotalCount; //排口异常申报总数
  final String factorReportTotalCount; //因子异常申报总数
  final String monitorTotalCount; //监控点总数
  final String monitorOnlineCount; //监控点在线数
  final String monitorAlarmCount; //监控点预警数
  final String monitorOverCount; //监控点超标数
  final String monitorOfflineCount; //监控点离线数
  final String monitorStopCount; //监控点停产数
  final String licenseNumber; //排污许可证编码
  final String buildProjectCount; //建设项目总数
  final String sceneLawCount; //现场执法总数
  final String environmentVisitCount; //环境信访总数

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
    this.districtName,
    this.industryTypeStr,
    this.creditCode,
    this.orderCompleteCount,
    this.orderTotalCount,
    this.longStopReportTotalCount,
    this.dischargeReportTotalCount,
    this.factorReportTotalCount,
    this.monitorTotalCount,
    this.monitorOnlineCount,
    this.monitorAlarmCount,
    this.monitorOverCount,
    this.monitorOfflineCount,
    this.monitorStopCount,
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
        districtName,
        industryTypeStr,
        creditCode,
        orderCompleteCount,
        orderTotalCount,
        longStopReportTotalCount,
        dischargeReportTotalCount,
        factorReportTotalCount,
        monitorTotalCount,
        monitorOnlineCount,
        monitorAlarmCount,
        monitorOverCount,
        monitorOfflineCount,
        monitorStopCount,
        licenseNumber,
        buildProjectCount,
        sceneLawCount,
        environmentVisitCount,
      ];

  factory EnterDetail.fromJson(Map<String, dynamic> json) =>
      _$EnterDetailFromJson(json);

  Map<String, dynamic> toJson() => _$EnterDetailToJson(this);
}
