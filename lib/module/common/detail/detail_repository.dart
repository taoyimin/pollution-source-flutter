import 'package:dio/dio.dart';

abstract class DetailRepository<T, V> {
  Future<V> request({String detailId, T queryParameters, CancelToken cancelToken});
}
