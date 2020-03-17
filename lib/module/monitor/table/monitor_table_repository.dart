import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/error_handle.dart';
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
    String dataType,
    DateTime startTime,
    DateTime endTime,
  }) {
    if (startTime == null) {
      throw DioError(error: InvalidParamException('开始时间不能为空'));
    }
    if (endTime == null) {
      throw DioError(error: InvalidParamException('结束时间不能为空'));
    }
    Duration duration = endTime.difference(startTime);
    if (duration.inMilliseconds < 0) {
      throw DioError(error: InvalidParamException('开始时间不能大于结束时间'));
    }
    switch (dataType) {
      case 'minute':
        if (duration.inDays > 0) {
          throw DioError(error: InvalidParamException('实时数据不能跨天查询'));
        }
        break;
      case 'tenminute':
        if (duration.inDays > 0) {
          throw DioError(error: InvalidParamException('十分钟数据不能跨天查询'));
        }
        break;
      case 'hour':
        if (startTime.year != endTime.year ||
            startTime.month != endTime.month) {
          throw DioError(error: InvalidParamException('小时数据不能跨月查询'));
        }
        break;
      case 'day':
        break;
      default:
        throw DioError(
            error: InvalidParamException('未知的DataType类型，DataType=$dataType'));
        break;
    }
    return {
      'monitorId': monitorId,
      'dataType': dataType,
      'startTime':
          DateUtil.getDateStrByDateTime(startTime, format: DateFormat.NORMAL) ??
              '',
      'endTime':
          DateUtil.getDateStrByDateTime(endTime, format: DateFormat.NORMAL) ??
              '',
    };
  }
}
