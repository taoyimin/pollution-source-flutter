import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/intercept.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/compat_utils.dart';
import 'dart:convert' as convert;

class LoginRepository {
  Future<Response> login(
      {int userType, String userName, String passWord, Dio dio}) async {
    if (userType == 2) {
      // 运维用户把用户名和密码放在header中
      var header = {
        'userCode': userName,
        'passWord': passWord,
        'timestamp': DateUtil.getNowDateMs(),
      };
      // 运维登录的时候使用新的dio添加Authorization，防止token拦截器覆盖Authorization
      if (dio == null) {
        dio = Dio(CompatUtils.getDio().options);
        // 加上异常处理和日志拦截器
        dio.interceptors.add(HandleErrorInterceptor());
        if (!Constant.inProduction) dio.interceptors.add(LoggingInterceptor());
      }
      dio.options.headers = {
        Constant.requestHeaderAuthorizationKey:
            'JXHBBasic ${convert.jsonEncode(header)}'
      };
    }
    Response response = await (dio ?? (CompatUtils.getDio())).post(
      '${CompatUtils.getApi(Constant.loginApis[userType])}',
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
        return FormData.fromMap({
          'userName': userName,
          'password': passWord,
        });
      case 2:
        //运维用户账号密码放在header中，isEncryption为false表示登录不需要加密解密
        return FormData.fromMap({
          'isEncryption': false,
        });
      default:
        throw Exception(
            '生成登录参数失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }
}
