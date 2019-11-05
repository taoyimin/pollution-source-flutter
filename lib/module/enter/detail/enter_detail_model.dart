import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/res/constant.dart';

//企业详情
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
  final String areaName; //区域
  final String industryTypeStr; //行业类别
  final String creditCode; //信用代码
  final String orderCompleteCount; //报警管理单已办结个数
  final String orderTotalCount; //报警管理单总数
  //final String monitorReportValid; //排口异常申报有效数
  final String monitorReportTotalCount; //排口异常申报总数
  //final String factorReportValid; //因子异常申报有效数
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
    this.areaName,
    this.industryTypeStr,
    this.creditCode,
    this.orderCompleteCount,
    this.orderTotalCount,
    //this.monitorReportValid,
    this.monitorReportTotalCount,
    //this.factorReportValid,
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
        areaName,
        industryTypeStr,
        creditCode,
        orderCompleteCount,
        orderTotalCount,
        //monitorReportValid,
        monitorReportTotalCount,
        //factorReportValid,
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

  static EnterDetail fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return EnterDetail(
        enterId: '0',
        enterName: '深圳市腾讯计算机系统有限公司',
        enterAddress: '深圳市南山区高新区高新南一路飞亚达大厦5-10楼',
        enterTel: '123456789',
        contactPerson: '王五',
        contactPersonTel: '15879085164',
        legalPerson: '李四',
        legalPersonTel: '15879085164',
        attentionLevelStr: '重点源',
        areaName: '赣州市章贡区',
        industryTypeStr: '稀有稀土金属冶炼、常用有色金属冶炼',
        creditCode: 'G2125FD1GF51D5F5FSD545G2125FD',
        orderCompleteCount: '-',
        orderTotalCount: '-',
        //monitorReportValid: '15',
        monitorReportTotalCount: '-',
        //factorReportValid: '5',
        factorReportTotalCount: '-',
        monitorTotalCount: '-',
        monitorOnlineCount: '-',
        monitorAlarmCount: '-',
        monitorOverCount: '-',
        monitorOfflineCount: '-',
        monitorStopCount: '-',
        licenseNumber: '-',
        buildProjectCount: '-',
        sceneLawCount: '-',
        environmentVisitCount: '-',
      );
    } else {
      return EnterDetail(
        enterId: json['enterId'],
        enterName: json['enterName'],
        enterAddress: json['enterAddress'],
        enterTel: json['enterTel'],
        contactPerson: json['contactPerson'],
        contactPersonTel: json['contactPersonTel'],
        legalPerson: json['legalPerson'],
        legalPersonTel: json['legalPersonTel'],
        attentionLevelStr: json['attentionLevelStr'],
        areaName: json['cityName'] + json['areaName'],
        industryTypeStr: json['industryTypeStr'],
        creditCode: json['creditCode'],
        orderCompleteCount: json['orderCompleteCount'],
        orderTotalCount: json['orderTotalCount'],
        //monitorReportValid: '15',
        monitorReportTotalCount: json['monitorReportTotalCount'],
        //factorReportValid: '5',
        factorReportTotalCount: json['factorReportTotalCount'],
        monitorTotalCount: json['monitorTotalCount'],
        monitorOnlineCount: json['monitorOnlineCount'],
        monitorAlarmCount: json['monitorAlarmCount'],
        monitorOverCount: json['monitorOverCount'],
        monitorOfflineCount: json['monitorOfflineCount'],
        monitorStopCount: json['monitorStopCount'],
        licenseNumber: json['licenseNumber'],
        buildProjectCount: '-',
        sceneLawCount: '-',
        environmentVisitCount: '-',
      );
    }
  }
}
