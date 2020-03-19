import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class EnterListRepository extends ListRepository<Enter> {
  @override
  HttpApi createApi() {
    return HttpApi.enterList;
  }

  @override
  Enter fromJson(json) {
    return Enter.fromJson(json);
  }

  /// 生成请求所需的参数
  ///
  /// [enterName] 按企业名称搜索
  /// [areaCode] 按区域搜索
  /// [state] 1：在线
  /// [enterType] 企业类型 空:全部企业 0:真实的全部企业 1:雨水企业 2:废水企业 3:废气企业 4:水气企业 5:许可证企业
  /// [attentionLevel] 关注程度 0:非重点 1:重点
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    state = '',
    enterType = '',
    attentionLevel = '',
  }) {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'start': (currentPage - 1) * pageSize,
      'length': pageSize,
      'enterpriseName': enterName,
      'enterName': enterName,
      'areaCode': areaCode,
      'state': state == '1' ? 'online' : '',
      'enterpriseType': () {
        switch (enterType) {
          case '1':
            return 'outletType1';
          case '2':
            return 'outletType2';
          case '3':
            return 'outletType3';
          case '4':
            return 'outletType4';
          case '5':
            return 'licence';
          default:
            return '';
        }
      }(),
      'attentionLevel': attentionLevel,
      // 传1查询真实的全部企业，污染源企业统计查询全部企业时会用到该字段，
      'hasAll': () {
        if (enterType == '0')
          return '1';
        else
          return '0';
      },
    };
  }
}
