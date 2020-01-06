import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';

part 'order_detail_model.g.dart';

//报警管理单详情
@JsonSerializable()
class OrderDetail extends Equatable {
  final int orderId; //报警管理单ID
  final int enterId; //企业ID
  final int monitorId; //监控点ID
  final String enterName; //企业名称
  final String enterAddress; //企业地址
  final String districtName; //区域
  final String monitorName; //监控点名称
  final String alarmDateStr; //报警时间
  final String orderStateStr; //状态
  final String alarmTypeStr; //报警类型
  @JsonKey(name: 'alarmDesc')
  final String alarmRemark; //报警描述
  final List<Process> processes; //处理流程集合

  const OrderDetail({
    this.orderId,
    this.enterId,
    this.monitorId,
    this.enterName,
    this.enterAddress,
    this.districtName,
    this.monitorName,
    this.alarmDateStr,
    this.orderStateStr,
    this.alarmTypeStr,
    this.alarmRemark,
    this.processes,
  });

  @override
  List<Object> get props => [
        orderId,
        enterId,
        monitorId,
        enterName,
        enterAddress,
        districtName,
        monitorName,
        alarmDateStr,
        orderStateStr,
        alarmTypeStr,
        alarmRemark,
        processes,
      ];

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}
