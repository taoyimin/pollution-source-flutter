import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';

import 'water_device_list_model.dart';

class WaterDeviceListRepository extends ListRepository<WaterDevice> {
  @override
  HttpApi createApi() {
    return HttpApi.deviceList;
  }

  @override
  WaterDevice fromJson(json) {
    return WaterDevice.fromJson(json);
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
