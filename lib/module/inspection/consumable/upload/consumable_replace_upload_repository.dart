import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';

import 'consumable_replace_upload_model.dart';

class ConsumableReplaceUploadRepository
    extends UploadRepository<ConsumableReplaceUpload, String> {
  @override
  checkData(ConsumableReplaceUpload data) {
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
    if (data.monitor.monitorType == 'outletType2' && data.device == null)
      // 废水需要选择设备
      throw DioError(error: InvalidParamException('请选择设备名称'));
    if (TextUtil.isEmpty(data.consumableName.text))
      throw DioError(error: InvalidParamException('请输入易耗品名称'));
    if (data.validityTime == null)
      throw DioError(error: InvalidParamException('请选择有效期'));
    if (data.replaceTime == null)
      throw DioError(error: InvalidParamException('请选择更换日期'));
    if (TextUtil.isEmpty(data.amount.text))
      throw DioError(error: InvalidParamException('请输入数量'));
    if (TextUtil.isEmpty(data.unit.text))
      throw DioError(error: InvalidParamException('请输入计量单位'));
    if (data.attachments == null || data.attachments.length == 0)
      throw DioError(error: InvalidParamException('请选择附件上传'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.consumableReplaceUpload;
  }

  @override
  Future<FormData> createFormData(ConsumableReplaceUpload data) async {
    return FormData.fromMap({
      'latitude': data.baiduLocation.latitude.toString(),
      'longitude': data.baiduLocation.longitude.toString(),
      'address': data.baiduLocation.locationDetail??'无',
      'consumableChangeId': '',
      'enterId': data.enter.enterId,
      'outId': data.monitor.dischargeId,
      'monitorId': data.monitor.monitorId,
      'onlineDeviceId': data.device?.deviceId,
      'consumableName': data.consumableName.text,
      'specificationType': data.specificationType.text,
      'validityTime': DateUtil.formatDate(data.validityTime, format: DateFormats.y_mo_d),
      'replaceTime': DateUtil.formatDate(data.replaceTime, format: DateFormats.y_mo_d_h_m),
      'amount': data.amount.text,
      'unit': data.unit.text,
      'maintainPerson': data.maintainPerson.text,
      'maintainTime': DateUtil.formatDate(data.maintainTime, format: DateFormats.y_mo_d_h_m),
      'replaceRemark': data.replaceRemark.text,
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
