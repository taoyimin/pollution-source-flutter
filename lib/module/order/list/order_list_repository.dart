import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/order/list/order_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class OrderListRepository extends ListRepository<Order> {
  @override
  HttpApi createApi() {
    return HttpApi.orderList;
  }

  @override
  Order fromJson(json) {
    return Order.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [enterName] 按企业名称搜索
  /// [areaCode] 按区域搜索
  /// [state] 状态
  /// [enterId] 筛选某企业的所有报警管理单
  /// [monitorId] 帅选某监控点的所有报警管理单
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    state = '',
    enterId = '',
    monitorId = '',
  }) {
    if (SpUtil.getBool(Constant.spUseJavaApi, defValue: Constant.defaultUseJavaApi)) {
      return {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterpriseName': enterName,
        'areaCode': areaCode,
        'status': state,
      };
    } else {
      return {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterName': enterName,
        'areaCode': areaCode,
        'state': state,
        'enterId': enterId,
        'monitorId': monitorId,
      };
    }
  }
}
