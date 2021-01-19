import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/inspection/routine/detail/routine_inspection_detail_model.dart';

class RoutineInspectionDetailRepository
    extends DetailRepository<List<RoutineInspectionDetail>> {
  @override
  HttpApi createApi() {
    return HttpApi.routineInspectionDetail;
  }

  @override
  fromJson(jsonArray) {
    return jsonArray.map<RoutineInspectionDetail>((json) {
      return RoutineInspectionDetail.fromJson(json);
    }).toList();
  }

  /// [state]状态 0：全部 1：待巡检 2：未巡检 3：已巡检
  static Map<String, dynamic> createParams({
    monitorId = '',
    state = '',
  }) {
    return {
      'monitorId': monitorId,
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
