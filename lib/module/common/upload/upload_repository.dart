import 'package:dio/dio.dart';

abstract class UploadRepository<T, V> {
  Future<V> upload({T data, CancelToken cancelToken});
}
