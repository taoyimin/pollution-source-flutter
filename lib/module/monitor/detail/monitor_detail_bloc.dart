import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:meta/meta.dart';

import 'monitor_detail.dart';

class MonitorDetailBloc extends Bloc<MonitorDetailEvent, MonitorDetailState> {
  final DetailRepository detailRepository;

  MonitorDetailBloc({@required this.detailRepository})
      : assert(detailRepository != null);

  @override
  MonitorDetailState get initialState =>
      MonitorDetailLoading(cancelToken: null);

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
      CancelToken cancelToken = CancelToken();
      MonitorDetailLoading(cancelToken: cancelToken);
      final monitorDetail = await detailRepository.request(
          detailId: event.monitorId, cancelToken: cancelToken);
      yield MonitorDetailLoaded(
        monitorDetail: monitorDetail,
        isCurved: SpUtil.getBool(Constant.spIsCurved, defValue: true),
        showDotData: SpUtil.getBool(Constant.spShowDotData, defValue: true),
      );
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
        isCurved: SpUtil.getBool(Constant.spIsCurved, defValue: true),
        showDotData: SpUtil.getBool(Constant.spShowDotData, defValue: true),
      );
    }
  }

  Stream<MonitorDetailState> _mapUpdateChartConfigToState(
      UpdateChartConfig event) async* {
    final currentState = state;
    if (currentState is MonitorDetailLoaded) {
      yield MonitorDetailLoaded(
        monitorDetail: currentState.monitorDetail,
        isCurved: event.isCurved,
        showDotData: event.showDotData,
      );
    }
  }
}
