import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:meta/meta.dart';

import 'order_detail.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  @override
  OrderDetailState get initialState => OrderDetailLoading();

  @override
  Stream<OrderDetailState> mapEventToState(OrderDetailEvent event) async* {
    if (event is OrderDetailLoad) {
      //加载报警管理单详情
      yield* _mapOrderDetailLoadToState(event);
    }
  }

  Stream<OrderDetailState> _mapOrderDetailLoadToState(
      OrderDetailLoad event) async* {
    try {
      final orderDetail = await _getOrderDetail(orderId: event.orderId);
      yield OrderDetailLoaded(orderDetail: orderDetail);
    } catch (e) {
      yield OrderDetailError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取报警管理单详情
  Future<OrderDetail> _getOrderDetail({@required orderId}) async {
    if(SpUtil.getBool(Constant.spJavaApi, defValue: true)){
      Response response = await DioUtils.instance.getDio().get(
        HttpApi.orderDetail,
        queryParameters: {'orderId': orderId},
      );
      return OrderDetail.fromJson(response.data[Constant.responseDataKey]);
    }else{
      Response response = await DioUtils.instance.getDio().get(
        'orders/$orderId',
      );
      return OrderDetail.fromJson(response.data);
    }
  }
}
