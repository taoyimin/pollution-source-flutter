import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/order/detail/order_detail_model.dart';

class OrderDetailRepository extends DetailRepository<OrderDetail> {
  @override
  HttpApi createApi() {
    return HttpApi.orderDetail;
  }

  @override
  OrderDetail fromJson(json) {
    return OrderDetail.fromJson(json);
  }

}
