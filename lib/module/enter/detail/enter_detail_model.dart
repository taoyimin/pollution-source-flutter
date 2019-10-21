import 'package:equatable/equatable.dart';

//企业详情
class EnterDetail extends Equatable {
  final String enterName; //企业名称
  final String enterAddress;  //企业地址
  final String contactPerson; //企业联系人
  final String contactPersonTel;  //联系人电话
  final String legalPerson; //法人
  final String legalPersonTel;  //法人电话
  final String attentionLevel;  //关注程度
  final String areaName;  //区域
  final String industryType;  //行业类别
  final String creditCode;  //信用代码
  final String orderComplete; //报警管理单已办结个数
  final String orderAll;  //报警管理单总数
  final String monitorReportValid;  //排口异常申报有效数
  final String monitorReportAll;  //排口异常申报总数
  final String factorReportValid; //因子异常申报有效数
  final String factorReportAll; //因子异常申报总数
  final String monitorAll;  //监控点总数
  final String monitorOnline; //监控点在线数
  final String monitorAlarm;  //监控点预警数
  final String monitorOver; //监控点超标数
  final String monitorOffline;  //监控点离线数
  final String monitorStop; //监控点停产数
  final String licenseNumber; //排污许可证编码
  final String buildProject;  //建设项目总数
  final String sceneLaw;  //现场执法总数
  final String environmentVisit;  //环境信访总数

  EnterDetail({
    this.enterName,
    this.enterAddress,
    this.contactPerson,
    this.contactPersonTel,
    this.legalPerson,
    this.legalPersonTel,
    this.attentionLevel,
    this.areaName,
    this.industryType,
    this.creditCode,
    this.orderComplete,
    this.orderAll,
    this.monitorReportValid,
    this.monitorReportAll,
    this.factorReportValid,
    this.factorReportAll,
    this.monitorAll,
    this.monitorOnline,
    this.monitorAlarm,
    this.monitorOver,
    this.monitorOffline,
    this.monitorStop,
    this.licenseNumber,
    this.buildProject,
    this.sceneLaw,
    this.environmentVisit,
  });

  @override
  List<Object> get props => [
        enterName,
        enterAddress,
        contactPerson,
        contactPersonTel,
        legalPerson,
        legalPersonTel,
        attentionLevel,
        areaName,
        industryType,
        creditCode,
        orderComplete,
        orderAll,
        monitorReportValid,
        monitorReportAll,
        factorReportValid,
        factorReportAll,
        monitorAll,
        monitorOnline,
        monitorAlarm,
        monitorOver,
        monitorOffline,
        monitorStop,
        licenseNumber,
        buildProject,
        sceneLaw,
        environmentVisit,
      ];

  static EnterDetail fromJson(dynamic json) {
    return EnterDetail(
      enterName: '深圳市腾讯计算机系统有限公司',
      enterAddress: '深圳市南山区高新区高新南一路飞亚达大厦5-10楼',
      contactPerson: '王五',
      contactPersonTel: '15879085164',
      legalPerson: '李四',
      legalPersonTel: '15879085164',
      attentionLevel: '重点源',
      areaName: '赣州市章贡区',
      industryType: '稀有稀土金属冶炼、常用有色金属冶炼',
      creditCode: 'G2125FD1GF51D5F5FSD545G2125FD',
      orderComplete: '256',
      orderAll: '1452',
      monitorReportValid: '15',
      monitorReportAll: '42',
      factorReportValid: '5',
      factorReportAll: '85',
      monitorAll: '50',
      monitorOnline: '21',
      monitorAlarm: '25',
      monitorOver: '14',
      monitorOffline: '4',
      monitorStop: '1',
      licenseNumber: '546DSAFKSJDHKJHF546545DFHAJKH',
      buildProject: '24',
      sceneLaw: '1',
      environmentVisit: '13',
    );
  }
}
