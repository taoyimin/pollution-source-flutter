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
}
