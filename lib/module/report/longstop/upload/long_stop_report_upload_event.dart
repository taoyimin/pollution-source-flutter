import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'long_stop_report_upload_model.dart';

abstract class LongStopReportUploadEvent extends Equatable {
  const LongStopReportUploadEvent();

  @override
  List<Object> get props => [];
}

class LongStopReportUploadLoad extends LongStopReportUploadEvent {
  //异常申报单
  final LongStopReportUpload reportUpload;

  const LongStopReportUploadLoad({@required this.reportUpload});

  @override
  List<Object> get props => [reportUpload];
}

class LongStopReportUploadSend extends LongStopReportUploadEvent {
  //异常申报单
  final LongStopReportUpload reportUpload;

  const LongStopReportUploadSend({@required this.reportUpload});

  @override
  List<Object> get props => [reportUpload];
}
