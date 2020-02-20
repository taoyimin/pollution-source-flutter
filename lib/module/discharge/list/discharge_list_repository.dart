import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class DischargeListRepository extends ListRepository<Discharge> {
  @override
  HttpApi createApi() {
    return HttpApi.dischargeList;
  }

  @override
  Discharge fromJson(json) {
    return Discharge.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [enterName] 按企业名称搜索
  /// [areaCode] 按区域搜索
  /// [enterId] 筛选某企业的所有排口
  /// [dischargeType] 排口类型 1：雨水 2：废水 3：废气
  /// [state] 排口状态 （暂时没用）
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    enterId = '',
    dischargeType = '',
    state = '',
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
      'dischargeType': () {
        switch(dischargeType){
          case '1':
            return 'outletType1';
          case '2':
            return 'outletType2';
          case '3':
            return 'outletType3';
          default:
            return '';
        }
      }(),
      'disOutType': () {
        switch(dischargeType){
          case '1':
            return 'outletType1';
          case '2':
            return 'outletType2';
          case '3':
            return 'outletType3';
          default:
            return '';
        }
      }(),
    };
  }
}
