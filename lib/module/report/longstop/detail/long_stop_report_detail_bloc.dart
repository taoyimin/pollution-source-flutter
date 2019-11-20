import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:meta/meta.dart';

import 'long_stop_report_detail.dart';

class LongStopReportDetailBloc extends Bloc<LongStopReportDetailEvent, LongStopReportDetailState> {
  @override
  LongStopReportDetailState get initialState => LongStopReportDetailLoading();

  @override
  Stream<LongStopReportDetailState> mapEventToState(LongStopReportDetailEvent event) async* {
    if (event is LongStopReportDetailLoad) {
      //加载异常申报单详情
      yield* _mapReportDetailLoadToState(event);
    }
  }

  Stream<LongStopReportDetailState> _mapReportDetailLoadToState(
      LongStopReportDetailLoad event) async* {
    try {
      final reportDetail = await _getReportDetail(reportId: event.reportId);
      yield LongStopReportDetailLoaded(reportDetail: reportDetail);
    } catch (e) {
      yield LongStopReportDetailError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取异常申报单详情
  Future<LongStopReportDetail> _getReportDetail({@required reportId}) async {
    if(SpUtil.getBool(Constant.spJavaApi, defValue: true)){
      Response response = await JavaDioUtils.instance.getDio().get(
        HttpApiJava.reportDetail,
        queryParameters: {'stopApplyId': reportId},
      );
      return LongStopReportDetail.fromJson(response.data[Constant.responseDataKey]);
    }else{
      Response response = await PythonDioUtils.instance.getDio().get(
        '${HttpApiPython.longStopReports}/$reportId',
      );
      return LongStopReportDetail.fromJson(response.data);
    }
  }
}
