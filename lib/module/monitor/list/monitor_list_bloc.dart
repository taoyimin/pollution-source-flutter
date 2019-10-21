import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/util/constant.dart';

import 'package:pollution_source/module/monitor/list/monitor_list.dart';

class MonitorListBloc extends Bloc<MonitorListEvent, MonitorListState> {
  @override
  MonitorListState get initialState => MonitorListLoading();

  @override
  Stream<MonitorListState> mapEventToState(MonitorListEvent event) async* {
    if (event is MonitorListLoad) {
      //加载监控点列表
      yield* _mapMonitorListLoadToState(event);
    }
  }

  Stream<MonitorListState> _mapMonitorListLoadToState(
      MonitorListLoad event) async* {
    try {
      final currentState = state;
      if (!event.isRefresh && currentState is MonitorListLoaded) {
        //加载更多
        final monitorList = await _getMonitorList(
          currentPage: currentState.currentPage + 1,
          enterName: event.enterName,
          areaCode: event.areaCode,
          monitorType: event.monitorType,
          state: event.state,
        );
        yield MonitorListLoaded(
          monitorList: currentState.monitorList + monitorList,
          currentPage: currentState.currentPage + 1,
          hasNextPage: currentState.pageSize == monitorList.length,
        );
      } else {
        //首次加载或刷新
        final monitorList = await _getMonitorList(
          enterName: event.enterName,
          areaCode: event.areaCode,
          monitorType: event.monitorType,
          state: event.state,
        );
        if (monitorList.length == 0) {
          //没有数据
          yield MonitorListEmpty();
        } else {
          yield MonitorListLoaded(
            monitorList: monitorList,
            hasNextPage: Constant.defaultPageSize == monitorList.length,
          );
        }
      }
    } catch (e) {
      yield MonitorListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取监控点列表数据
  Future<List<Monitor>> _getMonitorList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    monitorType = '',
    state = '',
  }) async {
    Response response = await DioUtils.instance.getDio().get(
      HttpApi.monitorList,
      queryParameters: {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterpriseName': enterName,
        'areaCode': areaCode,
        'monitorType': monitorType,
        'state': state,
      },
    );
    return response.data[Constant.responseDataKey][Constant.responseListKey]
        .map<Monitor>((json) {
      return Monitor.fromJson(json);
    }).toList();
  }
}
