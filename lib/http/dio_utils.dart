import 'package:dio/dio.dart';
import 'package:pollution_source/http/intercept.dart';
import 'package:pollution_source/res/constant.dart';

/// Dio工具类，使用单例模式
///
/// 用于访问污染源Python后台接口
/// debug地址：http://taoyimin.iok.la:58213/api/
class PythonDioUtils {
  static final PythonDioUtils _singleton = PythonDioUtils._internal();

  static PythonDioUtils get instance => PythonDioUtils();

  factory PythonDioUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  PythonDioUtils._internal() {
    var options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.json,
      validateStatus: (status) {
        return true;
      },
      baseUrl: 'http://118.89.20.44:80/api/',
    );
    _dio = Dio(options);
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(HandleErrorInterceptor());
    if (!Constant.inProduction) _dio.interceptors.add(LoggingInterceptor());
  }
}

/// Dio工具类，使用单例模式
///
/// 用于访问污染源Java后台接口
class JavaDioUtils {
  static final JavaDioUtils _singleton = JavaDioUtils._internal();

  static JavaDioUtils get instance => JavaDioUtils();

  factory JavaDioUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  JavaDioUtils._internal() {
    var options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.json,
      validateStatus: (status) {
        return true;
      },
      // 正式环境
      baseUrl: 'http://111.75.227.207:19551/'
      // 测试环境
      // baseUrl: 'http://182.106.189.190:9999/',
    );
    _dio = Dio(options);
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(HandleErrorInterceptor());
    if (!Constant.inProduction) _dio.interceptors.add(LoggingInterceptor());
  }
}

/// Dio工具类，使用单例模式
///
/// 用于访问运维后台接口
class OperationDioUtils {
  static final OperationDioUtils _singleton = OperationDioUtils._internal();

  static OperationDioUtils get instance => OperationDioUtils();

  factory OperationDioUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  OperationDioUtils._internal() {
    var options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.json,
      validateStatus: (status) {
        return true;
      },
      // 正式环境
      baseUrl: 'http://111.75.227.207:19550/',
      // 测试环境
      // baseUrl: 'http://192.168.253.1:8001/',
    );
    _dio = Dio(options);
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(HandleErrorInterceptor());
    if (!Constant.inProduction) _dio.interceptors.add(LoggingInterceptor());
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
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.json,
      validateStatus: (status) {
        return true;
      },
    );
    _dio = Dio(options);
    //_dio.interceptors.add(HandleErrorInterceptor());
    if (!Constant.inProduction) _dio.interceptors.add(LoggingInterceptor());
  }
}
