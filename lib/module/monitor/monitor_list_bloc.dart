import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'monitor_list.dart';
import 'package:pollution_source/util/constant.dart';

class MonitorListBloc extends Bloc<MonitorListEvent, MonitorListState> {
  @override
  MonitorListState get initialState => MonitorListLoading();

  @override
  Stream<MonitorListState> mapEventToState(MonitorListEvent event) async* {
    try {
      if (event is MonitorListLoad) {
        if (!event.isRefresh && currentState is MonitorListLoaded) {
          //加载更多
          final monitorList = await getMonitorList(
            currentPage: (currentState as MonitorListLoaded).currentPage + 1,
            enterName: event.enterName,
            areaCode: event.areaCode,
            status: event.status,
          );
          yield MonitorListLoaded(
            monitorList: (currentState as MonitorListLoaded).monitorList + monitorList,
            currentPage: (currentState as MonitorListLoaded).currentPage + 1,
            hasNextPage:
                (currentState as MonitorListLoaded).pageSize == monitorList.length,
          );
        } else {
          //首次加载或刷新
          final monitorList = await getMonitorList(
            enterName: event.enterName,
            areaCode: event.areaCode,
            status: event.status,
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
      }
    } catch (e) {
      yield MonitorListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取报警管理单列表数据
  Future<List<Monitor>> getMonitorList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    status = '1',
  }) async {
    Response response = await DioUtils.instance
        .getDio()
        .get(HttpApi.monitorList, queryParameters: {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'enterpriseName': enterName,
      'areaCode': areaCode,
      'status': status,
    });
    if (response.statusCode == ExceptionHandle.success &&
        response.data[Constant.responseCodeKey] ==
            ExceptionHandle.success_code) {
      return convertMonitorList(
          response.data[Constant.responseDataKey][Constant.responseListKey]);
    } else {
      throw Exception('${response.data[Constant.responseMessageKey]}');
    }
  }

  //格式化报警管理单数据
  List<Monitor> convertMonitorList(List<dynamic> jsonArray) {
    return jsonArray.map((json) {
      //TODO 自己造数据测试
      Map<String, dynamic> temp = Map();
      temp['enterName'] = '江西洪城水业环保南昌县分公司';
      temp['monitorName'] = '废水排放口';
      temp['address'] = '南昌县莲塘镇莲塘村';
      temp['number'] = '86377750110024';
      temp['monitorType'] = Random().nextInt(3);
      temp['monitorTypeName'] = '废水排口';
      temp['areaName'] = '南昌市 市辖区';
      json = temp;
      return Monitor.fromJson(json);
    }).toList();
  }
}
