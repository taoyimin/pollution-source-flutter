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
    if (data.factor == null)
      throw DioError(error: InvalidParamException('请先加载校验因子'));
    if (data.correctStartTime == null)
      throw DioError(error: InvalidParamException('请先选择校准开始时间'));
    if (data.correctEndTime == null)
      throw DioError(error: InvalidParamException('请先选择校准结束时间'));
    if (TextUtil.isEmpty(data.zeroVal))
      throw DioError(error: InvalidParamException('请先输入零气浓度值(零点漂移校准)'));
    if (TextUtil.isEmpty(data.beforeZeroVal))
      throw DioError(error: InvalidParamException('请先输入上次校准后测试值(零点漂移校准)'));
    if (TextUtil.isEmpty(data.correctZeroVal))
      throw DioError(error: InvalidParamException('请先输入上次校前测试值(零点漂移校准)'));
    if (TextUtil.isEmpty(data.zeroPercent))
      throw DioError(error: InvalidParamException('请先输入零点漂移 %F.S.(零点漂移校准)'));
    if (TextUtil.isEmpty(data.zeroCorrectVal))
      throw DioError(error: InvalidParamException('请先输入校准后测试值(零点漂移校准)'));
    if (TextUtil.isEmpty(data.rangeVal))
      throw DioError(error: InvalidParamException('请先输入标气浓度值(量程漂移校准)'));
    if (TextUtil.isEmpty(data.beforeRangeVal))
      throw DioError(error: InvalidParamException('请先输入上次校准后测试值(量程漂移校准)'));
    if (TextUtil.isEmpty(data.correctRangeVal))
      throw DioError(error: InvalidParamException('请先输入校前测试值(量程漂移校准)'));
    if (TextUtil.isEmpty(data.rangePercent))
      throw DioError(error: InvalidParamException('请先输入量程漂移 %F.S.(量程漂移校准)'));
    if (TextUtil.isEmpty(data.rangeCorrectVal))
      throw DioError(error: InvalidParamException('请先输入校准后测试值(量程漂移校准)'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.deviceCorrectUpload;
  }

  @override
  Future<FormData> createFormData(AirDeviceCorrectUpload data) async {
    FormData formData = FormData();
    formData.fields
      ..addAll([MapEntry('inspectionTaskId', data.inspectionTaskId)])
      ..addAll([MapEntry('factorId', data.factor.factorId.toString())])
      // 如果参数为空，默认用一个空格，防止空字符参数被过滤掉
      ..addAll([
        MapEntry(
            'factorCode',
            TextUtil.isEmpty(data.factor.factorCode)
                ? ' '
                : data.factor.factorCode)
      ])
      ..addAll([MapEntry('factorName', data.factor.factorName)])
      ..addAll([
        MapEntry('correctStartTime',
            DateUtil.getDateStrByDateTime(data.correctStartTime))
      ])
      ..addAll([
        MapEntry('correctEndTime',
            DateUtil.getDateStrByDateTime(data.correctStartTime))
      ])
      ..addAll([MapEntry('zeroVal', data.zeroVal)])
      ..addAll([MapEntry('beforeZeroVal', data.beforeZeroVal)])
      ..addAll([MapEntry('correctZeroVal', data.correctZeroVal)])
      ..addAll([MapEntry('zeroPercent', data.zeroPercent)])
      ..addAll([MapEntry('zeroIsNormal', data.zeroIsNormal ? '正常' : '不正常')])
      ..addAll([MapEntry('zeroCorrectVal', data.zeroCorrectVal)])
      ..addAll([MapEntry('rangeVal', data.rangeVal)])
      ..addAll([MapEntry('beforeRangeVal', data.beforeRangeVal)])
      ..addAll([MapEntry('correctRangeVal', data.correctRangeVal)])
      ..addAll([MapEntry('rangePercent', data.rangePercent)])
      ..addAll([MapEntry('rangeIsNormal', data.rangeIsNormal ? '正常' : '不正常')])
      ..addAll([MapEntry('rangeCorrectVal', data.rangeCorrectVal)]);
    return formData;
  }
}
