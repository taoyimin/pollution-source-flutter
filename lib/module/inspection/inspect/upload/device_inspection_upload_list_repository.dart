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
    return FormData.fromMap({
      'inspectionTaskId': deviceInspectUpload.selectedList
          .map((item) {
            return item.inspectionTaskId;
          })
          .toList()
          .join(','),
      'inspectionRemark': deviceInspectUpload.selectedList
          .map((item) {
            return deviceInspectUpload.isNormal ? '正常' : '不正常';
          })
          .toList()
          .join(','),
      'remark': deviceInspectUpload.selectedList
          .map((item) {
            return deviceInspectUpload.remark;
          })
          .toList()
          .join(','),
    });
  }
}
