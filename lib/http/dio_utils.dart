import 'package:dio/dio.dart';
import 'package:pollution_source/res/constant.dart';
import 'intercept.dart';

//Dio工具类，使用单例模式
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
        // http响应状态码被dio视为请求成功
        return true;
      },
      baseUrl: 'http://taoyimin.iok.la:58213/api/',
      //baseUrl: SpUtil.getBool(Constant.spJavaApi, defValue: true) ? 'http://182.106.189.190:9999/' : 'http://182.106.189.190:5000/api/',
    );
    _dio = Dio(options);
    /// 统一添加身份验证请求头
    _dio.interceptors.add(AuthInterceptor());
    /// 刷新Token
    _dio.interceptors.add(TokenInterceptor());
    /// 处理异常
    _dio.interceptors.add(HandleErrorInterceptor());
    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      _dio.interceptors.add(LoggingInterceptor());
    }
  }
}

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
        // http响应状态码被dio视为请求成功
        return true;
      },
      baseUrl: 'http://182.106.189.190:9999/',
      //baseUrl: SpUtil.getBool(Constant.spJavaApi, defValue: true) ? 'http://182.106.189.190:9999/' : 'http://182.106.189.190:5000/api/',
    );
    _dio = Dio(options);
    /// 统一添加身份验证请求头
    _dio.interceptors.add(AuthInterceptor());
    /// 刷新Token
    _dio.interceptors.add(TokenInterceptor());
    /// 处理异常
    _dio.interceptors.add(HandleErrorInterceptor());
    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      _dio.interceptors.add(LoggingInterceptor());
    }
  }
}

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
        // http响应状态码被dio视为请求成功
        return true;
      },
    );
    _dio = Dio(options);
    /// 处理异常
    _dio.interceptors.add(HandleErrorInterceptor());
    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      _dio.interceptors.add(LoggingInterceptor());
    }
  }
}
