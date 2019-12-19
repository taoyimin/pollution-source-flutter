import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/report/factor/upload/factor_report_upload_model.dart';

class FactorReportUploadRepository
    extends UploadRepository<FactorReportUpload, String> {

  checkData(FactorReportUpload data) {
    if (data.enterId.isEmpty)
      throw DioError(error: InvalidParamException('企业Id为空'));
    if (data.discharge == null || data.discharge.dischargeId.isEmpty)
      throw DioError(error: InvalidParamException('请选择排口'));
    if (data.monitor == null || data.monitor.monitorId.isEmpty)
      throw DioError(error: InvalidParamException('请选择监控点'));
    if (data.alarmType == null)
      throw DioError(error: InvalidParamException('请选择异常类型'));
    if (data.factorCode.isEmpty)
      throw DioError(error: InvalidParamException('请选择异常因子'));
    if (data.startTime == null)
      throw DioError(error: InvalidParamException('请选择开始时间'));
    if (data.endTime == null)
      throw DioError(error: InvalidParamException('请选择结束时间'));
    if (data.exceptionReason.isEmpty)
      throw DioError(error: InvalidParamException('请输入异常原因'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.factorReportUpload;
  }

  @override
  Future<FormData> createFormData(FactorReportUpload data) async {
    return FormData.fromMap({
      'enterId': data.enterId,
      'dischargeId': data.discharge.dischargeId,
      'monitorId': data.monitor.monitorId,
      'startTime': data.startTime.toString(),
      'endTime': data.endTime.toString(),
      'alarmType': data.alarmType,
      'factorCode': data.factorCode,
      'exceptionReason': data.exceptionReason,
      "file": await Future.wait(data.attachments?.map((asset) async {
            return await MultipartFile.fromFile(await asset.filePath,
                filename: asset.name);
          })?.toList() ??
          [])
    });
  }
}
