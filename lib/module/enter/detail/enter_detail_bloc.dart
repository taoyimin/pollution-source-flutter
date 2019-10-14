import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/util/constant.dart';
import 'package:meta/meta.dart';

import 'enter_detail.dart';

class EnterDetailBloc extends Bloc<EnterDetailEvent, EnterDetailState> {
  @override
  EnterDetailState get initialState => EnterDetailLoading();

  @override
  Stream<EnterDetailState> mapEventToState(EnterDetailEvent event) async* {
    try {
      if (event is EnterDetailLoad) {
        //加载企业详情
        final enterDetail = await getEnterDetail(
          enterId: event.enterId,
        );
        yield EnterDetailLoaded(
          enterDetail: enterDetail,
        );
      }
    } catch (e) {
      yield EnterDetailError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }
  //获取企业详情
  Future<EnterDetail> getEnterDetail({
    @required enterId,
  }) async {
    Response response = await DioUtils.instance
        .getDio()
        .get(HttpApi.enterDetail, queryParameters: {
      'enterId': enterId,
    });
    return EnterDetail.fromJson(response.data[Constant.responseDataKey]);
  }
}
