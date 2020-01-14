import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/inspection/check/water/upload/water_device_check_upload_model.dart';

class WaterDeviceUploadRepository
    extends UploadRepository<List<WaterDeviceCheckUpload>, String> {
  @override
  checkData(List<WaterDeviceCheckUpload> data) {
    if (data.length == 0)
      throw DioError(error: InvalidParamException('请至少上传一条记录'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.deviceCheckUpload;
  }

  @override
  Future<FormData> createFormData(List<WaterDeviceCheckUpload> data) async {
    return FormData.fromMap({
      'inspectionTaskId': data
          .map((item) {
            return int.parse(item.inspectionTaskId);
          })
          .toList()
          .join(','),
      'itemType': data
          .map((item) {
            return item.itemType;
          })
          .toList()
          .join(','),
      'currentCheckTime': data
          .map((item) {
            return item.currentCheckTime.toString();
          })
          .toList()
          .join(','),
      'currentCheckIsPass': data
          .map((item) {
            return item.currentCheckIsPass ? '合格' : '不合格';
          })
          .toList()
          .join(','),
      'currentCheckResult': data
          .map((item) {
            return item.currentCheckResult;
          })
          .toList()
          .join(','),
      'currentCorrectTime': data
          .map((item) {
            return item.currentCorrectTime.toString();
          })
          .toList()
          .join(','),
      'currentCorrectIsPass': data
          .map((item) {
            return item.currentCorrectIsPass ? '通过' : '不通过';
          })
          .toList()
          .join(','),
    });
  }
}
