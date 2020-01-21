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

  /// [state]状态 0：全部 1：当前待处理 2：超时待处理
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
            return '11';
          default:
            return '';
        }
      }(),
    };
  }
}
