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
    if (event is MonitorDetailLoad) {
      //加载监控点详情
      yield* _mapMonitorDetailLoadToState(event);
    } else if (event is UpdateChartData) {
      //更新监测数据
      yield* _mapUpdateChartDataToState(event);
    } else if (event is UpdateChartConfig) {
      //更新图表配置
      yield* _mapUpdateChartConfigToState(event);
    }
  }

  Stream<MonitorDetailState> _mapMonitorDetailLoadToState(
      MonitorDetailLoad event) async* {
    try {
      final monitorDetail = await _getMonitorDetail(monitorId: event.monitorId);
      yield MonitorDetailLoaded(monitorDetail: monitorDetail);
    } catch (e) {
      yield MonitorDetailError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
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

  Stream<MonitorDetailState> _mapUpdateChartConfigToState(
      UpdateChartConfig event) async* {
    final currentState = state;
    if (currentState is MonitorDetailLoaded) {
      yield MonitorDetailLoaded(
        monitorDetail: currentState.monitorDetail
            .copyWith(isCurved: event.isCurved, showDotData: event.showDotData),
      );
    }
  }

  //获取监控点详情
  Future<MonitorDetail> _getMonitorDetail({@required monitorId}) async {
    Response response = await DioUtils.instance.getDio().get(
      HttpApi.monitorDetail,
      queryParameters: {'monitorId': monitorId},
    );
    return MonitorDetail.fromJson(response.data[Constant.responseDataKey]);
  }
}
