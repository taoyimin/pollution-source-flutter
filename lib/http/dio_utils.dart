import 'package:dio/dio.dart';
import 'package:pollution_source/util/constant.dart';
import 'intercept.dart';

//Dio工具类，使用单例模式
class DioUtils {
  static final DioUtils _singleton = DioUtils._internal();

  static DioUtils get instance => DioUtils();

  factory DioUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  DioUtils._internal() {
    var options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.json,
      validateStatus: (status) {
        // http响应状态码被dio视为请求成功
        return true;
      },
      baseUrl: "http://182.106.189.190:9999/",
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
