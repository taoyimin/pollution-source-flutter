import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LongStopReportDetailEvent extends Equatable {
  const LongStopReportDetailEvent();

  @override
  List<Object> get props => [];
}

class LongStopReportDetailLoad extends LongStopReportDetailEvent {
  //异常申报单ID
  final String reportId;

  const LongStopReportDetailLoad({@required this.reportId});

  @override
  List<Object> get props => [reportId];
}
