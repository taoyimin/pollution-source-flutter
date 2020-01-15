import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/inspection/param/water/upload/water_device_param_upload_model.dart';

/// 废水设备参数列表存储库
class WaterDeviceParamListRepository
    extends ListRepository<WaterDeviceParamType> {
  @override
  HttpApi createApi() {
    return HttpApi.deviceParamList;
  }

  @override
  WaterDeviceParamType fromJson(json) {
    return WaterDeviceParamType(
      parameterType: json['Dic_Sub_Desc'] as String,
      waterDeviceParamNameList:
          (json['dic_thr_name'] as String).split(',').map((item) {
        return WaterDeviceParamName(parameterName: item);
      }).toList(),
    );
  }
}
