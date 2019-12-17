import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/report/factor/detail/factor_report_detail_model.dart';
import 'package:pollution_source/res/constant.dart';

class FactorReportDetailRepository
    extends DetailRepository<FactorReportDetail> {
  @override
  Future<FactorReportDetail> request({
    String detailId,
    Map<String, dynamic> params,
    CancelToken cancelToken,
  }) async {
    if(SpUtil.getBool(Constant.spJavaApi, defValue: true)){
      Response response = await JavaDioUtils.instance.getDio().get(
        HttpApiJava.reportDetail,
        queryParameters: {'reportId': detailId, 'dataType': 'A'},
        cancelToken: cancelToken,
      );
      return FactorReportDetail.fromJson(response.data[Constant.responseDataKey]);
    }else{
      Response response = await PythonDioUtils.instance.getDio().get(
        '${HttpApiPython.factorReports}/$detailId',
        queryParameters: params,
        cancelToken: cancelToken,
      );
      return FactorReportDetail.fromJson(response.data);
    }
  }
}
