import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_model.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/license/list/license_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class LicenseListRepository extends ListRepository<License> {
  @override
  Future<ListPage<License>> request(
      {Map<String, dynamic> params, CancelToken cancelToken}) async {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      Response response = await JavaDioUtils.instance.getDio().get(
          HttpApiJava.licenseList,
          queryParameters: params,
          cancelToken: cancelToken);
      return ListPage.fromJson<License>(
          json: response.data[Constant.responseDataKey],
          fromJson: (json) {
            return License.fromJson(json);
          });
    } else {
      Response response = await PythonDioUtils.instance.getDio().get(
          HttpApiPython.licenses,
          queryParameters: params,
          cancelToken: cancelToken);
      return ListPage.fromJson<License>(
          json: response.data,
          fromJson: (json) {
            return License.fromJson(json);
          });
    }
  }

  /// 生成请求所需的参数
  ///
  /// [enterId] 筛选某企业的排污许可证
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterId = '',
  }) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterId': enterId,
      };
    } else {
      return {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterId': enterId,
      };
    }
  }
}
