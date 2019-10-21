import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ReportDetailEvent extends Equatable {
  const ReportDetailEvent();

  @override
  List<Object> get props => [];
}

class ReportDetailLoad extends ReportDetailEvent {
  //异常申报单ID
  final String reportId;

  const ReportDetailLoad({@required this.reportId});

  @override
  List<Object> get props => [reportId];
}
