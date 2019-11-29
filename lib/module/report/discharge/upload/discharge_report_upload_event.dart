import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'discharge_report_upload_model.dart';

abstract class DischargeReportUploadEvent extends Equatable {
  const DischargeReportUploadEvent();

  @override
  List<Object> get props => [];
}

class DischargeReportUploadLoad extends DischargeReportUploadEvent {
  //异常申报单
  final DischargeReportUpload reportUpload;

  const DischargeReportUploadLoad({@required this.reportUpload});

  @override
  List<Object> get props => [reportUpload];
}

class DischargeReportUploadSend extends DischargeReportUploadEvent {
  //异常申报单
  final DischargeReportUpload reportUpload;

  const DischargeReportUploadSend({@required this.reportUpload});

  @override
  List<Object> get props => [reportUpload];
}
