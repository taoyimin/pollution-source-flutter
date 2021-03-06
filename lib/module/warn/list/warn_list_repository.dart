import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/warn/list/warn_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class WarnListRepository extends ListRepository<Warn> {
  @override
  HttpApi createApi() {
    return HttpApi.warnList;
  }

  @override
  Warn fromJson(json) {
    return Warn.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [cityCode] 按城市搜索
  /// [areaCode] 按县区搜索
  /// [alarmType] 报警类型
  /// [startTime] 开始时间
  /// [endTime] 结束时间
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    cityCode = '',
    areaCode = '',
    alarmType = '',
    DateTime startTime,
    DateTime endTime,
  }) {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'start': (currentPage - 1) * pageSize,
      'length': pageSize,
      'alarmType': alarmType,
      'cityCode': cityCode,
      'areaCode': areaCode,
      'startTime': DateUtil.formatDate(startTime),
      'endTime': DateUtil.formatDate(
          endTime?.add(Duration(hours: 23, minutes: 59, seconds: 59))),
    };
  }
}
