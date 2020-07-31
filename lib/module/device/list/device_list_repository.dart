import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';

import 'device_list_model.dart';

class DeviceListRepository extends ListRepository<Device> {
  @override
  HttpApi createApi() {
    return HttpApi.deviceList;
  }

  @override
  Device fromJson(json) {
    return Device.fromJson(json);
  }

  /// 生成请求所需的参数
  static Map<String, dynamic> createParams({
    monitorId = '',
  }) {
    return {
      'monitorId': monitorId,
    };
  }
}
