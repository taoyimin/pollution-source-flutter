import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:meta/meta.dart';

import 'report_detail.dart';

class ReportDetailBloc extends Bloc<ReportDetailEvent, ReportDetailState> {
  @override
  ReportDetailState get initialState => ReportDetailLoading();

  @override
  Stream<ReportDetailState> mapEventToState(ReportDetailEvent event) async* {
    if (event is ReportDetailLoad) {
      //加载异常申报单详情
      yield* _mapReportDetailLoadToState(event);
    }
  }

  Stream<ReportDetailState> _mapReportDetailLoadToState(
      ReportDetailLoad event) async* {
    try {
      final reportDetail = await _getReportDetail(reportId: event.reportId);
      yield ReportDetailLoaded(reportDetail: reportDetail);
    } catch (e) {
      yield ReportDetailError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取异常申报单详情
  Future<ReportDetail> _getReportDetail({@required reportId}) async {
    Response response = await DioUtils.instance.getDio().get(
      HttpApi.reportDetail,
      queryParameters: {'reportId': reportId},
    );
    return ReportDetail.fromJson(response.data[Constant.responseDataKey]);
  }
}
