import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'enter_list.dart';
import 'package:pollution_source/util/constant.dart';

class EnterListBloc extends Bloc<EnterListEvent, EnterListState> {
  @override
  EnterListState get initialState => EnterListLoading();

  @override
  Stream<EnterListState> mapEventToState(EnterListEvent event) async* {
    try {
      if (event is EnterListLoad) {
        if (!event.isRefresh && currentState is EnterListLoaded) {
          //加载更多
          final enterList = await getEnterList(
            currentPage: (currentState as EnterListLoaded).currentPage + 1,
            enterName: event.enterName,
            areaCode: event.areaCode,
            state: event.state,
            enterType: event.enterType,
            attentionLevel: event.attentionLevel,
          );
          yield EnterListLoaded(
            enterList: (currentState as EnterListLoaded).enterList + enterList,
            currentPage: (currentState as EnterListLoaded).currentPage + 1,
            hasNextPage:
                (currentState as EnterListLoaded).pageSize == enterList.length,
          );
        } else {
          //首次加载或刷新
          final enterList = await getEnterList(
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
      }
    } catch (e) {
      yield EnterListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取企业列表数据
  Future<List<Enter>> getEnterList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterName = '',
    areaCode = '',
    state = '',
    enterType = '',
    attentionLevel = '',
  }) async {
    Response response = await DioUtils.instance
        .getDio()
        .get(HttpApi.enterList, queryParameters: {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'enterpriseName': enterName,
      'areaCode': areaCode,
      'state': state,
      'enterpriseType': enterType,
      'attenlevel': attentionLevel,
    });
    return convertEnterList(
        response.data[Constant.responseDataKey][Constant.responseListKey]);
  }

  //格式化企业数据
  List<Enter> convertEnterList(List<dynamic> jsonArray) {
    return jsonArray.map((json) {
      //TODO 自己造数据测试
      Map<String, dynamic> temp = Map();
      temp['enterprisename'] = '深圳市腾讯计算机系统有限公司';
      temp['address'] = '深圳市南山区高新区高新南一路飞亚达大厦5-10楼';
      temp['isImportant'] = true;
      temp['imagePath'] = 'assets/images/logo_tencent.png';
      temp['industryType'] = '计算机软、硬件的设计、技术开发、销售';
      temp['enterLabel'] = '废水排口 废气排口 雨水';
      json = temp;
      return Enter.fromJson(json);
    }).toList();
  }
}
