import 'package:equatable/equatable.dart';

//监控点详情
class MonitorDetail extends Equatable {
  final String enterName;
  final String enterAddress;
  final String monitorName;
  final String monitorType;
  final String monitorTime;
  final String areaName;
  final String monitorAddress;
  final String dataCollectionNumber;
  final String contactPersonTel;
  final String contactPerson;

  MonitorDetail({
    this.enterName = '',
    this.enterAddress = '',
    this.monitorName = '',
    this.monitorType = '',
    this.monitorTime = '',
    this.areaName = '',
    this.monitorAddress = '',
    this.dataCollectionNumber = '',
    this.contactPersonTel = '',
    this.contactPerson = '',
  }) : super([
          enterName,
          enterAddress,
          monitorName,
          monitorType,
          monitorTime,
          areaName,
          monitorAddress,
          dataCollectionNumber,
          contactPersonTel,
          contactPerson,
        ]);

  static MonitorDetail fromJson(dynamic json) {
    return MonitorDetail(
      enterName: '深圳市腾讯计算机系统有限公司',
      enterAddress: '深圳市南山区高新区高新南一路飞亚达大厦5-10楼',
      monitorName: '废水排放口',
      monitorType: '废水',
      monitorTime: '2019年10月15日 10时22分',
      areaName: '南昌市 市辖区',
      monitorAddress: '江西省安义东阳镇',
      dataCollectionNumber: '86377750110022',
      contactPersonTel: '15879085164',
      contactPerson: '张三',
    );
  }
}
