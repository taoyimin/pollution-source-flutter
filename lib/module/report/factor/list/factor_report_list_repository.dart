import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_model.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/report/factor/list/factor_report_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class FactorReportListRepository extends ListRepository<FactorReport> {
  @override
  Future<ListPage<FactorReport>> request(
      {Map<String, dynamic> params, CancelToken cancelToken}) async {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      Response response = await JavaDioUtils.instance.getDio().get(
          HttpApiJava.reportList,
          queryParameters: params,
          cancelToken: cancelToken);
      return ListPage.fromJson<FactorReport>(
          json: response.data[Constant.responseDataKey],
          fromJson: (json) {
            return FactorReport.fromJson(json);
          });
    } else {
      Response response = await PythonDioUtils.instance.getDio().get(
          HttpApiPython.factorReports,
          queryParameters: params,
          cancelToken: cancelToken);
      return ListPage.fromJson<FactorReport>(
          json: response.data,
          fromJson: (json) {
            return FactorReport.fromJson(json);
          });
    }
  }

  /// 生成请求所需的参数
  ///
  /// [enterName] 按企业名称搜索
  /// [areaCode] 按区域搜索
  /// [enterId] 筛选某企业的所有因子异常申报单
  /// [dischargeId] 筛选某排口的所有因子异常申报单
  /// [monitorId] 筛选某监控点的所有因子异常申报单
  /// [state] 状态 0：待审核 1：审核通过 2：审核不通过（目前只要上报成功就默认审核通过）
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    enterId = '',
    dischargeId = '',
    monitorId = '',
    state = '',
  }) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterpriseName': enterName,
        'areaCode': areaCode,
        'enterId': enterId,
        'dischargeId': dischargeId,
        'monitorId': monitorId,
        'dataType': 'A',
        'QIsReview': state,
      };
    } else {
      return {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterName': enterName,
        'areaCode': areaCode,
        'enterId': enterId,
        'dischargeId': dischargeId,
        'monitorId': monitorId,
        'state': state,
      };
    }
  }
}
