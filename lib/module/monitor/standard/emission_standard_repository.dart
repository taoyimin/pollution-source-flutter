import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/monitor/standard/emission_standard_model.dart';

class EmissionStandardRepository extends ListRepository<EmissionStandard> {
  @override
  HttpApi createApi() {
    return HttpApi.standardList;
  }

  @override
  EmissionStandard fromJson(json) {
    return EmissionStandard.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [monitorId] 监控点Id
  static Map<String, dynamic> createParams({
    monitorId,
  }) {
    return {
      'monitorId': monitorId,
    };
  }
}
