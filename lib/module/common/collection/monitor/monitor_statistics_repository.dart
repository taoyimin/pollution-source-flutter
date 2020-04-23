import 'package:meta/meta.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/collection/collection_repository.dart';

import 'monitor_statistics_model.dart';

class MonitorStatisticsRepository extends CollectionRepository {
  @override
  HttpApi createApi() {
    return HttpApi.monitorStatistics;
  }

  @override
  fromJson(json) {
    return MonitorStatistics.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [userType] 用户类型 1:环保 2:企业 3:运维
  /// [userId] 用户id
  /// [enterId] 企业id
  /// [attentionLevel] 关注程度 0:非重点 1:重点
  /// [outType] 排放类型 0:出口 1:进口
  static Map<String, dynamic> createParams({
    @required userType,
    userId = '',
    enterId = '',
    attentionLevel = '',
    outType = '',
  }) {
    return {
      'userType': userType,
      'userId': userId,
      'enterId': enterId,
      'attenLevel': attentionLevel,
      'outType': outType,
    };
  }
}
