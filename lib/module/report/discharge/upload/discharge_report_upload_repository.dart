import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_model.dart';

class DischargeReportUploadRepository
    extends UploadRepository<DischargeReportUpload, String> {
  @override
  Future<String> upload({DischargeReportUpload data, CancelToken cancelToken}) async {
    checkData(data);
    Response response = await PythonDioUtils.instance
        .getDio()
        .post(HttpApiPython.dischargeReports,
            cancelToken: cancelToken,
            data: FormData.fromMap({
              'enterId': data.enterId,
              'dischargeId': data.discharge.dischargeId,
              'monitorId': data.monitor.monitorId,
              'startTime': data.startTime.toString(),
              'endTime': data.endTime.toString(),
              'alarmType': data.stopType,
              'stopReason': data.stopReason,
              "file": await Future.wait(data.attachments?.map((asset) async {
                return await MultipartFile.fromFile(await asset.filePath,
                    filename: asset.name);
              })?.toList()??[])
            }));
    return response.data['message'];
  }

  checkData(DischargeReportUpload data) {
    if (data.enterId.isEmpty)
      throw DioError(error: InvalidParamException('企业Id为空'));
    if (data.discharge == null || data.discharge.dischargeId.isEmpty)
      throw DioError(error: InvalidParamException('请选择排口'));
    if (data.monitor == null || data.monitor.monitorId.isEmpty)
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
}
