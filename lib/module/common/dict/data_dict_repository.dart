import 'package:dio/dio.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/compat_utils.dart';

/// 数据字典存储库
//class DataDictRepository {
//  final HttpApi httpApi;
//
//  DataDictRepository(this.httpApi);
//
//  Future<List<DataDict>> request(
//      {Map<String, dynamic> params, CancelToken cancelToken}) async {
//    Response response = await CompatUtils.getDio().get(
//      '${CompatUtils.getApi(httpApi)}',
//      queryParameters: params,
//      cancelToken: cancelToken,
//    );
//    return CompatUtils.getResponseData(response).map<DataDict>((json) {
//      return DataDict.fromJson(json);
//    }).toList();
//  }
//}
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
    return CompatUtils.getResponseData(response).map<DataDict>((json) {
      return fromJson(json);
    }).toList();
  }

  DataDict fromJson(json){
    return DataDict.fromJson(json);
  }
}
