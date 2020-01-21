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
  /// [state] 状态 0：全部 1：待督办 2：待处理 3：待审核 4：审核不通过 5：已办结
  /// [enterId] 筛选某企业的所有报警管理单
  /// [monitorId] 筛选某监控点的所有报警管理单
  /// [overdue] 超期 0：全部 1：超期
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    state = '',
    enterId = '',
    monitorId = '',
    overdue = '',
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
      'monitorId': monitorId,
      'status': state,
      'overdue': overdue,
      // 运维系统的状态参数
      'orderState': () {
        switch (state) {
          case '1':
            return '10';
          case '2':
            return '20';
          case '3':
            return '30';
          case '4':
            return '40';
          case '5':
            return '50';
          default:
            return '';
        }
      }(),
    };
  }
}
