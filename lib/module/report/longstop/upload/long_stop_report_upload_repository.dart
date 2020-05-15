import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/report/longstop/upload/long_stop_report_upload_model.dart';

class LongStopReportUploadRepository
    extends UploadRepository<LongStopReportUpload, String> {
  @override
  checkData(LongStopReportUpload data) {
    if (data.enter == null)
      throw DioError(error: InvalidParamException('请选择企业'));
    if (data.startTime == null)
      throw DioError(error: InvalidParamException('请选择开始时间'));
    if (data.endTime == null)
      throw DioError(error: InvalidParamException('请选择结束时间'));
/*    if (data.endTime.difference(data.startTime).inDays < 90)
      throw DioError(error: InvalidParamException('停产时间必须大于90天'));*/
    if (data.remark.isEmpty)
      throw DioError(error: InvalidParamException('请输入描述'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.longStopReportUpload;
  }

  @override
  Future<FormData> createFormData(LongStopReportUpload data) async {
    return FormData.fromMap({
      'enterId': data.enter.enterId,
      'startTime': data.startTime.toString(),
      'endTime': data.endTime.toString(),
      'remark': data.remark,
    });
  }
}
