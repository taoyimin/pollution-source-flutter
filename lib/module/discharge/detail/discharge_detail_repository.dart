import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_model.dart';
import 'package:pollution_source/res/constant.dart';

class DischargeDetailRepository extends DetailRepository<DischargeDetail> {
  @override
  Future<DischargeDetail> request(
      {@required String detailId,
      Map<String, dynamic> params,
      CancelToken cancelToken}) async {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      Response response = await JavaDioUtils.instance.getDio().get(
            HttpApiJava.dischargeDetail,
            queryParameters: {'dischargeId': detailId},
            cancelToken: cancelToken,
          );
      return DischargeDetail.fromJson(response.data[Constant.responseDataKey]);
    } else {
      Response response = await PythonDioUtils.instance.getDio().get(
            '${HttpApiPython.discharges}/$detailId',
            queryParameters: params,
            cancelToken: cancelToken,
          );
      return DischargeDetail.fromJson(response.data);
    }
  }
}
