import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/inspection/check/air/upload/air_device_check_upload_model.dart';

class AirDeviceCheckUploadRepository
    extends UploadRepository<AirDeviceCheckUpload, String> {
  @override
  checkData(AirDeviceCheckUpload data) {
    if (data.factor == null)
      throw DioError(error: InvalidParamException('请先加载校验因子'));
    else if (data.airDeviceCheckRecordList.length < 5)
      throw DioError(error: InvalidParamException('请至少上传五条记录'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.deviceCheckUpload;
  }

  @override
  Future<FormData> createFormData(AirDeviceCheckUpload data) async {
    return FormData.fromMap({
      'inspectionTaskId': int.parse(data.inspectionTaskId),
      'itemType': data.itemType,
      'factorId': data.factor.factorId,
      'factorCode': data.factor.factorCode,
      'factorName': data.factor.factorName,
      'compareUnit': data.factor.unit,
      'cemsUnit': data.factor.unit,
      'compareAvgVal': data.compareAvgVal,
      'cemsAvgVal': data.cemsAvgVal,
      'inspectionTaskInsideId': data.airDeviceCheckRecordList.map((item) {
        return int.parse(data.inspectionTaskId);
      }).toList().join(','),
      'factorInsideId': data.airDeviceCheckRecordList.map((item) {
        return data.factor.factorId;
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
  }
}
