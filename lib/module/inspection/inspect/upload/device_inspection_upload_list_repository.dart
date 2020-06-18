import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/inspection/inspect/upload/device_inspect_upload_model.dart';

class DeviceInspectionUploadRepository
    extends UploadRepository<DeviceInspectUpload, String> {
  @override
  checkData(DeviceInspectUpload data) {
    if (data.baiduLocation == null)
      throw DioError(error: InvalidParamException('请先获取位置信息'));
    if (data.selectedList.length == 0)
      throw DioError(error: InvalidParamException('至少选择一项任务进行处理'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.deviceInspectionUpload;
  }

  @override
  Future<FormData> createFormData(DeviceInspectUpload data) async {
    FormData formData = FormData();
    formData.fields
      ..addAll([MapEntry('latitude', data.baiduLocation.latitude.toString())])
      ..addAll([MapEntry('longitude', data.baiduLocation.longitude.toString())])
      ..addAll([MapEntry('address', data.baiduLocation.locationDetail)])
      ..addAll(data.selectedList.map((item) {
        return MapEntry('inspectionTaskId', item.inspectionTaskId);
      }))
      ..addAll(data.selectedList.map((item) {
        return MapEntry('inspectionRemark', data.isNormal ? '正常' : '不正常');
      }))
      // 如果参数为空，默认用一个空格，防止空字符参数被过滤掉
      ..addAll(data.selectedList.map((item) {
        return MapEntry('remark',
            TextUtil.isEmpty(data.remark.text) ? ' ' : data.remark.text);
      }));
    return formData;
  }
}
