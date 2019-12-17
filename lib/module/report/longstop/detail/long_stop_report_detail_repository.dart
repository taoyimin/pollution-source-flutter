import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/report/longstop/detail/long_stop_report_detail_model.dart';
import 'package:pollution_source/res/constant.dart';

class LongStopReportDetailRepository
    extends DetailRepository<LongStopReportDetail> {
  @override
  Future<LongStopReportDetail> request({
    String detailId,
    Map<String, dynamic> params,
    CancelToken cancelToken,
  }) async {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      Response response = await JavaDioUtils.instance.getDio().get(
            HttpApiJava.reportDetail,
            queryParameters: {'reportId': detailId, 'dataType': 'L'},
            cancelToken: cancelToken,
          );
      return LongStopReportDetail.fromJson(
          response.data[Constant.responseDataKey]);
    } else {
      Response response = await PythonDioUtils.instance.getDio().get(
            '${HttpApiPython.longStopReports}/$detailId',
            queryParameters: params,
            cancelToken: cancelToken,
          );
      return LongStopReportDetail.fromJson(response.data);
    }
  }
}
