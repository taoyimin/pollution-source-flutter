import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/res/constant.dart';

import 'discharge_report_list.dart';

class DischargeReportListBloc extends Bloc<DischargeReportListEvent, DischargeReportListState> {
  @override
  DischargeReportListState get initialState => DischargeReportListLoading();

  @override
  Stream<DischargeReportListState> mapEventToState(DischargeReportListEvent event) async* {
    if (event is DischargeReportListLoad) {
      //加载异常申报单列表
      yield* _mapReportListLoadToState(event);
    }
  }

  Stream<DischargeReportListState> _mapReportListLoadToState(
      DischargeReportListLoad event) async* {
    try {
      final currentState = state;
      if (!event.isRefresh && currentState is DischargeReportListLoaded) {
        //加载更多
        final reportList = await _getReportList(
          currentPage: currentState.currentPage + 1,
          enterName: event.enterName,
          areaCode: event.areaCode,
          enterId: event.enterId,
          dischargeId: event.dischargeId,
          monitorId: event.monitorId,
          state: event.state,
        );
        yield DischargeReportListLoaded(
          reportList: currentState.reportList + reportList,
          currentPage: currentState.currentPage + 1,
          hasNextPage: currentState.pageSize == reportList.length,
        );
      } else {
        //首次加载或刷新
        final reportList = await _getReportList(
          enterName: event.enterName,
          areaCode: event.areaCode,
          enterId: event.enterId,
          dischargeId: event.dischargeId,
          monitorId: event.monitorId,
          state: event.state,
        );
        if (reportList.length == 0) {
          //没有数据
          yield DischargeReportListEmpty();
        } else {
          yield DischargeReportListLoaded(
            reportList: reportList,
            hasNextPage: Constant.defaultPageSize == reportList.length,
          );
        }
      }
    } catch (e) {
      yield DischargeReportListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取异常申报单列表数据
  Future<List<DischargeReport>> _getReportList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    enterId = '',
    dischargeId = '',
    monitorId = '',
    state = '',
  }) async {
    if(SpUtil.getBool(Constant.spJavaApi, defValue: true)){
      Response response = await DioUtils.instance.getDio().get(
        HttpApiJava.reportList,
        queryParameters: {
          'currentPage': currentPage,
          'pageSize': pageSize,
          'enterpriseName': enterName,
          'areaCode': areaCode,
          'enterId': enterId,
          'hasFactorCode': '0',
          'QIsReview': state,
        },
      );
      return response.data[Constant.responseDataKey][Constant.responseListKey]
          .map<DischargeReport>((json) {
        return DischargeReport.fromJson(json);
      }).toList();
    }else{
      Response response = await DioUtils.instance.getDio().get(
        HttpApiPython.dischargeReports,
        queryParameters: {
          'currentPage': currentPage,
          'pageSize': pageSize,
          'enterName': enterName,
          'areaCode': areaCode,
          'enterId': enterId,
          'dischargeId': dischargeId,
          'monitorId': monitorId,
          'state': state,
        },
      );
      return response.data[Constant.responseListKey]
          .map<DischargeReport>((json) {
        return DischargeReport.fromJson(json);
      }).toList();
    }
  }
}
