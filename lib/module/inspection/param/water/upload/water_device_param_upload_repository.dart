import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/inspection/param/water/upload/water_device_param_upload_model.dart';

class WaterDeviceParamUploadRepository
    extends UploadRepository<WaterDeviceParamUpload, String> {
  @override
  checkData(WaterDeviceParamUpload data) {
    if (data.waterDeviceParamTypeList == null)
      throw DioError(error: InvalidParamException('请先加载巡检参数'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.deviceParamUpload;
  }

  @override
  Future<FormData> createFormData(WaterDeviceParamUpload data) async {
    FormData formData = FormData();
    formData.fields
      ..addAll(data.waterDeviceParamTypeList
          .expand((WaterDeviceParamType waterDeviceParamType) {
        return waterDeviceParamType.waterDeviceParamNameList
            .map((WaterDeviceParamName waterDeviceParamName) {
          return MapEntry('inspectionTaskId', data.inspectionTaskId);
        });
      }))
      ..addAll(data.waterDeviceParamTypeList
          .expand((WaterDeviceParamType waterDeviceParamType) {
        return waterDeviceParamType.waterDeviceParamNameList
            .map((WaterDeviceParamName waterDeviceParamName) {
          return MapEntry('parameterType', waterDeviceParamType.parameterType);
        });
      }))
      ..addAll(data.waterDeviceParamTypeList
          .expand((WaterDeviceParamType waterDeviceParamType) {
        return waterDeviceParamType.waterDeviceParamNameList
            .map((WaterDeviceParamName waterDeviceParamName) {
          return MapEntry('parameterName', waterDeviceParamName.parameterName);
        });
      }))
      ..addAll(data.waterDeviceParamTypeList
          .expand((WaterDeviceParamType waterDeviceParamType) {
        return waterDeviceParamType.waterDeviceParamNameList
            .map((WaterDeviceParamName waterDeviceParamName) {
          return MapEntry('originalVal', waterDeviceParamName.originalVal.text);
        });
      }))
      ..addAll(data.waterDeviceParamTypeList
          .expand((WaterDeviceParamType waterDeviceParamType) {
        return waterDeviceParamType.waterDeviceParamNameList
            .map((WaterDeviceParamName waterDeviceParamName) {
          return MapEntry('updateVal', waterDeviceParamName.updateVal.text);
        });
      }))
      ..addAll(data.waterDeviceParamTypeList
          .expand((WaterDeviceParamType waterDeviceParamType) {
        return waterDeviceParamType.waterDeviceParamNameList
            .map((WaterDeviceParamName waterDeviceParamName) {
          return MapEntry('modifyReason', waterDeviceParamName.modifyReason.text);
        });
      }));
    return formData;
  }
}
