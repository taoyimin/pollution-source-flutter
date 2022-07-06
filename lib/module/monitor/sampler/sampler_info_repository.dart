import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/monitor/sampler/sampler_info_model.dart';

class SamplerInfoRepository extends ListRepository<SamplerInfo> {
  @override
  HttpApi createApi() {
    return HttpApi.samplerList;
  }

  @override
  SamplerInfo fromJson(json) {
    return SamplerInfo.fromJson(json);
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
