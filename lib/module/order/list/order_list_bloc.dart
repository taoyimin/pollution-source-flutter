import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/order/list/order_list.dart';
import 'package:pollution_source/util/constant.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  @override
  OrderListState get initialState => OrderListLoading();

  @override
  Stream<OrderListState> mapEventToState(OrderListEvent event) async* {
    try {
      if (event is OrderListLoad) {
        yield* _mapOrderListLoadToState(event);
      }
    } catch (e) {
      yield OrderListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  Stream<OrderListState> _mapOrderListLoadToState(OrderListLoad event) async* {
    final currentState = state;
    if (!event.isRefresh && currentState is OrderListLoaded) {
      //加载更多
      final orderList = await getOrderList(
        currentPage: currentState.currentPage + 1,
        enterName: event.enterName,
        areaCode: event.areaCode,
        state: event.state,
      );
      yield OrderListLoaded(
        orderList: currentState.orderList + orderList,
        currentPage: currentState.currentPage + 1,
        hasNextPage:
            currentState.pageSize == orderList.length,
      );
    } else {
      //首次加载或刷新
      final orderList = await getOrderList(
        enterName: event.enterName,
        areaCode: event.areaCode,
        state: event.state,
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

  //获取报警管理单列表数据
  Future<List<Order>> getOrderList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    state = '1',
  }) async {
    Response response = await DioUtils.instance
        .getDio()
        .get(HttpApi.orderList, queryParameters: {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'enterpriseName': enterName,
      'areaCode': areaCode,
      'status': state,
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
