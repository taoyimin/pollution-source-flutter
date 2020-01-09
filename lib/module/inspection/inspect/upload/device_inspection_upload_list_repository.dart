import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';
import 'package:pollution_source/module/report/longstop/upload/long_stop_report_upload_model.dart';

class DeviceInspectionUploadRepository
    extends UploadRepository<RoutineInspectionUploadList, String> {
  @override
  checkData(RoutineInspectionUploadList data) {
  }

  @override
  HttpApi createApi() {
    return HttpApi.deviceInspectionUpload;
  }

  @override
  Future<FormData> createFormData(RoutineInspectionUploadList data) async {
    return FormData.fromMap({
      'inspectionTaskId': data.inspectionTaskId,
      'inspectionRemark': data.inspectionRemark,
      'remark': data.remark,
    });
  }
}
