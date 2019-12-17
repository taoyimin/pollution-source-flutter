import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/list/list_model.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_model.dart';
import 'package:pollution_source/res/constant.dart';

class DischargeListRepository extends ListRepository<Discharge> {
  @override
  Future<ListPage<Discharge>> request(
      {Map<String, dynamic> params, CancelToken cancelToken}) async {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      Response response = await JavaDioUtils.instance.getDio().get(
          HttpApiJava.dischargeList,
          queryParameters: params,
          cancelToken: cancelToken);
      return ListPage.fromJson<Discharge>(
          json: response.data[Constant.responseDataKey],
          fromJson: (json) {
            return Discharge.fromJson(json);
          });
    } else {
      Response response = await PythonDioUtils.instance.getDio().get(
          HttpApiPython.discharges,
          queryParameters: params,
          cancelToken: cancelToken);
      return ListPage.fromJson<Discharge>(
          json: response.data,
          fromJson: (json) {
            return Discharge.fromJson(json);
          });
    }
  }

  /// 生成请求所需的参数
  ///
  /// [enterName] 按企业名称搜索
  /// [areaCode] 按区域搜索
  /// [enterId] 筛选某企业的所有排口
  /// [dischargeType] 排口类型 outletType1：雨水 outletType2：废水 outletType3：废气
  /// [state] 排口状态
  static Map<String, dynamic> createParams({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    enterId = '',
    dischargeType = '',
    state = '',
  }) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterpriseName': enterName,
        'areaCode': areaCode,
        'enterId': enterId,
        'dischargeType': dischargeType,
        'state': state,
      };
    } else {
      return {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterName': enterName,
        'areaCode': areaCode,
        'enterId': enterId,
        'dischargeType': dischargeType,
        'state': state,
      };
    }
  }
}
