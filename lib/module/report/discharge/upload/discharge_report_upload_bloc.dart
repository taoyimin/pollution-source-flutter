import 'package:bloc/bloc.dart';
import 'package:pollution_source/http/http.dart';
import 'package:meta/meta.dart';

import 'discharge_report_upload.dart';

class DischargeReportUploadBloc extends Bloc<DischargeReportUploadEvent, DischargeReportUploadState> {
  @override
  DischargeReportUploadState get initialState => DischargeReportUploadLoaded(reportUpload: DischargeReportUpload());

  @override
  Stream<DischargeReportUploadState> mapEventToState(DischargeReportUploadEvent event) async* {
    if (event is DischargeReportUploadLoad) {
      //加载界面
      yield* _mapReportUploadLoadToState(event);
    }else if(event is DischargeReportUploadSend){
      //上报异常申报信息
      yield* _mapReportUploadSendToState(event);
    }
  }

  Stream<DischargeReportUploadState> _mapReportUploadLoadToState(
      DischargeReportUploadLoad event) async* {
    yield DischargeReportUploadLoaded(reportUpload: event.reportUpload);
  }

  Stream<DischargeReportUploadState> _mapReportUploadSendToState(
      DischargeReportUploadSend event) async* {
    try {
      await _sendReportUpload(reportUpload: event.reportUpload);
      yield DischargeReportUploadSuccess();
    } catch (e) {
      yield DischargeReportUploadError(
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
      return DischargeReportUpload.fromJson(response.data[Constant.responseDataKey]);
    }else{
      Response response = await PythonDioUtils.instance.getDio().get(
        '${HttpApiPython.dischargeReports}/$reportId',
      );
      return DischargeReportUpload.fromJson(response.data);
    }*/
  }
}
