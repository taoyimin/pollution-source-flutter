import 'package:equatable/equatable.dart';
import 'package:pollution_source/util/compat_utils.dart';

class ListPage<T> extends Equatable {
  final List<T> list;
  final bool hasNextPage;
  final int total;
  final int pageSize;
  final int currentPage;

  const ListPage({
    this.list,
    this.hasNextPage,
    this.total,
    this.pageSize,
    this.currentPage,
  });

  @override
  List<Object> get props => [
        list,
        hasNextPage,
        total,
        pageSize,
        currentPage,
      ];

  static fromJson<T>({dynamic json,T Function(dynamic) fromJson}) {
    return ListPage<T>(
      list: CompatUtils.getList(json).map<T>(fromJson).toList(),
      currentPage: CompatUtils.getCurrentPage(json),
      pageSize: CompatUtils.getPageSize(json),
      hasNextPage:CompatUtils.getHasNextPage(json),
      total: CompatUtils.getTotal(json),
    );
  }
}
