import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/report/list/report_list.dart';
import 'package:pollution_source/util/constant.dart';

class ReportListBloc extends Bloc<ReportListEvent, ReportListState> {
  @override
  ReportListState get initialState => ReportListLoading();

  @override
  Stream<ReportListState> mapEventToState(ReportListEvent event) async* {
    try {
      if (event is ReportListLoad) {
        if (!event.isRefresh && currentState is ReportListLoaded) {
          //加载更多
          final reportList = await getReportList(
            currentPage: (currentState as ReportListLoaded).currentPage + 1,
            enterName: event.enterName,
            areaCode: event.areaCode,
            state: event.state,
          );
          yield ReportListLoaded(
            reportList: (currentState as ReportListLoaded).reportList + reportList,
            currentPage: (currentState as ReportListLoaded).currentPage + 1,
            hasNextPage:
                (currentState as ReportListLoaded).pageSize == reportList.length,
          );
        } else {
          //首次加载或刷新
          final reportList = await getReportList(
            enterName: event.enterName,
            areaCode: event.areaCode,
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
      }
    } catch (e) {
      yield ReportListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取异常申报单列表数据
  Future<List<Report>> getReportList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    state = '1',
  }) async {
    Response response = await DioUtils.instance
        .getDio()
        .get(HttpApi.reportList, queryParameters: {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'enterpriseName': enterName,
      'areaCode': areaCode,
      'status': state,
    });
    if (response.statusCode == ExceptionHandle.success &&
        response.data[Constant.responseCodeKey] ==
            ExceptionHandle.success_code) {
      return convertReportList(
          response.data[Constant.responseDataKey][Constant.responseListKey]);
    } else {
      throw Exception('${response.data[Constant.responseMessageKey]}');
    }
  }

  //格式化异常申报单数据
  List<Report> convertReportList(List<dynamic> jsonArray) {
    return jsonArray.map((json) {
      return Report.fromJson(json);
    }).toList();
  }
}
