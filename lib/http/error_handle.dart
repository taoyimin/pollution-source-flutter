import 'dart:io';
import 'package:dio/dio.dart';

//统一处理异常
class ExceptionHandle{
  static const int success_code = 1;
  static const int fail_code = -1;

  static const int success = 200;
  static const int success_not_content = 204;
  static const int invalid_param = 300;
  static const int bad_request = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int not_found = 404;
  static const int server_error = 500;

  static const int net_error = 1000;
  static const int parse_error = 1001;
  static const int socket_error = 1002;
  static const int http_error = 1003;
  static const int timeout_error = 1004;
  static const int cancel_error = 1005;
  static const int token_error = 1006;
  static const int unknown_error = 9999;

  static NetError handleException(dynamic error) {
    if (error is DioError) {
      if (error.type == DioErrorType.DEFAULT ||
          error.type == DioErrorType.RESPONSE) {
        dynamic e = error.error;
        if (e is SocketException) {
          return NetError(socket_error, "网络异常，请检查你的网络！");
        }
        if (e is HttpException) {
          return NetError(http_error, "服务器异常！");
        }
        if (e is InvalidParamException) {
          return NetError(invalid_param, e.message);
        }
        if (e is BadRequestException) {
          return NetError(bad_request, e.message);
        }
        if (e is NotFoundException) {
          return NetError(not_found, e.message);
        }
        if (e is ServerErrorException) {
          return NetError(server_error, e.message);
        }
        if (e is TokenException) {
          return NetError(token_error, e.message);
        }
        if (e is UnKnownException) {
          return NetError(unknown_error, e.message);
        }
        return NetError(net_error, "未知网络异常:$error");
      } else if (error.type == DioErrorType.CONNECT_TIMEOUT ||
          error.type == DioErrorType.SEND_TIMEOUT ||
          error.type == DioErrorType.RECEIVE_TIMEOUT) {
        return NetError(timeout_error, "连接超时！");
      } else if (error.type == DioErrorType.CANCEL) {
        return NetError(cancel_error, "取消请求");
      } else {
        return NetError(unknown_error, "未知异常:$error");
      }
    } else {
      return NetError(unknown_error, "未知错误:$error");
    }
  }
}

class NetError {
  int code;
  String msg;

  NetError(this.code, this.msg);
}

//bad request异常
class BadRequestException implements Exception{
  final String message;

  BadRequestException(this.message);
}

//not found异常
class NotFoundException implements Exception{
  final String message;

  NotFoundException(this.message);
}

//服务器异常
class ServerErrorException implements Exception{
  final String message;

  ServerErrorException(this.message);
}

//未知异常
class UnKnownException implements Exception{
  final String message;

  UnKnownException(this.message);
}

//token异常
class TokenException implements Exception{
  final String message;

  TokenException(this.message);
}

//请求参数不合法
class InvalidParamException implements Exception{
  final String message;

  InvalidParamException(this.message);
}
