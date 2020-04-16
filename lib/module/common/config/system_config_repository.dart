import 'package:dio/dio.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/util/compat_utils.dart';

/// 系统配置存储库
class SystemConfigRepository {
  final HttpApi httpApi;

  SystemConfigRepository(this.httpApi);

  Future<SystemConfig> request(
      {CancelToken cancelToken}) async {
    Response response = await CompatUtils.getDio().get(
      '${CompatUtils.getApi(httpApi)}',
      cancelToken: cancelToken,
    );
    return CompatUtils.getResponseData(response).map<SystemConfig>((json) {
      return fromJson(json);
    }).toList()[0];
  }

  SystemConfig fromJson(json){
    return SystemConfig.fromJson(json);
  }
}
