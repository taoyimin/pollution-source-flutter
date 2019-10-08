import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/util/constant.dart';
import 'package:pollution_source/util/log_utils.dart';

import 'dio_utils.dart';
import 'error_handle.dart';
import 'http.dart';

//给request添加身份验证
class AuthInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) {
    String accessToken = SpUtil.getString(Constant.spToken);
    if (accessToken.isNotEmpty) {
      //options.headers["Authorization"] = "Bearer $accessToken";
      options.headers[Constant.requestHeaderTokenKey] = accessToken;
    }
    return super.onRequest(options);
  }
}

//自动刷新token
class TokenInterceptor extends Interceptor {
  Dio _tokenDio = Dio();

  //由于没有刷新token接口，所以这里调用登录接口获取token
  Future<String> getToken() async {
    try {
      _tokenDio.options = DioUtils.instance.getDio().options;
      var response = await _tokenDio.get(HttpApi.login, queryParameters: {
        'userName': SpUtil.getString(Constant.spUsername),
        'password': SpUtil.getString(Constant.spPassword)
      });
      if(response.statusCode == ExceptionHandle.success && response.data[Constant.responseCodeKey] == ExceptionHandle.success_code){
        return response.data[Constant.responseDataKey][Constant.responseTokenKey];
      }
    } catch (e) {
      Log.e("刷新Token失败！");
    }
    return null;
  }

  @override
  onResponse(Response response) async {
    print('嘿嘿');
    print(response != null &&
        response.statusCode == ExceptionHandle.unauthorized);
    //401代表token过期
    if (response != null &&
        response.statusCode == ExceptionHandle.unauthorized) {
      Log.d("----------- 自动刷新Token ------------");
      Dio dio = DioUtils.instance.getDio();
      dio.interceptors.requestLock.lock();
      String accessToken = await getToken(); // 获取新的accessToken
      Log.e("----------- NewToken: $accessToken ------------");
      SpUtil.putString(Constant.spToken, accessToken);
      dio.interceptors.requestLock.unlock();

      if (accessToken != null) {
        {
          // 重新请求失败接口
          var request = response.request;
          request.headers[Constant.requestHeaderTokenKey] = accessToken;
          try {
            Log.e("----------- 重新请求接口 ------------");
            /// 避免重复执行拦截器，使用tokenDio
            var response = await _tokenDio.request(request.path,
                data: request.data,
                queryParameters: request.queryParameters,
                cancelToken: request.cancelToken,
                options: request,
                onReceiveProgress: request.onReceiveProgress);
            return response;
          } on DioError catch (e) {
            return e;
          }
        }
      }
    }
    return super.onResponse(response);
  }
}

//打印网络请求日志，生产环境下不添加该拦截器
class LoggingInterceptor extends Interceptor {
  DateTime startTime;
  DateTime endTime;

  @override
  onRequest(RequestOptions options) {
    startTime = DateTime.now();
    Log.d("----------Start----------");
    if (options.queryParameters.isEmpty) {
      Log.i("RequestUrl: " + options.baseUrl + options.path);
    } else {
      Log.i("RequestUrl: " +
          options.baseUrl +
          options.path +
          "?" +
          Transformer.urlEncodeMap(options.queryParameters));
    }
    Log.d("RequestMethod: " + options.method);
    Log.d("RequestHeaders:" + options.headers.toString());
    Log.d("RequestContentType: ${options.contentType}");
    Log.d("RequestData: ${options.data.toString()}");
    return super.onRequest(options);
  }

  @override
  onResponse(Response response) {
    endTime = DateTime.now();
    int duration = endTime.difference(startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandle.success) {
      Log.d("ResponseCode: ${response.statusCode}");
    } else {
      Log.e("ResponseCode: ${response.statusCode}");
    }
    // 输出结果
    Log.json(response.data.toString());
    Log.d("----------End: $duration 毫秒----------");
    return super.onResponse(response);
  }

  @override
  onError(DioError err) {
    Log.d("----------Error-----------");
    return super.onError(err);
  }
}
