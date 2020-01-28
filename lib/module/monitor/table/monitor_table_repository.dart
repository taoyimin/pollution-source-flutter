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
    DataType dataType,
    DateTime startTime,
    DateTime endTime,
  }) {
    DateTime nowDateTime = DateTime.now();
    if (startTime == null) {
      startTime = DateTime(
          nowDateTime.year, nowDateTime.month, nowDateTime.day, 0, 0, 0);
    }
    if (endTime == null) {
      endTime = DateTime(
          nowDateTime.year, nowDateTime.month, nowDateTime.day, 0, 0, 0);
    }
    Duration duration = endTime.difference(startTime);
    if (duration.inMilliseconds < 0) {
      throw DioError(error: InvalidParamException('开始时间不能大于结束时间'));
    }
    switch (dataType) {
      case DataType.minute:
        if (duration.inDays > 0) {
          throw DioError(error: InvalidParamException('实时数据不能跨天查询'));
        }
        break;
      case DataType.tenminute:
        if (duration.inDays > 0) {
          throw DioError(error: InvalidParamException('十分钟数据不能跨天查询'));
        }
        break;
      case DataType.hour:
        if (startTime.year != endTime.year ||
            startTime.month != endTime.month) {
          throw DioError(error: InvalidParamException('小时数据不能跨月查询'));
        }
        break;
      case DataType.day:
        break;
      default:
        throw DioError(
            error: InvalidParamException('未知的DataType类型，DataType=$dataType'));
        break;
    }
    return {
      'monitorId': monitorId,
      'dataType': () {
        switch (dataType) {
          case DataType.minute:
            return 'minute';
          case DataType.tenminute:
            return 'tenminute';
          case DataType.hour:
            return 'hour';
          case DataType.day:
            return 'day';
          default:
            throw DioError(
                error:
                    InvalidParamException('未知的DataType类型，DataType=$dataType'));
            break;
        }
      }(),
      'startTime':
          DateUtil.getDateStrByDateTime(startTime, format: DateFormat.NORMAL) ??
              '',
      // 结束时间加上23小时59分59秒
      'endTime': DateUtil.getDateStrByDateTime(
              endTime?.add(Duration(
                hours: 23,
                minutes: 59,
                seconds: 59,
              )),
              format: DateFormat.NORMAL) ??
          '',
    };
  }
}
