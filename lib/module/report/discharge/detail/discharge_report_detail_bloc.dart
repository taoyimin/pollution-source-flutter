import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/res/constant.dart';

import 'discharge_report_detail.dart';

class DischargeReportDetailBloc extends Bloc<DischargeReportDetailEvent, DischargeReportDetailState> {
  @override
  DischargeReportDetailState get initialState => DischargeReportDetailLoading();

  @override
  Stream<DischargeReportDetailState> mapEventToState(DischargeReportDetailEvent event) async* {
    if (event is DischargeReportDetailLoad) {
      //加载异常申报单详情
      yield* _mapReportDetailLoadToState(event);
    }
  }

  Stream<DischargeReportDetailState> _mapReportDetailLoadToState(
      DischargeReportDetailLoad event) async* {
    try {
      final reportDetail = await _getReportDetail(reportId: event.reportId);
      yield DischargeReportDetailLoaded(reportDetail: reportDetail);
    } catch (e) {
      yield DischargeReportDetailError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取异常申报单详情
  Future<DischargeReportDetail> _getReportDetail({@required reportId}) async {
    if(SpUtil.getBool(Constant.spJavaApi, defValue: true)){
      Response response = await DioUtils.instance.getDio().get(
        HttpApiJava.reportDetail,
        queryParameters: {'stopApplyId': reportId},
      );
      return DischargeReportDetail.fromJson(response.data[Constant.responseDataKey]);
    }else{
      Response response = await DioUtils.instance.getDio().get(
        '${HttpApiPython.dischargeReports}/$reportId',
      );
      return DischargeReportDetail.fromJson(response.data);
    }
  }
}
