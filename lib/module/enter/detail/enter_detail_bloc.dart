import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:meta/meta.dart';

import 'enter_detail.dart';

class EnterDetailBloc extends Bloc<EnterDetailEvent, EnterDetailState> {
  @override
  EnterDetailState get initialState => EnterDetailLoading();

  @override
  Stream<EnterDetailState> mapEventToState(EnterDetailEvent event) async* {
    if (event is EnterDetailLoad) {
      yield* _mapEnterDetailLoadToState(event);
    }
  }

  Stream<EnterDetailState> _mapEnterDetailLoadToState(
      EnterDetailLoad event) async* {
    try {
      //加载企业详情
      final enterDetail = await _getEnterDetail(enterId: event.enterId);
      yield EnterDetailLoaded(enterDetail: enterDetail);
    } catch (e) {
      yield EnterDetailError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取企业详情
  Future<EnterDetail> _getEnterDetail({@required enterId}) async {
    if(SpUtil.getBool(Constant.spJavaApi, defValue: true)){
      Response response = await JavaDioUtils.instance.getDio().get(
        HttpApiJava.enterDetail,
        queryParameters: {'enter_id': enterId},
      );
      return EnterDetail.fromJson(response.data[Constant.responseDataKey]);
    }else{
      Response response = await PythonDioUtils.instance.getDio().get(
        '${HttpApiPython.enters}/$enterId',
      );
      return EnterDetail.fromJson(response.data);
    }
  }
}
