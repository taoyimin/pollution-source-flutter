import 'dart:async';
import 'dart:typed_data';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/process/upload/process_upload_model.dart';

class ProcessUploadRepository extends UploadRepository<ProcessUpload, String> {
  @override
  checkData(ProcessUpload data) {
    if (data.orderId == null)
      throw DioError(error: InvalidParamException('报警管理单Id为空'));
    if (TextUtil.isEmpty(data.alarmState))
      throw DioError(error: InvalidParamException('报警管理单状态为空'));
    if (TextUtil.isEmpty(data.operatePerson))
      throw DioError(error: InvalidParamException('请输入反馈人'));
    if (TextUtil.isEmpty(data.operateType))
      throw DioError(error: InvalidParamException('操作类型为空'));
    if (data.alarmCauseList == null || data.alarmCauseList.length == 0)
      throw DioError(error: InvalidParamException('请选择报警原因'));
    if (TextUtil.isEmpty(data.operateDesc))
      throw DioError(error: InvalidParamException('请输入操作描述'));
    if (data.operateType == '-1' && (data.attachments == null || data.attachments.length == 0))
      // 处理督办单必须上传附件
      throw DioError(error: InvalidParamException('请选择附件上传'));
  }

  @override
  HttpApi createApi() {
    return HttpApi.processesUpload;
  }

  @override
  Future<FormData> createFormData(ProcessUpload data) async {
    return FormData.fromMap({
      'id': data.orderId.toString(),
      'alarmState': data.alarmState,
      'operatePerson': data.operatePerson,
      'audit': data.operateType,
      'alarmCause': data.alarmCauseList?.map((dataDict) => dataDict.code)?.join(',') ?? '',
      'checkId': data.mobileLawList?.map((mobileLaw) => mobileLaw.id)?.join(',') ?? '',
      'operateDesc': data.operateDesc,
      "file": await Future.wait(data.attachments?.map((asset) async {
        ByteData byteData = await asset.getByteData();
        return MultipartFile.fromBytes(byteData.buffer.asUint8List(),
            filename: asset.name);
      })?.toList() ??
          [])
    });
  }
}