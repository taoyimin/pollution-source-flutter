import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/order/list/order_list.dart';
import 'package:pollution_source/res/constant.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  @override
  OrderListState get initialState => OrderListLoading();

  @override
  Stream<OrderListState> mapEventToState(OrderListEvent event) async* {
    if (event is OrderListLoad) {
      //加载报警管理单列表
      yield* _mapOrderListLoadToState(event);
    }
  }

  Stream<OrderListState> _mapOrderListLoadToState(OrderListLoad event) async* {
    try {
      final currentState = state;
      if (!event.isRefresh && currentState is OrderListLoaded) {
        //加载更多
        final orderList = await _getOrderList(
          currentPage: currentState.currentPage + 1,
          enterName: event.enterName,
          areaCode: event.areaCode,
          state: event.state,
        );
        yield OrderListLoaded(
          orderList: currentState.orderList + orderList,
          currentPage: currentState.currentPage + 1,
          hasNextPage: currentState.pageSize == orderList.length,
        );
      } else {
        //首次加载或刷新
        final orderList = await _getOrderList(
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
    } catch (e) {
      yield OrderListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取报警管理单列表数据
  Future<List<Order>> _getOrderList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    state = '1',
  }) async {
    Response response = await DioUtils.instance.getDio().get(
      HttpApi.orderList,
      queryParameters: {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterpriseName': enterName,
        'areaCode': areaCode,
        'status': state,
      },
    );
    return response.data[Constant.responseDataKey][Constant.responseListKey]
        .map<Order>((json) {
      return Order.fromJson(json);
    }).toList();
  }
}
