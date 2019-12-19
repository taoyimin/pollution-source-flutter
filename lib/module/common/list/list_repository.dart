import 'package:dio/dio.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_model.dart';
import 'package:pollution_source/util/compat_utils.dart';

/// 所有列表界面存储库的基类
///
/// 在[request]方法中已经实现了网络请求相关业务
/// 子类只需规定泛型和重写[createApi]，[fromJson]两个抽象方法即可
abstract class ListRepository<T> {
  Future<ListPage<T>> request(
      {Map<String, dynamic> params, CancelToken cancelToken}) async {
    Response response = await CompatUtils.getDio().get(
        CompatUtils.getApi(createApi()),
        queryParameters: params,
        cancelToken: cancelToken);
    return ListPage.fromJson<T>(
        json: CompatUtils.getResponseData(response), fromJson: fromJson);
  }

  HttpApi createApi();

  T fromJson(json);
}