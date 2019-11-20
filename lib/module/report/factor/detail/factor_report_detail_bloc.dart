import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:meta/meta.dart';

import 'factor_report_detail.dart';

class FactorReportDetailBloc extends Bloc<FactorReportDetailEvent, FactorReportDetailState> {
  @override
  FactorReportDetailState get initialState => FactorReportDetailLoading();

  @override
  Stream<FactorReportDetailState> mapEventToState(FactorReportDetailEvent event) async* {
    if (event is FactorReportDetailLoad) {
      //加载异常申报单详情
      yield* _mapReportDetailLoadToState(event);
    }
  }

  Stream<FactorReportDetailState> _mapReportDetailLoadToState(
      FactorReportDetailLoad event) async* {
    try {
      final reportDetail = await _getReportDetail(reportId: event.reportId);
      yield FactorReportDetailLoaded(reportDetail: reportDetail);
    } catch (e) {
      yield FactorReportDetailError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取异常申报单详情
  Future<FactorReportDetail> _getReportDetail({@required reportId}) async {
    if(SpUtil.getBool(Constant.spJavaApi, defValue: true)){
      Response response = await JavaDioUtils.instance.getDio().get(
        HttpApiJava.reportDetail,
        queryParameters: {'stopApplyId': reportId},
      );
      return FactorReportDetail.fromJson(response.data[Constant.responseDataKey]);
    }else{
      Response response = await PythonDioUtils.instance.getDio().get(
        '${HttpApiPython.factorReports}/$reportId',
      );
      return FactorReportDetail.fromJson(response.data);
    }
  }
}
