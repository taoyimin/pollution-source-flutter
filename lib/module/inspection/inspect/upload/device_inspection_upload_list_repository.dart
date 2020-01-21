import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/inspection/inspect/upload/device_inspect_upload_model.dart';

class DeviceInspectionUploadRepository
    extends UploadRepository<DeviceInspectUpload, String> {
  @override
  checkData(DeviceInspectUpload data) {
    if (data.selectedList.length == 0)
      throw DioError(error: InvalidParamException('至少选择一项任务进行处理'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.deviceInspectionUpload;
  }

  @override
  Future<FormData> createFormData(
      DeviceInspectUpload deviceInspectUpload) async {
    FormData formData = FormData();
    formData.fields
      ..addAll(deviceInspectUpload.selectedList.map((item) {
        return MapEntry('inspectionTaskId', item.inspectionTaskId);
      }))
      ..addAll(deviceInspectUpload.selectedList.map((item) {
        return MapEntry(
            'inspectionRemark', deviceInspectUpload.isNormal ? '正常' : '不正常');
      }))
      ..addAll(deviceInspectUpload.selectedList.map((item) {
        return MapEntry('remark', deviceInspectUpload.remark);
      }));
    return formData;
  }
}