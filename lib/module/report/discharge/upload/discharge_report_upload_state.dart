import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'discharge_report_upload_model.dart';

abstract class DischargeReportUploadState extends Equatable {
  const DischargeReportUploadState();

  @override
  List<Object> get props => [];
}

//异常申报界面加载完成
class DischargeReportUploadLoaded extends DischargeReportUploadState{
  final DischargeReportUpload reportUpload;

  const DischargeReportUploadLoaded({@required this.reportUpload});

  @override
  List<Object> get props => [reportUpload];
}

//异常申报单上报成功
class DischargeReportUploadSuccess extends DischargeReportUploadState {}

//异常申报单上报失败
class DischargeReportUploadError extends DischargeReportUploadState {
  final String errorMessage;

  const DischargeReportUploadError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
