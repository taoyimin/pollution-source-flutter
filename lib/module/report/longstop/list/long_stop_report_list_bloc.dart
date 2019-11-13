import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/res/constant.dart';

import 'long_stop_report_list.dart';

class LongStopReportListBloc extends Bloc<LongStopReportListEvent, LongStopReportListState> {
  @override
  LongStopReportListState get initialState => LongStopReportListLoading();

  @override
  Stream<LongStopReportListState> mapEventToState(LongStopReportListEvent event) async* {
    if (event is LongStopReportListLoad) {
      //加载异常申报单列表
      yield* _mapReportListLoadToState(event);
    }
  }

  Stream<LongStopReportListState> _mapReportListLoadToState(
      LongStopReportListLoad event) async* {
    try {
      final currentState = state;
      if (!event.isRefresh && currentState is LongStopReportListLoaded) {
        //加载更多
        final reportList = await _getReportList(
          currentPage: currentState.currentPage + 1,
          enterName: event.enterName,
          areaCode: event.areaCode,
          enterId: event.enterId,
        );
        yield LongStopReportListLoaded(
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
        );
        if (reportList.length == 0) {
          //没有数据
          yield LongStopReportListEmpty();
        } else {
          yield LongStopReportListLoaded(
            reportList: reportList,
            hasNextPage: Constant.defaultPageSize == reportList.length,
          );
        }
      }
    } catch (e) {
      yield LongStopReportListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取异常申报单列表数据
  Future<List<LongStopReport>> _getReportList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    enterId = '',
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
          'hasLongStopCode': '1',
          'QIsReview': state,
        },
      );
      return response.data[Constant.responseDataKey][Constant.responseListKey]
          .map<LongStopReport>((json) {
        return LongStopReport.fromJson(json);
      }).toList();
    }else{
      Response response = await DioUtils.instance.getDio().get(
        HttpApiPython.longStopReports,
        queryParameters: {
          'currentPage': currentPage,
          'pageSize': pageSize,
          'enterName': enterName,
          'areaCode': areaCode,
          'enterId': enterId,
        },
      );
      return response.data[Constant.responseListKey]
          .map<LongStopReport>((json) {
        return LongStopReport.fromJson(json);
      }).toList();
    }
  }
}
