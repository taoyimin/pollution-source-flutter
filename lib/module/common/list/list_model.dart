import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/res/constant.dart';

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

  static fromJson<T>({json, fromJson}) {
    return ListPage<T>(
      list: json[Constant.responseListKey].map<T>(fromJson).toList(),
      currentPage: SpUtil.getBool(Constant.spJavaApi, defValue: true)
          ? json[Constant.responsePageNumKey]
          : json[Constant.responseCurrentPageKey],
      pageSize: json[Constant.responsePageSizeKey],
      hasNextPage: SpUtil.getBool(Constant.spJavaApi, defValue: true)
          ? json[Constant.responseHasNextPageKey]
          : json[Constant.responseHasNextKey],
      total: json[Constant.responseTotalKey],
    );
  }
}
