import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'report_detail_model.dart';

abstract class ReportDetailState extends Equatable {
  ReportDetailState([List props = const []]) : super(props);
}

//异常申报单详情页初始的加载状态
class ReportDetailLoading extends ReportDetailState {
  @override
  String toString() => 'ReportDetailLoading';
}

//异常申报单详情加载完成的状态
class ReportDetailLoaded extends ReportDetailState {
  //异常申报单列表
  final ReportDetail reportDetail;

  ReportDetailLoaded({
    @required this.reportDetail,
  }) : super([
          reportDetail,
        ]);
}

//异常申报单详情页没有数据的状态
class ReportDetailEmpty extends ReportDetailState {
  @override
  String toString() => 'ReportDetailEmpty';
}

//异常申报单详情页发生错误的状态
class ReportDetailError extends ReportDetailState {
  final errorMessage;

  ReportDetailError({
    @required this.errorMessage,
  }) : super([
          errorMessage,
        ]);

  @override
  String toString() => 'ReportDetailError';
}
