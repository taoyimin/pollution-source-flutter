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

  /// [state]状态 0：全部 1：待巡检 2：未巡检 3：已巡检
  static Map<String, dynamic> createParams({
    @required monitorId,
    @required itemInspectType,
    state = '',
  }) {
    return {
      'monitorId': monitorId,
      'itemInspectType': itemInspectType,
      'inspectionStatus': () {
        switch (state) {
          case '1':
            return '10';
          case '2':
            return '21';
          case '3':
            return '20';
          default:
            return '';
        }
      }(),
    };
  }
}
