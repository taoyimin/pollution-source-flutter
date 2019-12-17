import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_model.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class EnterListRepository extends ListRepository<Enter> {
  @override
  Future<ListPage<Enter>> request(
      {Map<String, dynamic> params, CancelToken cancelToken}) async {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      Response response = await JavaDioUtils.instance.getDio().get(
          HttpApiJava.enterList,
          queryParameters: params,
          cancelToken: cancelToken);
      return ListPage.fromJson<Enter>(
          json: response.data[Constant.responseDataKey],
          fromJson: (json) {
            return Enter.fromJson(json);
          });
    } else {
      Response response = await PythonDioUtils.instance.getDio().get(
          HttpApiPython.enters,
          queryParameters: params,
          cancelToken: cancelToken);
      return ListPage.fromJson<Enter>(
          json: response.data,
          fromJson: (json) {
            return Enter.fromJson(json);
          });
    }
  }

  /// 生成请求所需的参数
  ///
  /// [enterName] 按企业名称搜索
  /// [areaCode] 按区域搜索
  /// [state] 在线状态 online:在线 空:全部
  /// [enterType] 企业类型 outletType1:雨水企业 outletType2:废水企业 outletType3:废气企业 licence:许可证企业
  /// [attentionLevel] 0:非重点源 1:重点源
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    state = '',
    enterType = '',
    attentionLevel = '',
  }) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterpriseName': enterName,
        'areaCode': areaCode,
        'state': state == '1' ? 'online' : '',
        'enterpriseType': () {
          switch(enterType){
            case 'EnterType1':
              return 'outletType2';
            case 'EnterType2':
              return 'outletType3';
            case 'EnterType1,EnterType2':
              return 'outletType2,outletType3';
            case 'licence':
              return 'licence';
            case 'outletType1':
              return 'outletType1';
            default:
              return '';
          }
        }(),
        'attenLevel': attentionLevel,
      };
    } else {
      return {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterName': enterName,
        'areaCode': areaCode,
        'state': state,
        'enterType': enterType,
        'attentionLevel': attentionLevel,
      };
    }
  }
}
