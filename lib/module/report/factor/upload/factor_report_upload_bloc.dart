import 'package:bloc/bloc.dart';
import 'package:pollution_source/http/http.dart';
import 'package:meta/meta.dart';

import 'factor_report_upload.dart';

class FactorReportUploadBloc extends Bloc<FactorReportUploadEvent, FactorReportUploadState> {
  @override
  FactorReportUploadState get initialState => FactorReportUploadLoaded(reportUpload: FactorReportUpload());

  @override
  Stream<FactorReportUploadState> mapEventToState(FactorReportUploadEvent event) async* {
    if (event is FactorReportUploadLoad) {
      //加载界面
      yield* _mapReportUploadLoadToState(event);
    }else if(event is FactorReportUploadSend){
      //上报异常申报信息
      yield* _mapReportUploadSendToState(event);
    }
  }

  Stream<FactorReportUploadState> _mapReportUploadLoadToState(
      FactorReportUploadLoad event) async* {
    yield FactorReportUploadLoaded(reportUpload: event.reportUpload);
  }

  Stream<FactorReportUploadState> _mapReportUploadSendToState(
      FactorReportUploadSend event) async* {
    try {
      await _sendReportUpload(reportUpload: event.reportUpload);
      yield FactorReportUploadSuccess();
    } catch (e) {
      yield FactorReportUploadError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取异常申报单详情
  Future<Null> _sendReportUpload({@required reportUpload}) async {
    return;
    /*if(SpUtil.getBool(Constant.spJavaApi, defValue: true)){
      Response response = await JavaDioUtils.instance.getDio().get(
        HttpApiJava.reportDetail,
        queryParameters: {'stopApplyId': reportId},
      );
      return FactorReportUpload.fromJson(response.data[Constant.responseDataKey]);
    }else{
      Response response = await PythonDioUtils.instance.getDio().get(
        '${HttpApiPython.dischargeReports}/$reportId',
      );
      return FactorReportUpload.fromJson(response.data);
    }*/
  }
}
