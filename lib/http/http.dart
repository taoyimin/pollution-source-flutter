import 'package:dio/dio.dart';
BaseOptions options = new BaseOptions(
  baseUrl: "https://tcc.taobao.com/cc/json",
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = new Dio(options);