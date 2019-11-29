import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'factor_report_upload_model.dart';

abstract class FactorReportUploadState extends Equatable {
  const FactorReportUploadState();

  @override
  List<Object> get props => [];
}

//异常申报界面加载完成
class FactorReportUploadLoaded extends FactorReportUploadState{
  final FactorReportUpload reportUpload;

  const FactorReportUploadLoaded({@required this.reportUpload});

  @override
  List<Object> get props => [reportUpload];
}

//异常申报单上报成功
class FactorReportUploadSuccess extends FactorReportUploadState {}

//异常申报单上报失败
class FactorReportUploadError extends FactorReportUploadState {
  final String errorMessage;

  const FactorReportUploadError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
