import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/collection/collection_repository.dart';

import 'mobile_law_model.dart';

class MobileLawRepository extends CollectionRepository<MobileLaw> {
  @override
  HttpApi createApi() {
    return HttpApi.mobileLawList;
  }

  @override
  MobileLaw fromJson(json) {
    return MobileLaw.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [orderId] 报警管理单Id
  static Map<String, dynamic> createParams({orderId = ''}) {
    return {'id': orderId};
  }
}
