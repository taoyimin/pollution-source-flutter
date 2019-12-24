import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/process/upload/process_upload_model.dart';

class ProcessUploadRepository extends UploadRepository<ProcessUpload, String> {
  @override
  checkData(ProcessUpload data) {
    if (data.orderId.isEmpty)
      throw DioError(error: InvalidParamException('报警管理单Id为空'));
    if (data.operatePerson.isEmpty)
      throw DioError(error: InvalidParamException('请输入操作人'));
    if (data.operateType.isEmpty)
      throw DioError(error: InvalidParamException('操作类型为空'));
    if (data.operateDesc.isEmpty)
      throw DioError(error: InvalidParamException('请输入操作描述'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.processesUpload;
  }

  @override
  Future<FormData> createFormData(ProcessUpload data) async {
    return FormData.fromMap({
      'id': data.orderId,
      'operatePerson': data.operatePerson,
      'operateType': data.operateType,
      'operateDesc': data.operateDesc,
      "file": await Future.wait(data.attachments?.map((asset) async {
            return await MultipartFile.fromFile(await asset.filePath,
                filename: asset.name);
          })?.toList() ??
          [])
    });
  }
}
