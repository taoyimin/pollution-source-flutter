import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/res/constant.dart';

//传入时间戳，使得每次都触发状态改变
abstract class LicenseListState extends Equatable{
  const LicenseListState();

  @override
  List<Object> get props => [DateTime.now()];
}

class LicenseListLoading extends LicenseListState {}

class LicenseListLoaded extends LicenseListState {
  //排污许可证列表
  final licenseList;

  //能否加载更多
  final bool hasNextPage;

  final int pageSize;

  final int currentPage;

  const LicenseListLoaded({
    @required this.licenseList,
    @required this.hasNextPage,
    this.currentPage = Constant.defaultCurrentPage,
    this.pageSize = Constant.defaultPageSize,
  });
}

//排污许可证列表页没有数据的状态
class LicenseListEmpty extends LicenseListState {}

//排污许可证列表页发生错误的状态
class LicenseListError extends LicenseListState {
  final String errorMessage;

  const LicenseListError({@required this.errorMessage});
}
