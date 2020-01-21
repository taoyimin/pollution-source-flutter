import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/inspection/routine/list/routine_inspection_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class RoutineInspectionListRepository
    extends ListRepository<RoutineInspection> {
  @override
  HttpApi createApi() {
    return HttpApi.routineInspectionList;
  }

  @override
  RoutineInspection fromJson(json) {
    return RoutineInspection.fromJson(json);
  }

  /// [state]状态 0：全部 1：当前待处理 2：超时待处理
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
      'query.eq.inspectionStatus': () {
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
