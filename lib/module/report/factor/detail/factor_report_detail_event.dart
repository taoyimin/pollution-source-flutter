import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FactorReportDetailEvent extends Equatable {
  const FactorReportDetailEvent();

  @override
  List<Object> get props => [];
}

class FactorReportDetailLoad extends FactorReportDetailEvent {
  //异常申报单ID
  final String reportId;

  const FactorReportDetailLoad({@required this.reportId});

  @override
  List<Object> get props => [reportId];
}
