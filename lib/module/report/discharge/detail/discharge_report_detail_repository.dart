import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/report/discharge/detail/discharge_report_detail_model.dart';
import 'package:pollution_source/res/constant.dart';

class DischargeReportDetailRepository
    extends DetailRepository<DischargeReportDetail> {
  @override
  Future<DischargeReportDetail> request({
    String detailId,
    Map<String, dynamic> params,
    CancelToken cancelToken,
  }) async {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      Response response = await JavaDioUtils.instance.getDio().get(
        HttpApiJava.reportDetail,
        queryParameters: {'stopApplyId': detailId},
        cancelToken: cancelToken,
      );
      return DischargeReportDetail.fromJson(
          response.data[Constant.responseDataKey]);
    } else {
      Response response = await PythonDioUtils.instance.getDio().get(
            '${HttpApiPython.dischargeReports}/$detailId',
            queryParameters: params,
            cancelToken: cancelToken,
          );
      return DischargeReportDetail.fromJson(response.data);
    }
  }
}
