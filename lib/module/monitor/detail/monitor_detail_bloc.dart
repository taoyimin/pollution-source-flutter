import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/util/constant.dart';
import 'package:meta/meta.dart';

import 'monitor_detail.dart';

class MonitorDetailBloc extends Bloc<MonitorDetailEvent, MonitorDetailState> {
  @override
  MonitorDetailState get initialState => MonitorDetailLoading();

  @override
  Stream<MonitorDetailState> mapEventToState(MonitorDetailEvent event) async* {
    try {
      if (event is MonitorDetailLoad) {
        //加载监控点详情
        final monitorDetail = await getMonitorDetail(
          monitorId: event.monitorId,
        );
        yield MonitorDetailLoaded(
          monitorDetail: monitorDetail,
        );
      }
    } catch (e) {
      yield MonitorDetailError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }
  //获取监控点详情
  Future<MonitorDetail> getMonitorDetail({
    @required monitorId,
  }) async {
    Response response = await DioUtils.instance
        .getDio()
        .get(HttpApi.monitorDetail, queryParameters: {
      'monitorId': monitorId,
    });
    return MonitorDetail.fromJson(response.data[Constant.responseDataKey]);
  }
}
