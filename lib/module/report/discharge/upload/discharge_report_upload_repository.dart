import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_model.dart';

class DischargeReportUploadRepository
    extends UploadRepository<DischargeReportUpload, String> {
  @override
  checkData(DischargeReportUpload data) {
    if (data.enter == null)
      throw DioError(error: InvalidParamException('请选择企业'));
    if (data.monitor == null)
      throw DioError(error: InvalidParamException('请选择监控点'));
    if (data.monitor.dischargeId == null) {
      throw DioError(error: InvalidParamException(
          'monitorId=${data.monitor.monitorId}的监控点没有对应的排口Id'));
    }
    if (data.stopType == null)
      throw DioError(error: InvalidParamException('请选择停产类型'));
    if (data.reportTime == null)
      throw DioError(error: InvalidParamException('请选择申报时间'));
    if (data.startTime == null)
      throw DioError(error: InvalidParamException('请选择开始时间'));
    if (data.endTime == null)
      throw DioError(error: InvalidParamException('请选择结束时间'));
    if (data.stopReason.isEmpty)
      throw DioError(error: InvalidParamException('请输入停产描述'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.dischargeReportUpload;
  }

  @override
  Future<FormData> createFormData(DischargeReportUpload data) async {
    return FormData.fromMap({
      'enterId': data.enter.enterId,
      'outId': data.monitor.dischargeId,
      'monitorId': data.monitor.monitorId,
      'startTime': data.startTime.toString(),
      'endTime': data.endTime.toString(),
      // 污染源系统的停产类型
      'alarmType': data.stopType.code,
      // 运维系统的停产类型
      'stopType': data.stopType.code,
      'stopReason': data.stopReason,
      "file": await Future.wait(data.attachments?.map((asset) async {
        ByteData byteData = await asset.getByteData();
        return MultipartFile.fromBytes(byteData.buffer.asUint8List(),
            filename: asset.name);
      })?.toList() ??
          [])
    });
  }
}
