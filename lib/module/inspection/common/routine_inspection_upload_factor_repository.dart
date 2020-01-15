import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_factor_model.dart';

class RoutineInspectionUploadFactorRepository
    extends DetailRepository<RoutineInspectionUploadFactor> {
  @override
  HttpApi createApi() {
    return HttpApi.routineInspectionFactorDetail;
  }

  @override
  RoutineInspectionUploadFactor fromJson(json) {
    // 查出来是数组，默认取第一个
    return RoutineInspectionUploadFactor.fromJson(json[0]);
  }

  static Map<String, dynamic> createParams({
    monitorId = '',
    factorCode = '',
    deviceId = '',
  }) {
    return {
      'monitorId': monitorId,
      'factorCode': factorCode,
      'deviceId': deviceId,
    };
  }
}
