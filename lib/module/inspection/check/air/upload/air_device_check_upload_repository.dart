import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/inspection/check/air/upload/air_device_check_upload_model.dart';
import 'package:pollution_source/module/inspection/check/water/upload/water_device_check_upload_model.dart';

class AirDeviceUploadRepository
    extends UploadRepository<AirDeviceCheckUpload, String> {
  @override
  checkData(AirDeviceCheckUpload data) {
    if (data.airDeviceCheckRecordList.length < 5)
      throw DioError(error: InvalidParamException('请至少上传五条记录'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.deviceCheckUpload;
  }

  @override
  Future<FormData> createFormData(AirDeviceCheckUpload data) async {
    var formData = FormData.fromMap({
      'inspectionTaskId': int.parse(data.inspectionTaskId),
      'itemType': data.itemType,
      'factorId': int.parse(data.factorId),
      'factorCode': data.factorCode,
      'factorName': data.factorName,
      'compareUnit': data.compareUnit,
      'cemsUnit': data.cemsUnit,
      'compareAvgVal': data.compareAvgVal,
      'cemsAvgVal': data.cemsAvgVal,
      'inspectionTaskInsideId': data.airDeviceCheckRecordList.map((item) {
        return int.parse(data.inspectionTaskId);
      }).toList().join(','),
      'factorInsideId': data.airDeviceCheckRecordList.map((item) {
        return int.parse(data.factorId);
      }).toList().join(','),
      'currentCheckTime': data.airDeviceCheckRecordList.map((item) {
        return item.currentCheckTime.toString();
      }).toList().join(','),
      'currentCheckResult': data.airDeviceCheckRecordList.map((item) {
        return item.currentCheckResult;
      }).toList().join(','),
      'currentCheckIsPass': data.airDeviceCheckRecordList.map((item) {
        return item.currentCheckIsPass;
      }).toList().join(','),
      'paramRemark': data.paramRemark,
      'changeRemark': data.changeRemark,
      'checkResult': data.checkResult,
    });
    print(formData.fields);
    throw DioError(error: InvalidParamException('测试'));
    return formData;
  }
}
