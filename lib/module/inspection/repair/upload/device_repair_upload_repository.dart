import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';

import 'device_repair_upload_model.dart';

class DeviceRepairUploadRepository
    extends UploadRepository<DeviceRepairUpload, String> {
  @override
  checkData(DeviceRepairUpload data) {
    if (data.baiduLocation == null || data.baiduLocation.latitude == null || data.baiduLocation.longitude == null)
      throw DioError(error: InvalidParamException('请先获取位置信息'));
    if (data.enter == null)
      throw DioError(error: InvalidParamException('请选择企业'));
    if (data.monitor == null)
      throw DioError(error: InvalidParamException('请选择监控点'));
    if (data.monitor.dischargeId == null) {
      throw DioError(
          error: InvalidParamException(
              'monitorId=${data.monitor.monitorId}的监控点没有对应的排口Id'));
    }
    if (data.device == null)
      throw DioError(error: InvalidParamException('请选择设备名称'));
    if (TextUtil.isEmpty(data.faultEquipmentName.text))
      throw DioError(error: InvalidParamException('请输入故障设备名称'));
    if (data.faultTime == null)
      throw DioError(error: InvalidParamException('请选择故障发生时间'));
    if (data.workTime == null)
      throw DioError(error: InvalidParamException('请选择恢复正常时间'));
    if (TextUtil.isEmpty(data.faultRemark.text))
      throw DioError(error: InvalidParamException('请输入故障描述情况'));
    if (TextUtil.isEmpty(data.overhaulRemark.text))
      throw DioError(error: InvalidParamException('请输入检修情况总结'));
    if (data.attachments == null || data.attachments.length == 0)
      throw DioError(error: InvalidParamException('请选择附件上传'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.deviceRepairUpload;
  }

  @override
  Future<FormData> createFormData(DeviceRepairUpload data) async {
    return FormData.fromMap({
      'latitude': data.baiduLocation.latitude.toString(),
      'longitude': data.baiduLocation.longitude.toString(),
      'address': data.baiduLocation.locationDetail??'无',
      'enterId': data.enter.enterId,
      'outId': data.monitor.dischargeId,
      'monitorId': data.monitor.monitorId,
      'onlineDeviceId': data.device?.deviceId,
      'deviceNumber': data.device?.deviceNo,
      'faultEquipmentName': data.faultEquipmentName.text,
      'faultTime':
          DateUtil.formatDate(data.faultTime, format: DateFormats.y_mo_d_h_m),
      'workTime':
          DateUtil.formatDate(data.workTime, format: DateFormats.y_mo_d_h_m),
      'faultRemark': data.faultRemark.text,
      'replacePart': data.replacePart.text,
      'overhaulRemark': data.overhaulRemark.text,
      'dealType': 'app',
      "file": await Future.wait(data.attachments?.map((asset) async {
            ByteData byteData = await asset.getByteData();
            return MultipartFile.fromBytes(byteData.buffer.asUint8List(),
                filename: asset.name);
          })?.toList() ??
          [])
    });
  }
}
