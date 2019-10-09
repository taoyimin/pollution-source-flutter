import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'order_list.dart';
import 'package:pollution_source/util/constant.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  @override
  OrderListState get initialState => OrderListLoading();

  @override
  Stream<OrderListState> mapEventToState(OrderListEvent event) async* {
    try {
      if (event is OrderListLoad) {
        if (!event.isRefresh && currentState is OrderListLoaded) {
          //加载更多
          final orderList = await getOrderList(
            currentPage: (currentState as OrderListLoaded).currentPage + 1,
            enterName: event.enterName,
            areaCode: event.areaCode,
            status: event.status,
          );
          yield OrderListLoaded(
            orderList: (currentState as OrderListLoaded).orderList + orderList,
            currentPage: (currentState as OrderListLoaded).currentPage + 1,
            hasNextPage:
                (currentState as OrderListLoaded).pageSize == orderList.length,
          );
        } else {
          //首次加载或刷新
          final orderList = await getOrderList(
            enterName: event.enterName,
            areaCode: event.areaCode,
            status: event.status,
          );
          if (orderList.length == 0) {
            //没有数据
            yield OrderListEmpty();
          } else {
            yield OrderListLoaded(
              orderList: orderList,
              hasNextPage: Constant.defaultPageSize == orderList.length,
            );
          }
        }
      }
    } catch (e) {
      yield OrderListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取报警管理单列表数据
  Future<List<Order>> getOrderList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    status = '1',
  }) async {
    Response response = await DioUtils.instance
        .getDio()
        .get(HttpApi.orderList, queryParameters: {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'enterpriseName': enterName,
      'areaCode': areaCode,
      'status': status,
    });
    if (response.statusCode == ExceptionHandle.success &&
        response.data[Constant.responseCodeKey] ==
            ExceptionHandle.success_code) {
      return convertOrderList(
          response.data[Constant.responseDataKey][Constant.responseListKey]);
    } else {
      throw Exception('${response.data[Constant.responseMessageKey]}');
    }
  }

  //格式化报警管理单数据
  List<Order> convertOrderList(List<dynamic> jsonArray) {
    return jsonArray.map((json) {
      return Order.fromJson(json);
    }).toList();
  }
}
