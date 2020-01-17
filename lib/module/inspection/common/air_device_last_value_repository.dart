import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/inspection/common/air_device_last_value_model.dart';

class AirDeviceLastValueRepository
    extends DetailRepository<AirDeviceLastValue> {
  @override
  HttpApi createApi() {
    return HttpApi.deviceCorrectLastValue;
  }

  @override
  AirDeviceLastValue fromJson(json) {
    return AirDeviceLastValue.fromJson(json);
  }
}
