import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

abstract class DetailRepository<T> {
  Future<T> request({@required String detailId, Map<String, dynamic> params, CancelToken cancelToken});
}
