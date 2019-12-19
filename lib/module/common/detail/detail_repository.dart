import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/util/compat_utils.dart';

/// 所有详情界面存储库的基类
///
/// 在[request]方法中已经实现了网络请求相关业务
/// 子类只需规定泛型和重写[createApi]，[fromJson]两个抽象方法即可
abstract class DetailRepository<T> {
  Future<T> request(
      {@required String detailId,
      Map<String, dynamic> params,
      CancelToken cancelToken}) async {
    Response response = await CompatUtils.getDio().get(
      '${CompatUtils.getApi(createApi())}$detailId',
      queryParameters: params,
      cancelToken: cancelToken,
    );
    return fromJson(CompatUtils.getResponseData(response));
  }

  HttpApi createApi();

  T fromJson(json);
}
