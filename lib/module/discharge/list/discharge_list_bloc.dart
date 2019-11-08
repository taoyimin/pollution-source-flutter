import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/res/constant.dart';

import 'discharge_list.dart';


class DischargeListBloc extends Bloc<DischargeListEvent, DischargeListState> {
  @override
  DischargeListState get initialState => DischargeListLoading();

  @override
  Stream<DischargeListState> mapEventToState(DischargeListEvent event) async* {
    if (event is DischargeListLoad) {
      //加载排口列表
      yield* _mapDischargeListLoadToState(event);
    }
  }

  Stream<DischargeListState> _mapDischargeListLoadToState(
      DischargeListLoad event) async* {
    try {
      final currentState = state;
      if (!event.isRefresh && currentState is DischargeListLoaded) {
        //加载更多
        final dischargeList = await _getDischargeList(
          currentPage: currentState.currentPage + 1,
          enterName: event.enterName,
          areaCode: event.areaCode,
          enterId: event.enterId,
        );
        yield DischargeListLoaded(
          dischargeList: currentState.dischargeList + dischargeList,
          currentPage: currentState.currentPage + 1,
          hasNextPage: currentState.pageSize == dischargeList.length,
        );
      } else {
        //首次加载或刷新
        final dischargeList = await _getDischargeList(
          enterName: event.enterName,
          areaCode: event.areaCode,
          enterId: event.enterId,
        );
        if (dischargeList.length == 0) {
          //没有数据
          yield DischargeListEmpty();
        } else {
          yield DischargeListLoaded(
            dischargeList: dischargeList,
            hasNextPage: Constant.defaultPageSize == dischargeList.length,
          );
        }
      }
    } catch (e) {
      yield DischargeListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取排口列表数据
  Future<List<Discharge>> _getDischargeList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    enterId = '',
  }) async {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      Response response = await DioUtils.instance.getDio().get(
        HttpApi.dischargeList,
        queryParameters: {
          'currentPage': currentPage,
          'pageSize': pageSize,
          'enterpriseName': enterName,
          'areaCode': areaCode,
          'enterId': enterId,
        },
      );
      return response.data[Constant.responseDataKey][Constant.responseListKey]
          .map<Discharge>((json) {
        return Discharge.fromJson(json);
      }).toList();
    } else {
      Response response = await DioUtils.instance.getDio().get(
        'discharges',
        queryParameters: {
          'currentPage': currentPage,
          'pageSize': pageSize,
          'enterName': enterName,
          'areaCode': areaCode,
          'enterId': enterId,
        },
      );
      return response.data[Constant.responseListKey].map<Discharge>((json) {
        return Discharge.fromJson(json);
      }).toList();
    }
  }
}
