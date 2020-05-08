import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';

import 'warn_detail_model.dart';

class WarnDetailRepository extends DetailRepository<WarnDetail> {
  @override
  HttpApi createApi() {
    return HttpApi.warnDetail;
  }

  @override
  WarnDetail fromJson(json) {
    return WarnDetail.fromJson(json);
  }
}
