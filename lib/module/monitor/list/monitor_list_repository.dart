import 'package:flustars/flustars.dart';
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
  /// [monitorType] 监控点类型
  /// [state] 0：全部 1：在线 2：预警 3：超标 4：脱机 5：离线
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    enterId = '',
    dischargeId = '',
    monitorType = '',
    state = '',
  }) {
    if (SpUtil.getBool(Constant.spUseJavaApi, defValue: Constant.defaultUseJavaApi)) {
      return {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterpriseName': enterName,
        'areaCode': areaCode,
        'enterId': enterId,
        'monitorType': monitorType,
        'state': () {
          switch (state) {
            case '1':
              return 'online';
            case '2':
              return 'warn';
            case '3':
              return 'outrange';
            case '4':
              return 'offline';
            case '5':
              return 'stopline';
            default:
              return '';
          }
        }(),
      };
    } else {
      return {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterName': enterName,
        'areaCode': areaCode,
        'enterId': enterId,
        'dischargeId': dischargeId,
        'monitorType': monitorType,
        'state': state,
      };
    }
  }
}
