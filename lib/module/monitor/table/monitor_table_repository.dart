import 'package:common_utils/common_utils.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/monitor/table/monitor_table_model.dart';

class MonitorHistoryDataRepository extends DetailRepository<MonitorTable> {
  @override
  HttpApi createApi() {
    return HttpApi.monitorHistoryData;
  }

  @override
  MonitorTable fromJson(json) {
    return MonitorTable.fromJson(json);
  }

  static Map<String, dynamic> createParams({
    String monitorId = '',
    String dataType = '',
    DateTime startTime,
    DateTime endTime,
  }) {
    return {
      'monitorId': monitorId,
      'dataType': dataType,
      'startTime': DateUtil.getDateStrByDateTime(startTime, format: DateFormat.YEAR_MONTH_DAY) ?? '',
      'endTime': DateUtil.getDateStrByDateTime(endTime, format: DateFormat.YEAR_MONTH_DAY) ?? '',
    };
  }
}
