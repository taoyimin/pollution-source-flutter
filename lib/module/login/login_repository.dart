import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/compat_utils.dart';

class LoginRepository {
  static List<HttpApi> loginApis = [
    HttpApi.adminToken,
    HttpApi.enterToken,
    HttpApi.operationToken
  ];

  Future<Response> login(
      {int userType, String userName, String passWord, Dio dio}) async {
    Response response = await (dio ?? (CompatUtils.getDio())).post(
      '${CompatUtils.getApi(loginApis[userType])}',
      data: createParams(
        userType: userType,
        userName: userName,
        passWord: passWord,
      ),
    );
    return response;
  }

  static FormData createParams(
      {int userType, String userName, String passWord}) {
    switch (userType) {
      case 0:
      case 1:
        //环保和企业用户
        if (SpUtil.getBool(Constant.spUseJavaApi))
          return FormData.fromMap({
            'userName': userName,
            'password': passWord,
          });
        else
          return FormData.fromMap({
            'userName': userName,
            'passWord': passWord,
          });
        break;
      case 2:
        //TODO 运维用户
        return FormData.fromMap({
          'userName': userName,
          'passWord': passWord,
        });
      default:
        throw Exception(
            '生成登录参数失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }
}
