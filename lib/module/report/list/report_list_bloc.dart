import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/report/list/report_list.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:meta/meta.dart';

class ReportListBloc extends Bloc<ReportListEvent, ReportListState> {
  @override
  ReportListState get initialState => ReportListLoading();

  @override
  Stream<ReportListState> mapEventToState(ReportListEvent event) async* {
    if (event is ReportListLoad) {
      //加载异常申报单列表
      yield* _mapReportListLoadToState(event);
    }
  }

  Stream<ReportListState> _mapReportListLoadToState(
      ReportListLoad event) async* {
    try {
      final currentState = state;
      if (!event.isRefresh && currentState is ReportListLoaded) {
        //加载更多
        final reportList = await _getReportList(
          currentPage: currentState.currentPage + 1,
          enterName: event.enterName,
          areaCode: event.areaCode,
          enterId: event.enterId,
          type: event.type,
          state: event.state,
        );
        yield ReportListLoaded(
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
          type: event.type,
          state: event.state,
        );
        if (reportList.length == 0) {
          //没有数据
          yield ReportListEmpty();
        } else {
          yield ReportListLoaded(
            reportList: reportList,
            hasNextPage: Constant.defaultPageSize == reportList.length,
          );
        }
      }
    } catch (e) {
      yield ReportListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取异常申报单列表数据
  Future<List<Report>> _getReportList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    enterId = '',
    @required type,
    state = '',
  }) async {
    Response response = await DioUtils.instance.getDio().get(
      HttpApi.reportList,
      queryParameters: {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterpriseName': enterName,
        'areaCode': areaCode,
        'enterId': enterId,
        'hasFactorCode': type,
        'QIsReview': state,
      },
    );
    return response.data[Constant.responseDataKey][Constant.responseListKey]
        .map<Report>((json) {
      return Report.fromJson(json);
    }).toList();
  }
}
