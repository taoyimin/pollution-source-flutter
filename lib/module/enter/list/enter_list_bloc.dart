import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/enter/list/enter_list.dart';
import 'package:pollution_source/res/constant.dart';

class EnterListBloc extends Bloc<EnterListEvent, EnterListState> {
  @override
  EnterListState get initialState => EnterListLoading();

  @override
  Stream<EnterListState> mapEventToState(EnterListEvent event) async* {
    if (event is EnterListLoad) {
      //加载企业列表
      yield* _mapEnterListLoadToState(event);
    }
  }

  Stream<EnterListState> _mapEnterListLoadToState(EnterListLoad event) async* {
    try {
      final currentState = state;
      if (!event.isRefresh && currentState is EnterListLoaded) {
        //加载更多
        final List<Enter> enterList = await _getEnterList(
          currentPage: currentState.currentPage + 1,
          enterName: event.enterName,
          areaCode: event.areaCode,
          state: event.state,
          enterType: event.enterType,
          attentionLevel: event.attentionLevel,
        );
        yield EnterListLoaded(
          enterList: currentState.enterList + enterList,
          currentPage: currentState.currentPage + 1,
          hasNextPage: currentState.pageSize == enterList.length,
        );
      } else {
        //首次加载或刷新
        final List<Enter> enterList = await _getEnterList(
          enterName: event.enterName,
          areaCode: event.areaCode,
          state: event.state,
          enterType: event.enterType,
          attentionLevel: event.attentionLevel,
        );
        if (enterList.length == 0) {
          //没有数据
          yield EnterListEmpty();
        } else {
          yield EnterListLoaded(
            enterList: enterList,
            hasNextPage: Constant.defaultPageSize == enterList.length,
          );
        }
      }
    } catch (e) {
      yield EnterListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取企业列表数据
  Future<List<Enter>> _getEnterList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    state = '',
    enterType = '',
    attentionLevel = '',
  }) async {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      Response response = await DioUtils.instance
          .getDio()
          .get(HttpApi.enterList, queryParameters: {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterpriseName': enterName,
        'areaCode': areaCode,
        'state': state == '1' ? 'online' : '',
        'enterpriseType': enterType,
        'attenLevel': attentionLevel,
      });
      return response.data[Constant.responseDataKey][Constant.responseListKey]
          .map<Enter>((json) {
        return Enter.fromJson(json);
      }).toList();
    } else {
      Response response =
          await DioUtils.instance.getDio().get('enters', queryParameters: {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'enterName': enterName,
        'areaCode': areaCode,
        'state': state,
        'enterType': enterType,
        'attentionLevel': attentionLevel,
      });
      return response.data[Constant.responseListKey].map<Enter>((json) {
        return Enter.fromJson(json);
      }).toList();
    }
  }
}
