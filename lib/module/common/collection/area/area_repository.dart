import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/collection/collection_repository.dart';

import 'area_model.dart';

class AreaRepository extends CollectionRepository<Area> {
  @override
  HttpApi createApi() {
    return HttpApi.areaList;
  }

  @override
  Area fromJson(json) {
    return Area.fromJson(json);
  }
}
