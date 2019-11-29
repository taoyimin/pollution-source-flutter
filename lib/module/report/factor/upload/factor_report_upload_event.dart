import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'factor_report_upload_model.dart';

abstract class FactorReportUploadEvent extends Equatable {
  const FactorReportUploadEvent();

  @override
  List<Object> get props => [];
}

class FactorReportUploadLoad extends FactorReportUploadEvent {
  //异常申报单
  final FactorReportUpload reportUpload;

  const FactorReportUploadLoad({@required this.reportUpload});

  @override
  List<Object> get props => [reportUpload];
}

class FactorReportUploadSend extends FactorReportUploadEvent {
  //异常申报单
  final FactorReportUpload reportUpload;

  const FactorReportUploadSend({@required this.reportUpload});

  @override
  List<Object> get props => [reportUpload];
}
