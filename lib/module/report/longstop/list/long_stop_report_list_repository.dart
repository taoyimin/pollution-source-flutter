import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/report/longstop/list/long_stop_report_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class LongStopReportListRepository extends ListRepository<LongStopReport> {
  @override
  HttpApi createApi() {
    return HttpApi.longStopReportList;
  }

  @override
  LongStopReport fromJson(json) {
    return LongStopReport.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [enterName] 按企业名称搜索
  /// [areaCode] 按区域搜索
  /// [enterId] 筛选某企业的所有长期停产申报单
  /// [state] 状态 0：待审核 1：审核通过 2：审核不通过（目前只要上报成功就默认审核通过，暂时不用该参数）
  /// [valid] 是否生效 0：生效中 1：已失效
  /// [attentionLevel] 关注程度 0：其他 1：重点
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    enterId = '',
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
      'areaCode': areaCode,
      'enterId': enterId,
      'dataType': 'L',
      'hasValid': valid,
      'attentionLevel': attentionLevel,
    };
  }
}
