import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/license/list/license_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class LicenseListRepository extends ListRepository<License> {
  @override
  HttpApi createApi() {
    return HttpApi.licenseList;
  }

  @override
  License fromJson(json) {
    return License.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [enterId] 筛选某企业的排污许可证
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterId = '',
  }) {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'start': (currentPage - 1) * pageSize,
      'length': pageSize,
      'enterId': enterId,
    };
  }
}
