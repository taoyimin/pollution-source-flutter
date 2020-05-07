import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/res/constant.dart';

import 'notice_list_model.dart';

class NoticeListRepository extends ListRepository<Notice> {
  @override
  HttpApi createApi() {
    return HttpApi.notificationList;
  }

  @override
  Notice fromJson(json) {
    return Notice.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [startTime] 开始时间
  /// [endTime] 结束时间
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    startTime = '',
    endTime = '',
  }) {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'start': (currentPage - 1) * pageSize,
      'length': pageSize,
      'startTime': DateUtil.getDateStrByDateTime(startTime,
              format: DateFormat.YEAR_MONTH_DAY) ??
          '',
      'endTime': DateUtil.getDateStrByDateTime(endTime,
              format: DateFormat.YEAR_MONTH_DAY) ??
          '',
      'userType': Constant.userTags[SpUtil.getInt(Constant.spUserType)],
    };
  }
}
