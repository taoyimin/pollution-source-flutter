import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ReportDetailEvent extends Equatable {
  ReportDetailEvent([List props = const []]) : super(props);
}

class ReportDetailLoad extends ReportDetailEvent {
  //异常申报单ID
  final String reportId;

  ReportDetailLoad({
    @required this.reportId,
  }) : super([
          reportId,
        ]);

  @override
  String toString() => 'ReportDetailLoad';
}
