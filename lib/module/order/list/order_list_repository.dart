import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_model.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/order/list/order_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class OrderListRepository extends ListRepository<Order> {
  @override
  Future<ListPage<Order>> request(
      {Map<String, dynamic> params, CancelToken cancelToken}) async {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      Response response = await JavaDioUtils.instance.getDio().get(
          HttpApiJava.orderList,
          queryParameters: params,
          cancelToken: cancelToken);
      return ListPage.fromJson<Order>(
          json: response.data[Constant.responseDataKey],
          fromJson: (json) {
            return Order.fromJson(json);
          });
    } else {
      Response response = await PythonDioUtils.instance.getDio().get(
          HttpApiPython.orders,
          queryParameters: params,
          cancelToken: cancelToken);
      return ListPage.fromJson<Order>(
          json: response.data,
          fromJson: (json) {
            return Order.fromJson(json);
          });
    }
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
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
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
