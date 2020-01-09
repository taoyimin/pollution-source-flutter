import 'package:meta/meta.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';

class RoutineInspectionUploadListRepository
    extends ListRepository<RoutineInspectionUploadList> {

  @override
  HttpApi createApi() {
    return HttpApi.routineInspectionUploadList;
  }

  @override
  RoutineInspectionUploadList fromJson(json) {
    return RoutineInspectionUploadList.fromJson(json);
  }

  static Map<String, dynamic> createParams({
    @required monitorId,
    @required itemInspectType,
  }) {
    return {
      'monitorId': monitorId,
      'itemInspectType': itemInspectType,
    };
  }
}
