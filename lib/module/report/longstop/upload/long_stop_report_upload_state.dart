import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'long_stop_report_upload_model.dart';

abstract class LongStopReportUploadState extends Equatable {
  const LongStopReportUploadState();

  @override
  List<Object> get props => [];
}

//异常申报界面加载完成
class LongStopReportUploadLoaded extends LongStopReportUploadState{
  final LongStopReportUpload reportUpload;

  const LongStopReportUploadLoaded({@required this.reportUpload});

  @override
  List<Object> get props => [reportUpload];
}

//异常申报单上报成功
class LongStopReportUploadSuccess extends LongStopReportUploadState {}

//异常申报单上报失败
class LongStopReportUploadError extends LongStopReportUploadState {
  final String errorMessage;

  const LongStopReportUploadError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
