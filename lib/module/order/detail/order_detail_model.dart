import 'package:equatable/equatable.dart';
import 'package:pollution_source/module/common/common_model.dart';

//报警管理单详情
class OrderDetail extends Equatable {
  final String enterName; //企业名称
  final String enterAddress;  //企业地址
  final String areaName;  //区域
  final String monitorName; //监控点名称
  final String alarmTime; //报警时间
  final String state; //状态
  final String alarmType; //报警类型
  final String alarmRemark; //报警描述
  final List<DealStep> stepList;  //处理流程集合

  const OrderDetail({
    this.enterName,
    this.enterAddress,
    this.areaName,
    this.monitorName,
    this.alarmTime,
    this.state,
    this.alarmType,
    this.alarmRemark,
    this.stepList,
  });

  @override
  List<Object> get props => [
        enterName,
        enterAddress,
        areaName,
        monitorName,
        alarmTime,
        state,
        alarmType,
        alarmRemark,
        stepList,
      ];

  static OrderDetail fromJson(dynamic json) {
    return OrderDetail(
      enterName: '深圳市腾讯计算机系统有限公司',
      enterAddress: '深圳市南山区高新区高新南一路飞亚达大厦5-10楼',
      areaName: '南昌市',
      monitorName: '废气排放口',
      alarmTime: '10月25日',
      state: '县局待审核',
      alarmType: '连续恒值 污染物超标 数采仪掉线',
      alarmRemark: '报警描述报警描述报警描述报警描述报警描述报警描述报警描述',
      stepList: [
        DealStep(
          dealType: "县局督办",
          dealPerson: "南昌市市辖区管理员",
          dealTime: "2019-09-19 11:13",
          dealRemark: "操作描述操作描述操作描述操作描述操作描述操作描述操作描述",
          attachmentList: [
            Attachment(type: 0, fileName: "文件名文件名.png", url: "", size: "1.2M"),
            Attachment(
                type: 1, fileName: "文件名文件名文件名.doc", url: "", size: "56KB"),
          ],
        ),
        DealStep(
          dealType: "园区处理",
          dealPerson: "南昌市市辖区管理员",
          dealTime: "2019-09-19 11:13",
          dealRemark: "操作描述操作描述操作描述操作描述操作描述操作描述操作描述",
          attachmentList: [
            Attachment(
                type: 2,
                fileName: "文件名文件名文件名4515455.xls",
                url: "",
                size: "256KB"),
          ],
        ),
        DealStep(
          dealType: "县局审核",
          dealPerson: "南昌市市辖区管理员",
          dealTime: "2019-09-19 11:13",
          dealRemark: "操作描述操作描述操作描述操作描述操作描述操作描述操作描述",
          attachmentList: [
            Attachment(
                type: 3, fileName: "文件文件名文件文件文件名.pdf", url: "", size: "4.3M"),
            Attachment(
                type: 5, fileName: "文件文件名文件文件名.psd", url: "", size: "412KB"),
          ],
        ),
      ],
    );
  }
}
