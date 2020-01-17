import 'package:common_utils/common_utils.dart';
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
    for (int i = 0; i < data.length; i++) {
      if (data[i].currentCheckTime == null)
        throw DioError(error: InvalidParamException('请选择第${i + 1}条记录的核查时间'));
      if (TextUtil.isEmpty(data[i].currentCheckResult))
        throw DioError(error: InvalidParamException('请输入第${i + 1}条记录的核查结果'));
      if (data[i].currentCorrectTime == null)
        throw DioError(error: InvalidParamException('请选择第${i + 1}条记录的校准时间'));
    }
  }

  @override
  HttpApi createApi() {
    return HttpApi.deviceCheckUpload;
  }

  @override
  Future<FormData> createFormData(List<WaterDeviceCheckUpload> data) async {
    FormData formData = FormData();
    formData.fields
      ..addAll(data.map((item) {
        return MapEntry('inspectionTaskId', item.inspectionTaskId);
      }))
      ..addAll(data.map((item) {
        return MapEntry('itemType', item.itemType);
      }))
      ..addAll(data.map((item) {
        return MapEntry('currentCheckTime', DateUtil.getDateStrByDateTime(item.currentCheckTime) ?? '');
      }))
      ..addAll(data.map((item) {
        return MapEntry(
            'currentCheckIsPass', item.currentCheckIsPass ? '合格' : '不合格');
      }))
      ..addAll(data.map((item) {
        return MapEntry('currentCheckResult', item.currentCheckResult);
      }))
      ..addAll(data.map((item) {
        return MapEntry('currentCorrectTime', DateUtil.getDateStrByDateTime(item.currentCorrectTime) ?? '');
      }))
      ..addAll(data.map((item) {
        return MapEntry('currentCorrectIsPass', item.currentCorrectIsPass ? '通过' : '不通过');
      }));
    return formData;
  }
}
