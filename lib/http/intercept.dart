import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/log_utils.dart';

import 'http.dart';

//给request添加身份验证
class AuthInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) {
    String accessToken = SpUtil.getString(Constant.spToken);
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      if (accessToken.isNotEmpty) {
        options.headers[Constant.requestHeaderTokenKey] = accessToken;
      }
    } else {
      if (accessToken.isNotEmpty) {
        options.headers['Authorization'] = accessToken;
      }
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
      if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
        _tokenDio.options = DioUtils.instance.getDio().options;
        var response = await _tokenDio.get(HttpApi.login, queryParameters: {
          'userName': SpUtil.getString(Constant.spUsername),
          'password': SpUtil.getString(Constant.spPassword)
        });
        if (response.statusCode == ExceptionHandle.success &&
            response.data[Constant.responseCodeKey] ==
                ExceptionHandle.success_code) {
          return response.data[Constant.responseDataKey]
              [Constant.responseTokenKey];
        } else {
          throw DioError(
              error:
                  TokenException('刷新Token失败！response=${response.toString()}'));
        }
      } else {
        _tokenDio.options = DioUtils.instance.getDio().options;
        var response = await _tokenDio.post('token', data: {
          'userName': SpUtil.getString(Constant.spUsername),
          'passWord': SpUtil.getString(Constant.spPassword)
        });
        if (response.statusCode == ExceptionHandle.success) {
          return response.data[Constant.responseTokenKey];
        } else {
          throw DioError(
              error:
                  TokenException('刷新Token失败！response=${response.toString()}'));
        }
      }
    } catch (e) {
      throw DioError(error: TokenException('刷新Token失败！错误信息:$e'));
    }
  }

  @override
  onResponse(Response response) async {
    //401代表token过期
    if (response != null &&
        response.statusCode == ExceptionHandle.unauthorized) {
      Log.d("----------- 自动刷新Token ------------");
      Dio dio = DioUtils.instance.getDio();
      dio.interceptors.requestLock.lock();
      String accessToken = await getToken(); // 获取新的accessToken
      Log.e("----------- NewToken: $accessToken ------------");
      //储存token
      SpUtil.putString(Constant.spToken, 'Bearer $accessToken');
      dio.interceptors.requestLock.unlock();
      if (accessToken != null) {
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
    return super.onResponse(response);
  }
}

//统一处理异常
class HandleErrorInterceptor extends Interceptor {
  @override
  onResponse(Response response) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      if (response != null &&
          response.statusCode == ExceptionHandle.success &&
          response.data[Constant.responseCodeKey] ==
              ExceptionHandle.success_code) {
        //状态码200且服务器处理成功
        return super.onResponse(response);
      } else if (response != null &&
          response.statusCode == ExceptionHandle.not_found) {
        //状态码404
        throw DioError(
            error: NotFoundException(
                '404错误,错误接口${response.request.uri.toString()}'));
      } else if (response != null &&
          response.statusCode == ExceptionHandle.server_error) {
        //状态码500
        throw DioError(
            error: ServerErrorException(
                '500错误,错误接口:${response.request.uri.toString()}\nresponse=${response.toString()}'));
      } else if (response != null &&
          response.statusCode == ExceptionHandle.success &&
          response.data[Constant.responseCodeKey] ==
              ExceptionHandle.fail_code) {
        //状态码200但服务器处理失败
        throw DioError(
            error: ServerErrorException(
                '服务器内部错误,错误信息:${response.data[Constant.responseMessageKey]}'));
      } else {
        throw DioError(
            error: UnKnownException('未知错误,response=${response.toString()}'));
      }
    } else {
      if (response != null && response.statusCode == ExceptionHandle.success) {
        //状态码200
        return super.onResponse(response);
      } else if (response != null &&
          response.statusCode == ExceptionHandle.bad_request) {
        //状态码400
        throw DioError(
            error: BadRequestException(
                '${response.data[Constant.responseMessageKey]}'));
      } else if (response != null &&
          response.statusCode == ExceptionHandle.not_found) {
        //状态码404
        throw DioError(
            error: NotFoundException(response.data is Map &&
                    response.data.containsKey(Constant.responseMessageKey)
                ? '${response.data[Constant.responseMessageKey]}'
                : '404错误,错误接口:${response.request.uri.toString()}'));
      } else if (response != null &&
          response.statusCode == ExceptionHandle.server_error) {
        //状态码500
        throw DioError(
            error: ServerErrorException(
                '500错误,错误接口:${response.request.uri.toString()}\nresponse=${response.toString()}'));
      } else {
        throw DioError(
            error: UnKnownException('未知错误,response=${response.toString()}'));
      }
    }
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
