import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/inspection/correct/air/upload/air_device_correct_upload_model.dart';

/// 废气监测设备校准存储库
class AirDeviceCorrectUploadRepository
    extends UploadRepository<AirDeviceCorrectUpload, String> {
  @override
  checkData(AirDeviceCorrectUpload data) {
    if (data.factor == null)
      throw DioError(error: InvalidParamException('请先加载校验因子'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.deviceCorrectUpload;
  }

  @override
  Future<FormData> createFormData(AirDeviceCorrectUpload data) async {
    return FormData.fromMap({
      'inspectionTaskId': int.parse(data.inspectionTaskId),
      'factorId': data.factor.factorId,
      'factorCode': data.factor.factorCode,
      'factorName': data.factor.factorName,
      'correctStartTime': data.correctStartTime.toString(),
      'correctEndTime': data.correctEndTime.toString(),
      'zeroVal': data.zeroVal,
      'beforeZeroVal': data.beforeZeroVal,
      'correctZeroVal': data.correctZeroVal,
      'zeroPercent': data.zeroPercent,
      'zeroIsNormal': data.zeroIsNormal ? '正常' : '不正常',
      'zeroCorrectVal': data.zeroCorrectVal,
      'rangeVal': data.rangeVal,
      'beforeRangeVal': data.beforeRangeVal,
      'correctRangeVal': data.correctRangeVal,
      'rangePercent': data.rangePercent,
      'rangeIsNormal': data.rangeIsNormal ? '正常' : '不正常',
      'rangeCorrectVal': data.rangeCorrectVal,
    });
  }
}
