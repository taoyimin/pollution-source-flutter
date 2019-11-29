import 'package:bloc/bloc.dart';
import 'package:pollution_source/http/http.dart';
import 'package:meta/meta.dart';

import 'long_stop_report_upload.dart';

class LongStopReportUploadBloc extends Bloc<LongStopReportUploadEvent, LongStopReportUploadState> {
  @override
  LongStopReportUploadState get initialState => LongStopReportUploadLoaded(reportUpload: LongStopReportUpload());

  @override
  Stream<LongStopReportUploadState> mapEventToState(LongStopReportUploadEvent event) async* {
    if (event is LongStopReportUploadLoad) {
      //加载界面
      yield* _mapReportUploadLoadToState(event);
    }else if(event is LongStopReportUploadSend){
      //上报异常申报信息
      yield* _mapReportUploadSendToState(event);
    }
  }

  Stream<LongStopReportUploadState> _mapReportUploadLoadToState(
      LongStopReportUploadLoad event) async* {
    yield LongStopReportUploadLoaded(reportUpload: event.reportUpload);
  }

  Stream<LongStopReportUploadState> _mapReportUploadSendToState(
      LongStopReportUploadSend event) async* {
    try {
      await _sendReportUpload(reportUpload: event.reportUpload);
      yield LongStopReportUploadSuccess();
    } catch (e) {
      yield LongStopReportUploadError(
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
      return LongStopReportUpload.fromJson(response.data[Constant.responseDataKey]);
    }else{
      Response response = await PythonDioUtils.instance.getDio().get(
        '${HttpApiPython.dischargeReports}/$reportId',
      );
      return LongStopReportUpload.fromJson(response.data);
    }*/
  }
}
