import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/util/common_utils.dart';

import 'standard_replace_upload_model.dart';

class StandardReplaceUploadRepository
    extends UploadRepository<StandardReplaceUpload, String> {
  @override
  checkData(StandardReplaceUpload data) {
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
      // 废水必须选择设备
      throw DioError(error: InvalidParamException('请选择设备名称'));
    if (TextUtil.isEmpty(data.amount.text))
      throw DioError(error: InvalidParamException('请输入数量'));
    if (TextUtil.isEmpty(data.standardSampleName.text))
      throw DioError(error: InvalidParamException('请输入标准样品名称'));
    if (TextUtil.isEmpty(data.standardSamplePotency.text))
      throw DioError(error: InvalidParamException('请输入标准样品浓度'));
    if (data.replaceTime == null)
      throw DioError(error: InvalidParamException('请选择更换时间'));
    if (TextUtil.isEmpty(data.replacePerson.text))
      throw DioError(error: InvalidParamException('请输入更换人员'));
    if (data.validityTime == null)
      throw DioError(error: InvalidParamException('请选择有效期'));
    if (data.attachments == null || data.attachments.length == 0)
      throw DioError(error: InvalidParamException('请选择附件上传'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.standardReplaceUpload;
  }

  @override
  Future<FormData> createFormData(StandardReplaceUpload data) async {
    return FormData.fromMap({
      'latitude': data.baiduLocation.latitude.toString(),
      'longitude': data.baiduLocation.longitude.toString(),
      'address': CommonUtils.getDetailAddress(data.baiduLocation),
      'standardSampleId': '',
      'enterId': data.enter.enterId,
      'outId': data.monitor.dischargeId,
      'monitorId': data.monitor.monitorId,
      'onlineDeviceId': data.device?.deviceId,
      'amount': data.amount.text,
      'standardSampleName': data.standardSampleName.text,
      'standardSamplePotency': data.standardSamplePotency.text,
      'mixTime':
          DateUtil.formatDate(data.mixTime, format: DateFormats.y_mo_d_h_m),
      'mixPerson': data.mixPerson.text,
      'replaceTime':
          DateUtil.formatDate(data.replaceTime, format: DateFormats.y_mo_d_h_m),
      'replacePerson': data.replacePerson.text,
      'validityTime':
          DateUtil.formatDate(data.validityTime, format: DateFormats.y_mo_d),
      'maintainPerson': data.maintainPerson.text,
      'maintainTime': DateUtil.formatDate(data.maintainTime,
          format: DateFormats.y_mo_d_h_m),
      'unit': data.unit.text,
      'supplier': data.supplier.text,
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
