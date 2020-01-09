import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/inspection/routine/list/routine_inspection_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class RoutineInspectionListRepository extends ListRepository<RoutineInspection> {
  @override
  HttpApi createApi() {
    return HttpApi.routineInspectionList;
  }

  @override
  RoutineInspection fromJson(json) {
    return RoutineInspection.fromJson(json);
  }

  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterId = '',
    monitorId = '',
    state = '',
  }) {
      return {
        'start': (currentPage - 1) * pageSize,
        'length': pageSize,
        'query.eq.enterId': enterId,
        'query.eq.monitorId': monitorId,
        'query.eq.inspectionStatus': state,
      };
  }
}
