import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routine_inspection_upload_list_model.g.dart';

/// 常规巡检上报列表
@JsonSerializable()
class RoutineInspectionUploadList extends Equatable {
  @JsonKey(defaultValue: '')
  final String inspectionTaskId;
  @JsonKey(defaultValue: '')
  final String itemName;
  @JsonKey(defaultValue: '')
  final String itemType;
  @JsonKey(defaultValue: '')
  final String contentName;
  @JsonKey(defaultValue: '')
  final String inspectionStartTime;
  @JsonKey(defaultValue: '')
  final String inspectionEndTime;
  @JsonKey(defaultValue: '')
  final String inspectionRemark;
  @JsonKey(defaultValue: '')
  final String remark;
  @JsonKey(defaultValue: '')
  final String deviceName;
  @JsonKey(name: 'enterpriseName', defaultValue: '')
  final String enterName;
  @JsonKey(name: 'disOutName', defaultValue: '')
  final String dischargeName;
  @JsonKey(name: 'disMonitorName', defaultValue: '')
  final String monitorName;
  @JsonKey(defaultValue: '')
  final String factorCode;
  @JsonKey(defaultValue: '')
  final String monitorId;
  @JsonKey(defaultValue: '')
  final String deviceId;
  @JsonKey(defaultValue: '')
  final String factorName;
  @JsonKey(defaultValue: '')
  final String factorUnit;
  @JsonKey(name: 'measure_principle')
  final String measurePrinciple;
  @JsonKey(name: 'analysis_method')
  final String analysisMethod;
  @JsonKey(defaultValue: '')
  final String measureUpper;
  @JsonKey(defaultValue: '')
  final String measureLower;

  const RoutineInspectionUploadList({
    this.inspectionTaskId,
    this.itemName,
    this.itemType,
    this.contentName,
    this.inspectionStartTime,
    this.inspectionEndTime,
    this.inspectionRemark,
    this.remark,
    this.deviceName,
    this.enterName,
    this.dischargeName,
    this.monitorName,
    this.factorCode,
    this.monitorId,
    this.deviceId,
    this.factorName,
    this.factorUnit,
    this.measurePrinciple,
    this.analysisMethod,
    this.measureUpper,
    this.measureLower,
  });

  @override
  List<Object> get props => [
        inspectionTaskId,
        itemName,
        itemType,
        contentName,
        inspectionStartTime,
        inspectionEndTime,
        inspectionRemark,
        remark,
        deviceName,
        enterName,
        dischargeName,
        monitorName,
        factorCode,
        monitorId,
        deviceId,
        factorName,
        factorUnit,
        measurePrinciple,
        analysisMethod,
        measureUpper,
        measureLower,
      ];

  factory RoutineInspectionUploadList.fromJson(Map<String, dynamic> json) =>
      _$RoutineInspectionUploadListFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineInspectionUploadListToJson(this);

  /// 通过分割分号和逗号把任务集合分割成子任务集合
  static List<RoutineInspectionUploadList> convert(
      List<RoutineInspectionUploadList> list) {
    return list.expand((item) {
      List<RoutineInspectionUploadList> itemList = [];
      List<String> itemNames = item.itemName.split(';');
      List<String> inspectionTaskIds = item.inspectionTaskId.split(';');
      List<String> itemTypes = item.itemType.split(';');
      List<String> contentNames = item.contentName.split(';');
      List<String> inspectionStartTimes = item.inspectionStartTime.split(';');
      List<String> inspectionEndTimes = item.inspectionEndTime.split(';');
      // factorCode和factorName可能为null
      List<String> factorCodes = item.factorCode?.split(';');
      List<String> factorNames = item.factorName?.split(';');
      List<String> factorUnits = item.factorUnit?.split(';');
      List<String> measureUppers = item.measureUpper?.split(';');
      List<String> measureLowers = item.measureLower?.split(';');
      for (int i = 0; i < inspectionTaskIds.length; i++) {
        itemList.add(RoutineInspectionUploadList(
          itemName: itemNames[i],
          inspectionTaskId: inspectionTaskIds[i],
          itemType: itemTypes[i],
          contentName: contentNames[i],
          inspectionStartTime: inspectionStartTimes[i],
          inspectionEndTime: inspectionEndTimes[i],
          factorCode: factorCodes != null ? factorCodes[i] : factorCodes,
          factorName: factorNames != null ? factorNames[i] : factorNames,
          factorUnit: factorUnits != null ? factorUnits[i] : factorUnits,
          measureUpper: measureUppers != null ? measureUppers[i] : measureUppers,
          measureLower: measureLowers != null ? measureLowers[i] : measureLowers,
        ));
      }
      return itemList.expand((content) {
        List<RoutineInspectionUploadList> contentList = [];
        List<String> inspectionTaskIds = content.inspectionTaskId.split(',');
        List<String> itemTypes = content.itemType.split(',');
        List<String> contentNames = content.contentName.split(',');
        List<String> inspectionStartTimes =
            content.inspectionStartTime.split(',');
        List<String> inspectionEndTimes = content.inspectionEndTime.split(',');
        // factorCode和factorName可能为null
        List<String> factorCodes = content.factorCode?.split(',');
        List<String> factorNames = content.factorName?.split(',');
        List<String> factorUnits = content.factorUnit?.split(',');
        List<String> measureUppers = content.measureUpper?.split(',');
        List<String> measureLowers = content.measureLower?.split(',');
        for (int j = 0; j < inspectionTaskIds.length; j++) {
          contentList.add(RoutineInspectionUploadList(
            // 下列是没有分号和逗号拼接的字段
            enterName: item.enterName,
            monitorName: item.monitorName,
            deviceName: item.deviceName,
            deviceId: item.deviceId,
            monitorId: item.monitorId,
            measurePrinciple: item.measurePrinciple,
            analysisMethod: item.analysisMethod,
            // itemName只有分号拼接，没有逗号拼接
            itemName: content.itemName,
            inspectionTaskId: inspectionTaskIds[j],
            itemType: itemTypes[j],
            contentName: contentNames[j],
            inspectionStartTime: inspectionStartTimes[j],
            inspectionEndTime: inspectionEndTimes[j],
            factorCode: factorCodes != null ? factorCodes[j] : factorCodes,
            factorName: factorNames != null ? factorNames[j] : factorNames,
            factorUnit: factorUnits != null ? factorUnits[j] : factorUnits,
            measureUpper: measureUppers != null ? measureUppers[j] : measureUppers,
            measureLower: measureLowers != null ? measureLowers[j] : measureLowers,
          ));
        }
        return contentList;
      });
    }).toList();
  }
}
