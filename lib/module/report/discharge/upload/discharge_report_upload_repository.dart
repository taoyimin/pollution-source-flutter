import 'dart:async';

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
    //if (data.discharge == null || data.discharge.dischargeId.isEmpty)
    if (data.discharge == null)
      throw DioError(error: InvalidParamException('请选择排口'));
    //if (data.monitor == null || data.monitor.monitorId.isEmpty)
    if (data.monitor == null)
      throw DioError(error: InvalidParamException('请选择监控点'));
    if (data.stopType == null)
      throw DioError(error: InvalidParamException('请选择停产类型'));
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
      'dischargeId': data.discharge.dischargeId,
      'outId': data.discharge.dischargeId,
      'monitorId': data.monitor.monitorId,
      'startTime': data.startTime.toString(),
      'endTime': data.endTime.toString(),
      'alarmType': data.stopType.code,
      'stopReason': data.stopReason,
      "file": await Future.wait(data.attachments?.map((asset) async {
            return await MultipartFile.fromFile(await asset.filePath,
                filename: asset.name);
          })?.toList() ??
          [])
    });
  }
}
