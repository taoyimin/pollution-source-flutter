import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_model.dart';

class MonitorDetailRepository
    extends DetailRepository<MonitorDetail> {
  @override
  HttpApi createApi() {
    return HttpApi.monitorDetail;
  }

  @override
  MonitorDetail fromJson(json) {
    return MonitorDetail.fromJson(json);
  }
}
