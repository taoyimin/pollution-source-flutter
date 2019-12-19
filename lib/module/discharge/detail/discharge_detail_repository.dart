import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_model.dart';

class DischargeDetailRepository extends DetailRepository<DischargeDetail> {
  @override
  HttpApi createApi() {
    return HttpApi.dischargeDetail;
  }

  @override
  DischargeDetail fromJson(json) {
    return DischargeDetail.fromJson(json);
  }
}
