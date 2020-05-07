import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/collection/law/mobile_law_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';
import 'package:pollution_source/module/process/detail/process_detail_model.dart';

//报警管理单详情
class OrderDetail extends Equatable {
  @JsonKey(name: 'id')
  final int orderId; // 报警管理单ID
  final int enterId; // 企业ID
  final int monitorId; // 监控点ID
  final String enterName; // 企业名称
  final String enterAddress; // 企业地址
  final String districtName; // 区域
  final String monitorName; // 监控点名称
  final String alarmDateStr; // 报警时间
  final String alarmState; // 督办单状态
  final String alarmStateStr; // 督办单状态中文
  final String alarmTypeStr; // 报警类型
  @JsonKey(defaultValue: '')
  final String alarmCause; // 报警原因
  @JsonKey(defaultValue: '')
  final String alarmCauseStr; // 报警原因中文
  final String alarmDesc; // 报警描述
  final List<Process> processes; // 处理流程集合
  final String deal; // 是否可以处理
  final String audit; // 是否可以审核
  final List<MobileLaw> mobileLawList; // 移动执法

  const OrderDetail({
    this.orderId,
    this.enterId,
    this.monitorId,
    this.enterName,
    this.enterAddress,
    this.districtName,
    this.monitorName,
    this.alarmDateStr,
    this.alarmState,
    this.alarmStateStr,
    this.alarmTypeStr,
    this.alarmCause,
    this.alarmCauseStr,
    this.alarmDesc,
    this.processes,
    this.deal,
    this.audit,
    this.mobileLawList,
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
        alarmState,
        alarmStateStr,
        alarmTypeStr,
        alarmCause,
        alarmCauseStr,
        alarmDesc,
        processes,
        deal,
        audit,
        mobileLawList,
      ];

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);

  /// 获取默认选中的报警原因数据字典
  List<DataDict> get alarmCauseList {
    if (!TextUtil.isEmpty(alarmCauseStr.trim()) &&
        !TextUtil.isEmpty(alarmCause)) {
      List<String> nameList = alarmCauseStr.trim().split(' ');
      List<String> codeList = alarmCause.split(',');
      return List.generate(nameList.length, (index) {
        return DataDict(name: nameList[index], code: codeList[index]);
      });
    } else
      return [];
  }
}

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) {
  return OrderDetail(
    orderId: json['commonSuperviseOrder']['id'] as int,
    enterId: json['commonSuperviseOrder']['enterId'] as int,
    monitorId: json['commonSuperviseOrder']['monitorId'] as int,
    enterName: json['commonSuperviseOrder']['enterpriseName'] as String,
    enterAddress: json['commonSuperviseOrder']['entAddress'] as String,
    districtName: json['commonSuperviseOrder']['areaName'] as String,
    monitorName: json['commonSuperviseOrder']['disMonitorName'] as String,
    alarmDateStr: json['commonSuperviseOrder']['alarmDate'] as String,
    alarmState: json['commonSuperviseOrder']['alarmState'] as String,
    alarmStateStr: json['commonSuperviseOrder']['alarmStateStr'] as String,
    alarmTypeStr: json['commonSuperviseOrder']['alarmTypeStr'] as String,
    alarmCause: json['commonSuperviseOrder']['alarmCause'] as String ?? '',
    alarmCauseStr:
        json['commonSuperviseOrder']['alarmCauseStr'] as String ?? '',
    alarmDesc: json['commonSuperviseOrder']['alarmDesc'] as String,
    processes: (json['processes'] as List)
        ?.map((e) =>
            e == null ? null : Process.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    deal: json['commonSuperviseOrder']['hasDeal'] as String,
    audit: json['commonSuperviseOrder']['hasAudit'] as String,
    mobileLawList: json.containsKey('enforcement')
        ? (json['enforcement'] as List)
            ?.map((e) => e == null
                ? null
                : MobileLaw.fromJson(e as Map<String, dynamic>))
            ?.toList()
        : [],
  );
}

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.orderId,
      'enterId': instance.enterId,
      'monitorId': instance.monitorId,
      'enterpriseName': instance.enterName,
      'entAddress': instance.enterAddress,
      'areaName': instance.districtName,
      'disMonitorName': instance.monitorName,
      'alarmDate': instance.alarmDateStr,
      'alarmState': instance.alarmState,
      'alarmStateStr': instance.alarmStateStr,
      'alarmTypeStr': instance.alarmTypeStr,
      'alarmCause': instance.alarmCause,
      'alarmCauseStr': instance.alarmCauseStr,
      'alarmDesc': instance.alarmDesc,
      'processes': instance.processes,
      'hasDeal': instance.deal,
      'hasAudit': instance.audit,
    };
