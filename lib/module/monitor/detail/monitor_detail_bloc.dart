import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/common/common_model.dart';
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
        yield* _mapMonitorDetailLoadToState(event);
      } else if (event is UpdateChartData) {
        //更新监测数据
        yield* _mapUpdateChartDataToState(event);
      }
    } catch (e) {
      yield MonitorDetailError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  Stream<MonitorDetailState> _mapMonitorDetailLoadToState(
      MonitorDetailLoad event) async* {
    final monitorDetail = await getMonitorDetail(monitorId: event.monitorId);
    yield MonitorDetailLoaded(monitorDetail: monitorDetail);
  }

  Stream<MonitorDetailState> _mapUpdateChartDataToState(
      UpdateChartData event) async* {
    final currentState = state;
    if (currentState is MonitorDetailLoaded) {
      final List<ChartData> chartDataList =
          currentState.monitorDetail.chartDataList.map(
        (chartData) {
          return chartData.factorName == event.chartData.factorName
              ? event.chartData
              : chartData;
        },
      ).toList();
      yield MonitorDetailLoaded(
        monitorDetail:
            currentState.monitorDetail.copyWith(chartDataList: chartDataList),
      );
    }
  }

  //获取监控点详情
  Future<MonitorDetail> getMonitorDetail({@required monitorId}) async {
    Response response = await DioUtils.instance.getDio().get(
      HttpApi.monitorDetail,
      queryParameters: {
        'monitorId': monitorId,
      },
    );
    return MonitorDetail.fromJson(response.data[Constant.responseDataKey]);
  }
}
