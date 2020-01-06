import 'package:dio/dio.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/compat_utils.dart';

/// 数据字典存储库
class DataDictRepository {
  final HttpApi httpApi;

  DataDictRepository(this.httpApi);

  Future<List<DataDict>> request(
      {Map<String, dynamic> params, CancelToken cancelToken}) async {
    Response response = await CompatUtils.getDio().get(
      '${CompatUtils.getApi(httpApi)}',
      queryParameters: params,
      cancelToken: cancelToken,
    );
    return response.data[Constant.responseDataKey].map<DataDict>((json) {
      return DataDict.fromJson(json);
    }).toList();
  }
}
//abstract class DataDictRepository<T> {
//  Future<List<T>> request(
//      {Map<String, dynamic> params, CancelToken cancelToken}) async {
//    Response response = await CompatUtils.getDio().get(
//      '${CompatUtils.getApi(createApi())}',
//      queryParameters: params,
//      cancelToken: cancelToken,
//    );
//    return response.data[Constant.responseDataKey].map<T>((json) {
//      return fromJson(json);
//    }).toList();
//  }
//
//  HttpApi createApi();
//
//  T fromJson(json);
//}
