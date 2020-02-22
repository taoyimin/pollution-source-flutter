import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/report/factor/list/factor_report_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class FactorReportListRepository extends ListRepository<FactorReport> {
  @override
  HttpApi createApi() {
    return HttpApi.factorReportList;
  }

  @override
  FactorReport fromJson(json) {
    return FactorReport.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [enterName] 按企业名称搜索
  /// [areaCode] 按区域搜索
  /// [enterId] 筛选某企业的所有因子异常申报单
  /// [dischargeId] 筛选某排口的所有因子异常申报单
  /// [monitorId] 筛选某监控点的所有因子异常申报单
  /// [state] 状态 0：待审核 1：审核通过 2：审核不通过（目前只要上报成功就默认审核通过，暂时不用该参数）
  /// [valid] 是否有效 0：生效中 1：已失效
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    enterId = '',
    dischargeId = '',
    monitorId = '',
    state = '',
    valid = '',
  }) {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'start': (currentPage - 1) * pageSize,
      'length': pageSize,
      'enterName': enterName,
      'enterpriseName': enterName,
      'areaCode': areaCode,
      'enterId': enterId,
      'dischargeId': dischargeId,
      'outId': dischargeId,
      'monitorId': monitorId,
      'dataType': 'A',
      // 污染源参数
      'hasValid': valid,
      // 运维参数
      'effective': () {
        switch (valid) {
          case '0':
            return '1';
          case '1':
            return '0';
          default:
            return '';
        }
      }(),
    };
  }
}
