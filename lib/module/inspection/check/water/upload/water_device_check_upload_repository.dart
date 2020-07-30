import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/inspection/check/water/upload/water_device_check_upload_model.dart';
import 'package:pollution_source/util/common_utils.dart';

class WaterDeviceUploadRepository
    extends UploadRepository<WaterDeviceCheckUpload, String> {
  @override
  checkData(WaterDeviceCheckUpload data) {
    if (data.baiduLocation == null)
      throw DioError(error: InvalidParamException('请先获取位置信息'));
    if (TextUtil.isEmpty(data.measuredResult.text))
      throw DioError(error: InvalidParamException('请输入在线监测仪器测定结果'));
    if (TextUtil.isEmpty(data.factorUnit.text))
      throw DioError(error: InvalidParamException('请输入测定结果单位'));
    if (data.comparisonMeasuredResultList.length == 0)
      throw DioError(error: InvalidParamException('请至少上传一条比对方法测定结果'));
    for (int i = 0; i < data.comparisonMeasuredResultList.length; i++) {
      if (TextUtil.isEmpty(data.comparisonMeasuredResultList[i].text))
        throw DioError(error: InvalidParamException('请输入测定结果${i + 1}'));
      if (!CommonUtils.isNumeric(data.comparisonMeasuredResultList[i].text))
        throw DioError(error: InvalidParamException('测定结果${i + 1}不是合法数值'));
    }
    if (TextUtil.isEmpty(data.measuredDisparity.text))
      throw DioError(error: InvalidParamException('请输入测定误差'));
    if (data.currentCheckTime == null)
      throw DioError(error: InvalidParamException('请选择校验时间'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.waterDeviceCheckUpload;
  }

  @override
  Future<FormData> createFormData(WaterDeviceCheckUpload data) async {
    FormData formData = FormData();
    formData.fields
      ..addAll([MapEntry('latitude', data.baiduLocation.latitude.toString())])
      ..addAll([MapEntry('longitude', data.baiduLocation.longitude.toString())])
      ..addAll([MapEntry('address', data.baiduLocation.locationDetail)])
      ..addAll([MapEntry('inspectionTaskId', data.inspectionTaskId)])
      ..addAll([MapEntry('itemType', data.itemType)])
      ..addAll([MapEntry('factorCode', data.factorCode)])
      ..addAll([MapEntry('factorName', data.factorName)])
      ..addAll([MapEntry('measuredResult', data.measuredResult.text)])
      ..addAll([MapEntry('unit', data.factorUnit.text)])
      ..addAll(data.comparisonMeasuredResultList.map((item) {
        return MapEntry('inspectionTaskInsideId', data.inspectionTaskId);
      }))
      ..addAll(data.comparisonMeasuredResultList.map((item) {
        return MapEntry('comparisonMeasuredResult', item.text);
      }))
      ..addAll([MapEntry('comparisonMeasuredAvg', data.comparisonMeasuredAvg)])
      ..addAll([MapEntry('measuredDisparity', data.measuredDisparity.text)])
      ..addAll([
        MapEntry('currentCheckTime', DateUtil.formatDate(data.currentCheckTime))
      ])
      ..addAll([MapEntry('isQualified', data.isQualified ? '合格' : '不合格')]);
    return formData;
  }
}
