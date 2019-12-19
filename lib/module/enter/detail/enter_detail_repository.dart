import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';

import 'enter_detail_model.dart';

class EnterDetailRepository extends DetailRepository<EnterDetail> {
  @override
  HttpApi createApi() {
    return HttpApi.enterDetail;
  }

  @override
  EnterDetail fromJson(json) {
    return EnterDetail.fromJson(json);
  }
}
