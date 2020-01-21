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

  /// [state]状态 0：全部 1：当前待处理 2：超时待处理
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
          default:
            return '';
        }
      }(),
    };
  }
}
