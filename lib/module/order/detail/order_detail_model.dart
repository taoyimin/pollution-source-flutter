import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/res/constant.dart';

//报警管理单详情
class OrderDetail extends Equatable {
  final String enterName; //企业名称
  final String enterAddress; //企业地址
  final String districtName; //区域
  final String monitorName; //监控点名称
  final String alarmDateStr; //报警时间
  final String orderStateStr; //状态
  final String alarmTypeStr; //报警类型
  final String alarmRemark; //报警描述
  final List<Process> processList; //处理流程集合

  const OrderDetail({
    this.enterName,
    this.enterAddress,
    this.districtName,
    this.monitorName,
    this.alarmDateStr,
    this.orderStateStr,
    this.alarmTypeStr,
    this.alarmRemark,
    this.processList,
  });

  @override
  List<Object> get props => [
        enterName,
        enterAddress,
        districtName,
        monitorName,
        alarmDateStr,
        orderStateStr,
        alarmTypeStr,
        alarmRemark,
    processList,
      ];

  static OrderDetail fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return OrderDetail(
        enterName: '深圳市腾讯计算机系统有限公司*',
        enterAddress: '深圳市南山区高新区高新南一路飞亚达大厦5-10楼*',
        districtName: '南昌市*',
        monitorName: '废气排放口*',
        alarmDateStr: '10月25日*',
        orderStateStr: '县局待审核*',
        alarmTypeStr: '连续恒值 污染物超标 数采仪掉线*',
        alarmRemark: '报警描述报警描述报警描述报警描述报警描述报警描述报警描述*',
        processList: [
          Process(
            operateTypeStr: "县局督办*",
            operatePerson: "南昌市市辖区管理员*",
            operateTimeStr: "2019-09-19 11:13*",
            operateDesc: "操作描述操作描述操作描述操作描述操作描述操作描述操作描述*",
            attachmentList: [
              Attachment(fileName: "文件名文件名.png*", url: "*", size: 453453),
              Attachment(fileName: "文件名文件名文件名.doc*", url: "*", size: 354345),
            ],
          ),
          Process(
            operateTypeStr: "园区处理*",
            operatePerson: "南昌市市辖区管理员*",
            operateTimeStr: "2019-09-19 11:13*",
            operateDesc: "操作描述操作描述操作描述操作描述操作描述操作描述操作描述*",
            attachmentList: [
              Attachment(
                  fileName: "文件名文件名文件名4515455.xls*", url: "*", size: 354345),
            ],
          ),
          Process(
            operateTypeStr: "县局审核*",
            operatePerson: "南昌市市辖区管理员*",
            operateTimeStr: "2019-09-19 11:13*",
            operateDesc: "操作描述操作描述操作描述操作描述操作描述操作描述操作描述*",
            attachmentList: [
              Attachment(
                  fileName: "文件文件名文件文件文件名.pdf*", url: "*", size: 434534),
              Attachment(fileName: "文件文件名文件文件名.psd*", url: "*", size: 43453),
            ],
          ),
        ],
      );
    } else {
      return OrderDetail(
        enterName: json['enterName'],
        enterAddress: json['enterAddress'],
        districtName: json['districtName'],
        monitorName: json['monitorName'],
        alarmDateStr: json['alarmDateStr'],
        orderStateStr: json['orderStateStr'],
        alarmTypeStr: json['alarmTypeStr'],
        alarmRemark: json['alarmRemark'],
        processList: Process.fromJsonArray(json['processes']),
      );
    }
  }
}
