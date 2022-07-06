import 'package:meta/meta.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/order/detail/order_detail_model.dart';

class OrderDetailRepository extends DetailRepository<OrderDetail> {
  final int type; // 0:日督办单 1:小时督办单

  OrderDetailRepository({@required this.type}) : assert(type != null);

  @override
  HttpApi createApi() {
    if (type == 0) {
      return HttpApi.orderDetail;
    } else {
      return HttpApi.realOrderDetail;
    }
  }

  @override
  OrderDetail fromJson(json) {
    return OrderDetail.fromJson(json);
  }

}
