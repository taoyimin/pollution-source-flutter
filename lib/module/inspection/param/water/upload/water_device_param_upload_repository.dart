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
    return FormData.fromMap({
      'inspectionTaskId': data.waterDeviceParamTypeList
          .map(
            (WaterDeviceParamType waterDeviceParamType) {
              return waterDeviceParamType.waterDeviceParamNameList
                  .map(
                    (WaterDeviceParamName waterDeviceParamName) {
                      return int.parse(data.inspectionTaskId);
                    },
                  )
                  .toList()
                  .join(',');
            },
          )
          .toList()
          .join(','),
      'parameterType': data.waterDeviceParamTypeList
          .map(
            (WaterDeviceParamType waterDeviceParamType) {
              return waterDeviceParamType.waterDeviceParamNameList
                  .map(
                    (WaterDeviceParamName waterDeviceParamName) {
                      return waterDeviceParamType.parameterType;
                    },
                  )
                  .toList()
                  .join(',');
            },
          )
          .toList()
          .join(','),
      'parameterName': data.waterDeviceParamTypeList
          .map(
            (WaterDeviceParamType waterDeviceParamType) {
              return waterDeviceParamType.waterDeviceParamNameList
                  .map(
                    (WaterDeviceParamName waterDeviceParamName) {
                      return waterDeviceParamName.parameterName;
                    },
                  )
                  .toList()
                  .join(',');
            },
          )
          .toList()
          .join(','),
      'originalVal': data.waterDeviceParamTypeList
          .map(
            (WaterDeviceParamType waterDeviceParamType) {
              return waterDeviceParamType.waterDeviceParamNameList
                  .map(
                    (WaterDeviceParamName waterDeviceParamName) {
                      return waterDeviceParamName.originalVal;
                    },
                  )
                  .toList()
                  .join(',');
            },
          )
          .toList()
          .join(','),
      'updateVal': data.waterDeviceParamTypeList
          .map(
            (WaterDeviceParamType waterDeviceParamType) {
              return waterDeviceParamType.waterDeviceParamNameList
                  .map(
                    (WaterDeviceParamName waterDeviceParamName) {
                      return waterDeviceParamName.updateVal;
                    },
                  )
                  .toList()
                  .join(',');
            },
          )
          .toList()
          .join(','),
      'modifyReason': data.waterDeviceParamTypeList
          .map(
            (WaterDeviceParamType waterDeviceParamType) {
              return waterDeviceParamType.waterDeviceParamNameList
                  .map(
                    (WaterDeviceParamName waterDeviceParamName) {
                      return waterDeviceParamName.modifyReason;
                    },
                  )
                  .toList()
                  .join(',');
            },
          )
          .toList()
          .join(','),
    });
  }
}
