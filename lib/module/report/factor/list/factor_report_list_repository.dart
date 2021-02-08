import 'package:flustars/flustars.dart';
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
  /// [cityCode] 按城市搜索
  /// [areaCode] 按县区搜索
  /// [enterId] 筛选某企业的所有因子异常申报单
  /// [dischargeId] 筛选某排口的所有因子异常申报单
  /// [monitorId] 筛选某监控点的所有因子异常申报单
  /// [startTime] 申报开始时间
  /// [endTime] 申报结束时间
  /// [state] 状态 0：待审核 1：审核通过 2：审核不通过（目前只要上报成功就默认审核通过，暂时不用该参数）
  /// [valid] 是否生效 0：生效中 1：已失效
  /// [attentionLevel] 关注程度 0：其他 1：重点
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    cityCode = '',
    areaCode = '',
    enterId = '',
    dischargeId = '',
    monitorId = '',
    startTime,
    endTime,
    state = '',
    valid = '',
    attentionLevel = '',
  }) {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'start': (currentPage - 1) * pageSize,
      'length': pageSize,
      'enterName': enterName,
      'enterpriseName': enterName,
      'cityCode': cityCode,
      'areaCode': areaCode,
      'enterId': enterId,
      'dischargeId': dischargeId,
      'outId': dischargeId,
      'monitorId': monitorId,
      'dataType': 'A',
      'startTimeQ': DateUtil.formatDate(startTime ),
      'endTimeQ': DateUtil.formatDate(endTime?.add(Duration(hours: 23, minutes: 59, seconds: 59))),
      'attentionLevel': attentionLevel,
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
