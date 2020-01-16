import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/module/login/login_repository.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/compat_utils.dart';
import 'package:pollution_source/util/log_utils.dart';

import 'http.dart';

/// 认证拦截器
///
/// 统一给所有request添加身份验证
class AuthInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) {
    CompatUtils.setToken(options);
    return super.onRequest(options);
  }
}

/// 自动刷新Token拦截器
///
/// 若状态码为401，则自动刷新token，并自动重新进行请求
class TokenInterceptor extends Interceptor {
  Dio _tokenDio;

  TokenInterceptor() {
    _tokenDio = Dio();
    // 加上异常处理和日志拦截器
    _tokenDio.interceptors.add(HandleErrorInterceptor());
    if (!Constant.inProduction)
      _tokenDio.interceptors.add(LoggingInterceptor());
  }

  @override
  onResponse(Response response) async {
    if (response != null &&
        response.statusCode == ExceptionHandle.unauthorized) {
      Log.d("----------- 自动刷新Token ------------");
      _tokenDio.options = CompatUtils.getDio().options;
      // 锁住防止请求传入，直到token刷新
      CompatUtils.getDio().lock();
      await LoginRepository()
          .login(
        userType: SpUtil.getInt(Constant.spUserType),
        userName: SpUtil.getString(
            Constant.spUsernameList[SpUtil.getInt(Constant.spUserType)]),
        passWord: SpUtil.getString(
            Constant.spPasswordList[SpUtil.getInt(Constant.spUserType)]),
        dio: _tokenDio,
      )
          .then((tokenResponse) {
        String accessToken = CompatUtils.getResponseToken(tokenResponse);
        Log.i("----------- NewToken: $accessToken ------------");
        //储存token
        SpUtil.putString(Constant.spToken, '$accessToken');
      }).whenComplete(() {
        CompatUtils.getDio().unlock();
      });
      // 重新请求失败接口
      RequestOptions options = response.request;
      CompatUtils.setToken(options);
      Log.i("----------- 重新请求接口 ------------");
      if (options.data is FormData) {
        // 由于MultipartFile是基于Stream的，Stream只能读取一次，所以应该重新创建
        FormData formData = FormData();
        formData.fields.addAll(options.data.fields);
        for (MapEntry mapFile in options.data.files) {
          formData.files.add(MapEntry(
              mapFile.key,
              MultipartFile.fromFileSync(mapFile.value.FILE_PATH,
              filename: mapFile.value.filename)));
        }
        options.data = formData;
      }
      //避免重复执行拦截器，使用tokenDio
      var newResponse = await _tokenDio.request(
        options.path,
        data: options.data,
        queryParameters: options.queryParameters,
        cancelToken: options.cancelToken,
        options: options,
        onReceiveProgress: options.onReceiveProgress,
      );
      return newResponse;
    }
    return super.onResponse(response);
  }
}

/// 异常处理拦截器
///
/// 统一处理异常
class HandleErrorInterceptor extends Interceptor {
  @override
  onResponse(Response response) {
    if (response != null && response.statusCode == ExceptionHandle.success) {
      // 状态码200（如果response中有code或success还需要判断code是否为success_code，success是否为true）
      if(response.data is List<dynamic>){
        // 有时接口会直接返回List
        return super.onResponse(response);
      } else if (response.data is Map &&
              response.data.containsKey(Constant.responseCodeKey)
          ? response.data[Constant.responseCodeKey] ==
              ExceptionHandle.success_code
          : true && response.data.containsKey(Constant.responseSuccessKey)
              ? response.data[Constant.responseSuccessKey]
              : true)
        // 状态码200服务器处理成功
        return super.onResponse(response);
      else
        // 状态码200但服务器处理失败
        throw DioError(
            error: ServerErrorException(
                '服务器处理错误,错误信息:response=${response.toString()}'));
    } else if (response != null &&
        response.statusCode == ExceptionHandle.bad_request) {
      // 状态码400
      throw DioError(
          error: BadRequestException(response.data is Map &&
                  response.data.containsKey(Constant.responseMessageKey)
              ? '${response.data[Constant.responseMessageKey]}'
              : '400错误,错误接口:${response.request.uri.toString()}'));
    } else if (response != null &&
        response.statusCode == ExceptionHandle.unauthorized) {
      // 状态码401
      throw DioError(
          error: UnauthorizedException(
              '401错误，认证失败:response=${response.toString()}'));
    } else if (response != null &&
        response.statusCode == ExceptionHandle.not_found) {
      // 状态码404
      throw DioError(
          error: NotFoundException(response.data is Map &&
                  response.data.containsKey(Constant.responseMessageKey)
              ? '${response.data[Constant.responseMessageKey]}'
              : '404错误,错误接口:${response.request.uri.toString()}'));
    } else if (response != null &&
        response.statusCode == ExceptionHandle.server_error) {
      // 状态码500
      throw DioError(
          error: ServerErrorException(
              '500错误,错误接口:${response.request.uri.toString()}\nresponse=${response.toString()}'));
    } else {
      throw DioError(
          error: UnKnownException('未知错误,response=${response.toString()}'));
    }
  }
}

/// 日志拦截器
///
/// 打印网络请求日志，生产环境下不添加该拦截器
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
    Log.d(err.toString());
    Log.d("----------Error-----------");
    return super.onError(err);
  }
}
