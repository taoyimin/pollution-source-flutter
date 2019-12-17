import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/report/longstop/upload/long_stop_report_upload_model.dart';

class LongStopReportUploadRepository
    extends UploadRepository<LongStopReportUpload, String> {
  @override
  Future<String> upload({LongStopReportUpload data, CancelToken cancelToken}) async {
    checkData(data);
    Response response = await PythonDioUtils.instance
        .getDio()
        .post(HttpApiPython.longStopReports,
            cancelToken: cancelToken,
            data: FormData.fromMap({
              'enterId': data.enterId,
              'startTime': data.startTime.toString(),
              'endTime': data.endTime.toString(),
              'remark': data.remark,
            }));
    return response.data['message'];
  }

  checkData(LongStopReportUpload data) {
    if (data.enterId.isEmpty)
      throw DioError(error: InvalidParamException('企业Id为空'));
    if (data.startTime == null)
      throw DioError(error: InvalidParamException('请选择开始时间'));
    if (data.endTime == null)
      throw DioError(error: InvalidParamException('请选择结束时间'));
    if (data.remark.isEmpty)
      throw DioError(error: InvalidParamException('请输入描述'));
  }
}
