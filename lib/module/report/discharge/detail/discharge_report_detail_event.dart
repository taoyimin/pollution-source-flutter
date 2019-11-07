import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DischargeReportDetailEvent extends Equatable {
  const DischargeReportDetailEvent();

  @override
  List<Object> get props => [];
}

class DischargeReportDetailLoad extends DischargeReportDetailEvent {
  //异常申报单ID
  final String reportId;

  const DischargeReportDetailLoad({@required this.reportId});

  @override
  List<Object> get props => [reportId];
}
