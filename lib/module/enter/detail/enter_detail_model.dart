import 'package:equatable/equatable.dart';

//企业详情
class EnterDetail extends Equatable {
  final String enterName;
  final String enterAddress;
  final String contactPerson;
  final String contactPersonTel;
  final String legalPerson;
  final String legalPersonTel;
  final String attentionLevel;
  final String area;
  final String industryType;
  final String creditCode;
  final String orderComplete;
  final String orderAll;
  final String monitorReportValid;
  final String monitorReportAll;
  final String factorReportValid;
  final String factorReportAll;
  final String monitorAll;
  final String monitorOnline;
  final String monitorAlarm;
  final String monitorOver;
  final String monitorOffline;
  final String monitorStop;
  final String licenseNumber;
  final String buildProject;
  final String sceneLaw;
  final String environmentVisit;

  EnterDetail({
    this.enterName,
    this.enterAddress,
    this.contactPerson,
    this.contactPersonTel,
    this.legalPerson,
    this.legalPersonTel,
    this.attentionLevel,
    this.area,
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
  }) : super([
          enterName,
          enterAddress,
          contactPerson,
          contactPersonTel,
          legalPerson,
          legalPersonTel,
          attentionLevel,
          area,
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
        ]);

  static EnterDetail fromJson(dynamic json) {
    return EnterDetail(
      enterName: '深圳市腾讯计算机系统有限公司',
      enterAddress: '深圳市南山区高新区高新南一路飞亚达大厦5-10楼',
      contactPerson: '王五',
      contactPersonTel: '15879085164',
      legalPerson: '李四',
      legalPersonTel: '15879085164',
      attentionLevel: '重点源',
      area: '赣州市章贡区',
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
