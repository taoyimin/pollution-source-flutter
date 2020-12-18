import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/intercept.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/config_utils.dart';

/// Dio工具类，使用单例模式
///
/// 用于访问污染源后台接口
class PollutionDioUtils {
  static final PollutionDioUtils _singleton = PollutionDioUtils.internal();

  static PollutionDioUtils get instance => PollutionDioUtils();

  factory PollutionDioUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  PollutionDioUtils.internal() {
    var options = BaseOptions(
      connectTimeout: 20000,
      receiveTimeout: 20000,
      responseType: ResponseType.json,
      validateStatus: (status) {
        return true;
      },
      baseUrl: ConfigUtils.getPollutionBaseUrl(),
    );
    _dio = Dio(options);
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(HandleErrorInterceptor());
    if (!Constant.inProduction ||
        SpUtil.getBool(Constant.spDebug, defValue: false))
      _dio.interceptors.add(LoggingInterceptor());
  }
}

/// Dio工具类，使用单例模式
///
/// 用于访问运维后台接口
class OperationDioUtils {
  static final OperationDioUtils _singleton = OperationDioUtils.internal();

  static OperationDioUtils get instance => OperationDioUtils();

  factory OperationDioUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  OperationDioUtils.internal() {
    var options = BaseOptions(
      connectTimeout: 20000,
      receiveTimeout: 20000,
      responseType: ResponseType.json,
      validateStatus: (status) {
        return true;
      },
      baseUrl: ConfigUtils.getOperationBaseUrl(),
    );
    _dio = Dio(options);
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(HandleErrorInterceptor());
    if (!Constant.inProduction ||
        SpUtil.getBool(Constant.spDebug, defValue: false))
      _dio.interceptors.add(LoggingInterceptor());
  }
}

/// 访问文件Dio工具类
///
/// 使用单例工厂模式，去除了[BaseOptions]中[baseUrl]的配置
/// 和[AuthInterceptor],[TokenInterceptor]两个拦截器
class FileDioUtils {
  static final FileDioUtils _singleton = FileDioUtils._internal();

  static FileDioUtils get instance => FileDioUtils();

  factory FileDioUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  FileDioUtils._internal() {
    var options = BaseOptions(
      connectTimeout: 600000,
      receiveTimeout: 600000,
      responseType: ResponseType.json,
      validateStatus: (status) {
        return true;
      },
    );
    _dio = Dio(options);
    if (!Constant.inProduction ||
        SpUtil.getBool(Constant.spDebug, defValue: false))
      _dio.interceptors.add(LoggingInterceptor());
  }
}
