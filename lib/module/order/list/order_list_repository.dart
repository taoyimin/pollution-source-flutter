import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/order/list/order_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class OrderListRepository extends ListRepository<Order> {
  @override
  HttpApi createApi() {
    return HttpApi.orderList;
  }

  @override
  Order fromJson(json) {
    return Order.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [enterName] 按企业名称搜索
  /// [areaCode] 按区域搜索
  /// [alarmState] 状态 0：全部 1：待督办 2：待处理 3：待审核 4：审核不通过 5：已办结
  /// [enterId] 筛选某企业的所有报警管理单
  /// [monitorId] 筛选某监控点的所有报警管理单
  /// [alarmLevel] 报警级别 0：正常 1：黄色预警 2：橙色预警 3：红色预警
  /// [attentionLevel] 关注程度 0:非重点 1:重点
  /// [alarmType] 报警类型
  /// [startTime] 报警开始时间
  /// [endTime] 报警结束时间
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    alarmState = '',
    enterId = '',
    monitorId = '',
    alarmLevel = '',
    attentionLevel = '',
    alarmType = '',
    startTime,
    endTime,
  }) {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'start': (currentPage - 1) * pageSize,
      'length': pageSize,
      'enterpriseName': enterName,
      'enterName': enterName,
      'areaCode': areaCode,
      'enterId': enterId,
      'monitorId': monitorId,
      'alarmLevel': alarmLevel,
      'attentionLevel': attentionLevel,
      'alarmType': alarmType,
      'alarmBeginTime': DateUtil.getDateStrByDateTime(startTime,
          format: DateFormat.YEAR_MONTH_DAY) ?? '',
      'alarmEndTime': DateUtil.getDateStrByDateTime(endTime,
          format: DateFormat.YEAR_MONTH_DAY) ?? '',
      'alarmState': alarmState,
    };
  }
}
