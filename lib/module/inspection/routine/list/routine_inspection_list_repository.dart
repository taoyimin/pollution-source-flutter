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

  /// [enterName]根据企业名称筛选
  /// [state]状态 1：待巡检 2：未巡检 3：已巡检
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    enterId = '',
    monitorId = '',
    state = '',
  }) {
    return {
      'start': (currentPage - 1) * pageSize,
      'length': pageSize,
      'query.like.e.enterpriseName': enterName,
      'query.eq.enterId': enterId,
      'query.eq.monitorId': monitorId,
      'inspectionStatus': () {
        switch (state) {
          case '1':
            return '10';
          case '2':
            return '11';
          case '3':
            return '20';
          default:
            return '';
        }
      }(),
    };
  }
}
