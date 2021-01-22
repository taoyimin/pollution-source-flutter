import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/inspection/check/air/upload/air_device_check_upload_model.dart';
import 'package:pollution_source/util/common_utils.dart';

class AirDeviceCheckUploadRepository
    extends UploadRepository<AirDeviceCheckUpload, String> {
  @override
  checkData(AirDeviceCheckUpload data) {
    if (data.baiduLocation == null || data.baiduLocation.latitude == null || data.baiduLocation.longitude == null)
      throw DioError(error: InvalidParamException('请先获取位置信息'));
    else if (data.airDeviceCheckRecordList.length < 5)
      throw DioError(error: InvalidParamException('请至少上传五条记录'));
    for (int i = 0; i < data.airDeviceCheckRecordList.length; i++) {
      if (data.airDeviceCheckRecordList[i].currentCheckTime == null)
        throw DioError(error: InvalidParamException('请选择第${i + 1}条记录的监测时间'));
      if (TextUtil.isEmpty(
          data.airDeviceCheckRecordList[i].currentCheckResult.text))
        throw DioError(error: InvalidParamException('请输入第${i + 1}条记录的参比方法测量值'));
      if (!CommonUtils.isNumeric(
          data.airDeviceCheckRecordList[i].currentCheckResult.text))
        throw DioError(
            error: InvalidParamException('第${i + 1}条记录的参比方法测量值不是合法数值'));
      if (TextUtil.isEmpty(
          data.airDeviceCheckRecordList[i].currentCheckIsPass.text))
        throw DioError(error: InvalidParamException('请输入第${i + 1}条记录的CEMS测量值'));
      if (!CommonUtils.isNumeric(
          data.airDeviceCheckRecordList[i].currentCheckIsPass.text))
        throw DioError(
            error: InvalidParamException('第${i + 1}条记录的CEMS测量值不是合法数值'));
    }
  }

  @override
  HttpApi createApi() {
    return HttpApi.airDeviceCheckUpload;
  }

  @override
  Future<FormData> createFormData(AirDeviceCheckUpload data) async {
    FormData formData = FormData();
    formData.fields
      ..addAll([MapEntry('latitude', data.baiduLocation.latitude.toString())])
      ..addAll([MapEntry('longitude', data.baiduLocation.longitude.toString())])
      ..addAll([MapEntry('address', data.baiduLocation.locationDetail??'无')])
      ..addAll([MapEntry('inspectionTaskId', data.inspectionTaskId)])
      ..addAll([MapEntry('itemType', data.itemType)])
      ..addAll([MapEntry('factorCode', data.factorCode)])
      ..addAll([MapEntry('factorName', data.factorName)])
      ..addAll([MapEntry('factorUnit', data.factorUnit)])
      ..addAll([MapEntry('compareUnit', data.factorUnit)])
      ..addAll([MapEntry('cemsUnit', data.factorUnit)])
      ..addAll([MapEntry('compareAvgVal', data.compareAvgVal)])
      ..addAll([MapEntry('cemsAvgVal', data.cemsAvgVal)])
      ..addAll(data.airDeviceCheckRecordList.map((item) {
        return MapEntry('inspectionTaskInsideId', data.inspectionTaskId);
      }))
      ..addAll(data.airDeviceCheckRecordList.map((item) {
        return MapEntry(
            'currentCheckTime', DateUtil.formatDate(item.currentCheckTime));
      }))
      ..addAll(data.airDeviceCheckRecordList.map((item) {
        return MapEntry('currentCheckResult', item.currentCheckResult.text);
      }))
      ..addAll(data.airDeviceCheckRecordList.map((item) {
        return MapEntry('currentCheckIsPass', item.currentCheckIsPass.text);
      }))
      ..addAll([MapEntry('paramRemark', data.paramRemark.text)])
      ..addAll([MapEntry('changeRemark', data.changeRemark.text)])
      ..addAll([MapEntry('checkResult', data.checkResult.text)]);
    return formData;
  }
}
