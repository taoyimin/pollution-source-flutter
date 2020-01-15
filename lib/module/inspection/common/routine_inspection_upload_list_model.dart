import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routine_inspection_upload_list_model.g.dart';

// 常规巡检上报列表
@JsonSerializable()
class RoutineInspectionUploadList extends Equatable {
  final String inspectionTaskId;
  final String itemName;
  final String itemType;
  final String contentName;
  final String inspectionStartTime;
  final String inspectionEndTime;
  final String inspectionRemark;
  final String remark;
  final String deviceName;
  @JsonKey(name: 'enterpriseName')
  final String enterName;
  @JsonKey(name: 'disOutName')
  final String dischargeName;
  @JsonKey(name: 'disMonitorName')
  final String monitorName;
  final String factorCode;
  final String monitorId;
  final String deviceId;
  final String factorName;

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
        for (int j = 0; j < inspectionTaskIds.length; j++) {
          contentList.add(RoutineInspectionUploadList(
            // 下列是没有分号和逗号拼接的字段
            enterName: item.enterName,
            monitorName: item.monitorName,
            deviceName: item.deviceName,
            deviceId: item.deviceId,
            monitorId: item.monitorId,
            // itemName只有分号拼接，没有逗号拼接
            itemName: content.itemName,
            inspectionTaskId: inspectionTaskIds[j],
            itemType: itemTypes[j],
            contentName: contentNames[j],
            inspectionStartTime: inspectionStartTimes[j],
            inspectionEndTime: inspectionEndTimes[j],
            factorCode: factorCodes != null ? factorCodes[j] : factorCodes,
            factorName: factorNames != null ? factorNames[j] : factorNames,
          ));
        }
        return contentList;
      });
    }).toList();
  }
}
