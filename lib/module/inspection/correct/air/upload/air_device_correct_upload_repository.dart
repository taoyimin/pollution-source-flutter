import 'package:common_utils/common_utils.dart';
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
    if (data.baiduLocation == null)
      throw DioError(error: InvalidParamException('请先获取位置信息'));
    if (TextUtil.isEmpty(data.unit))
      throw DioError(error: InvalidParamException('请先输入计量单位'));
    if (TextUtil.isEmpty(data.measureLower))
      throw DioError(error: InvalidParamException('请先输入分析仪量程下限'));
    if (TextUtil.isEmpty(data.measureUpper))
      throw DioError(error: InvalidParamException('请先输入分析仪量程上限'));
    if (data.correctStartTime == null)
      throw DioError(error: InvalidParamException('请先选择校准开始时间'));
    if (data.correctEndTime == null)
      throw DioError(error: InvalidParamException('请先选择校准结束时间'));
    if (TextUtil.isEmpty(data.zeroVal.text))
      throw DioError(error: InvalidParamException('请先输入零气浓度值(零点漂移校准)'));
    if (TextUtil.isEmpty(data.beforeZeroVal.text))
      throw DioError(error: InvalidParamException('请先输入上次校准后测试值(零点漂移校准)'));
    if (TextUtil.isEmpty(data.correctZeroVal.text))
      throw DioError(error: InvalidParamException('请先输入上次校前测试值(零点漂移校准)'));
    if (TextUtil.isEmpty(data.zeroPercent.text))
      throw DioError(error: InvalidParamException('请先输入零点漂移 %F.S.(零点漂移校准)'));
    if (TextUtil.isEmpty(data.zeroCorrectVal.text))
      throw DioError(error: InvalidParamException('请先输入校准后测试值(零点漂移校准)'));
    if (TextUtil.isEmpty(data.rangeVal.text))
      throw DioError(error: InvalidParamException('请先输入标气浓度值(量程漂移校准)'));
    if (TextUtil.isEmpty(data.beforeRangeVal.text))
      throw DioError(error: InvalidParamException('请先输入上次校准后测试值(量程漂移校准)'));
    if (TextUtil.isEmpty(data.correctRangeVal.text))
      throw DioError(error: InvalidParamException('请先输入校前测试值(量程漂移校准)'));
    if (TextUtil.isEmpty(data.rangePercent.text))
      throw DioError(error: InvalidParamException('请先输入量程漂移 %F.S.(量程漂移校准)'));
    if (TextUtil.isEmpty(data.rangeCorrectVal.text))
      throw DioError(error: InvalidParamException('请先输入校准后测试值(量程漂移校准)'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.airDeviceCorrectUpload;
  }

  @override
  Future<FormData> createFormData(AirDeviceCorrectUpload data) async {
    FormData formData = FormData();
    formData.fields
      ..addAll([MapEntry('latitude', data.baiduLocation.latitude.toString())])
      ..addAll([MapEntry('longitude', data.baiduLocation.longitude.toString())])
      ..addAll([MapEntry('address', data.baiduLocation.locationDetail)])
      ..addAll([MapEntry('inspectionTaskId', data.inspectionTaskId)])
      ..addAll([MapEntry('factorCode', data.factorCode)])
      ..addAll([MapEntry('factorName', data.factorName)])
      ..addAll([MapEntry('unit', data.unit)])
      ..addAll([MapEntry('measureLower', data.measureLower)])
      ..addAll([MapEntry('measureUpper', data.measureUpper)])
      ..addAll([
        MapEntry('correctStartTime', DateUtil.formatDate(data.correctStartTime))
      ])
      ..addAll([
        MapEntry('correctEndTime', DateUtil.formatDate(data.correctStartTime))
      ])
      ..addAll([MapEntry('zeroVal', data.zeroVal.text)])
      ..addAll([MapEntry('beforeZeroVal', data.beforeZeroVal.text)])
      ..addAll([MapEntry('correctZeroVal', data.correctZeroVal.text)])
      ..addAll([MapEntry('zeroPercent', data.zeroPercent.text)])
      ..addAll([MapEntry('zeroIsNormal', data.zeroIsNormal ? '正常' : '不正常')])
      ..addAll([MapEntry('zeroCorrectVal', data.zeroCorrectVal.text)])
      ..addAll([MapEntry('rangeVal', data.rangeVal.text)])
      ..addAll([MapEntry('beforeRangeVal', data.beforeRangeVal.text)])
      ..addAll([MapEntry('correctRangeVal', data.correctRangeVal.text)])
      ..addAll([MapEntry('rangePercent', data.rangePercent.text)])
      ..addAll([MapEntry('rangeIsNormal', data.rangeIsNormal ? '正常' : '不正常')])
      ..addAll([MapEntry('rangeCorrectVal', data.rangeCorrectVal.text)]);
    return formData;
  }
}
