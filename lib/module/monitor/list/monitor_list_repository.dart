import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class MonitorListRepository extends ListRepository<Monitor> {
  @override
  HttpApi createApi() {
    return HttpApi.monitorList;
  }

  @override
  Monitor fromJson(json) {
    return Monitor.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [enterName] 按企业名称搜索
  /// [areaCode] 按区域搜索
  /// [enterId] 筛选某企业的所有监控点
  /// [dischargeId] 筛选某排口的所有监控点
  /// [monitorType] 监控点类型 outletType1：雨水 outletType2：废水 outletType3：废气
  /// [state] 监控点状态 all：全部 online：在线 warn：预警 outrange：超标 negativeValue：负值 ultraUpperlimit：超大值 6：零值 offline：脱机 stopline：异常申报
  /// [outType] 排放类型
  /// [attentionLevel] 关注程度 0:非重点 1:重点
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    enterId = '',
    dischargeId = '',
    monitorType = '',
    state = '',
    outType = '',
    attentionLevel = '',
  }) {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'start': (currentPage - 1) * pageSize,
      'length': pageSize,
      'enterpriseName': enterName,
      'enterName': enterName,
      'areaCode': areaCode,
      'enterId': enterId,
      'outId': dischargeId,
      'monitorType': monitorType,
      'state': state,
      'outType': outType,
      'attentionLevel': attentionLevel,
    };
  }

  /// [state] 监控点状态 1：在线 2：预警 3：超标 4：负值 5：超大值 6：零值 7：脱机 8：异常申报
  static String convertState(String state){
    switch (state) {
      case '1':
        return 'online';
      case '2':
        return 'warn';
      case '3':
        return 'outrange';
      case '4':
        return 'negativeValue';
      case '5':
        return 'ultraUpperlimit';
      case '6':
        return 'zeroValue';
      case '7':
        return 'offline';
      case '8':
        return 'stopline';
      default:
        return 'all';
    }
  }
}
