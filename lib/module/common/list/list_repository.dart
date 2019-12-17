import 'package:dio/dio.dart';
import 'package:pollution_source/module/common/list/list_model.dart';

abstract class ListRepository<T> {
  Future<ListPage<T>> request(
      {Map<String, dynamic> params, CancelToken cancelToken});
}
