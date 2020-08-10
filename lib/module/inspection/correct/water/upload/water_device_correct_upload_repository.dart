import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/util/common_utils.dart';

import 'water_device_correct_upload_model.dart';

class WaterDeviceCorrectUploadRepository
    extends UploadRepository<WaterDeviceCorrectUpload, String> {
  @override
  checkData(WaterDeviceCorrectUpload data) {
    if (data.baiduLocation == null)
      throw DioError(error: InvalidParamException('请先获取位置信息'));
    if (TextUtil.isEmpty(data.factorUnit.text))
      throw DioError(error: InvalidParamException('请输入测量单位'));
    if (data.waterDeviceCorrectRecordList.length == 0)
      throw DioError(error: InvalidParamException('请至少上传一条记录'));
    for (int i = 0; i < data.waterDeviceCorrectRecordList.length; i++) {
      if (data.waterDeviceCorrectRecordList[i].currentCheckTime == null)
        throw DioError(error: InvalidParamException('请选择第${i + 1}条记录的核查时间'));
      if (TextUtil.isEmpty(
          data.waterDeviceCorrectRecordList[i].standardSolution.text))
        throw DioError(error: InvalidParamException('请输入第${i + 1}条记录的标液浓度'));
      if (!CommonUtils.isNumeric(
          data.waterDeviceCorrectRecordList[i].standardSolution.text))
        throw DioError(error: InvalidParamException('第${i + 1}条记录的标液浓度不是合法数值'));
      if (TextUtil.isEmpty(
          data.waterDeviceCorrectRecordList[i].realitySolution.text))
        throw DioError(error: InvalidParamException('请输入第${i + 1}条记录的实测浓度'));
      if (!CommonUtils.isNumeric(
          data.waterDeviceCorrectRecordList[i].realitySolution.text))
        throw DioError(error: InvalidParamException('第${i + 1}条记录的实测浓度不是合法数值'));
      if (TextUtil.isEmpty(
          data.waterDeviceCorrectRecordList[i].currentCheckResult.text))
        throw DioError(error: InvalidParamException('请输入第${i + 1}条记录的核查结果'));
      if (data.waterDeviceCorrectRecordList[i].currentCorrectTime == null)
        throw DioError(error: InvalidParamException('请选择第${i + 1}条记录的校准时间'));
    }
  }

  @override
  HttpApi createApi() {
    return HttpApi.waterDeviceCorrectUpload;
  }

  @override
  Future<FormData> createFormData(WaterDeviceCorrectUpload data) async {
    FormData formData = FormData();
    formData.fields
      ..addAll([MapEntry('latitude', data.baiduLocation.latitude.toString())])
      ..addAll([MapEntry('longitude', data.baiduLocation.longitude.toString())])
      ..addAll([MapEntry('address', data.baiduLocation.locationDetail)])
      ..addAll(data.waterDeviceCorrectRecordList.map((item) {
        return MapEntry('inspectionTaskId', item.inspectionTaskId);
      }))
      ..addAll(data.waterDeviceCorrectRecordList.map((item) {
        return MapEntry('itemType', item.itemType);
      }))
      ..addAll(data.waterDeviceCorrectRecordList.map((item) {
        return MapEntry('factorUnit', data.factorUnit.text);
      }))
      ..addAll(data.waterDeviceCorrectRecordList.map((item) {
        return MapEntry(
            'currentCheckTime', DateUtil.formatDate(item.currentCheckTime));
      }))
      ..addAll(data.waterDeviceCorrectRecordList.map((item) {
        return MapEntry('standardSolution', item.standardSolution.text);
      }))
      ..addAll(data.waterDeviceCorrectRecordList.map((item) {
        return MapEntry('realitySolution', item.realitySolution.text);
      }))
      ..addAll(data.waterDeviceCorrectRecordList.map((item) {
        return MapEntry('currentCheckResult', item.currentCheckResult.text);
      }))
      ..addAll(data.waterDeviceCorrectRecordList.map((item) {
        return MapEntry(
            'currentCheckIsPass', item.currentCheckIsPass ? '合格' : '不合格');
      }))
      ..addAll(data.waterDeviceCorrectRecordList.map((item) {
        return MapEntry(
            'currentCorrectTime', DateUtil.formatDate(item.currentCorrectTime));
      }))
      ..addAll(data.waterDeviceCorrectRecordList.map((item) {
        return MapEntry(
            'currentCorrectIsPass', item.currentCorrectIsPass ? '通过' : '不通过');
      }));
    return formData;
  }
}
