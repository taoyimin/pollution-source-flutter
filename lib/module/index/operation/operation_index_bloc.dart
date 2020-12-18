import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:bloc/bloc.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/compat_utils.dart';
import 'package:pollution_source/util/config_utils.dart';

import 'operation_index_event.dart';
import 'operation_index_state.dart';

class IndexBloc extends Bloc<IndexEvent, IndexState> {
  @override
  IndexState get initialState => IndexLoading();

  @override
  Stream<IndexState> mapEventToState(IndexEvent event) async* {
    if (event is Load) {
      try {
        Response response = await CompatUtils.getDio()
            .get(CompatUtils.getApi(HttpApi.operationIndex));
        // 巡检任务统计
        List<Meta> inspectionStatisticsList;
        if (ConfigUtils.showRoutineInspection()) {
          inspectionStatisticsList = await _convertInspectionStatistics(
              response.data[Constant.responseDataKey]['processedCount']);
        }
        // 污染源企业统计
        List<Meta> pollutionEnterStatisticsList =
            await _convertPollutionEnterStatistics(response
                .data[Constant.responseDataKey]['enterpriseCountMonitorCount']);
        Response orderResponse =
            await CompatUtils.getDio().get('commonSupervise/superviseCount');
        // 报警管理单统计
        List<Meta> orderStatisticsList =
            await _convertOrderStatistics(orderResponse.data);
        yield IndexLoaded(
          pollutionEnterStatisticsList: pollutionEnterStatisticsList,
          orderStatisticsList: orderStatisticsList,
          inspectionStatisticsList: inspectionStatisticsList,
        );
      } catch (e) {
        yield IndexError(errorMessage: ExceptionHandle.handleException(e).msg);
      }
    }
  }
}

/// 格式化污染源企业统计
Future<List<Meta>> _convertPollutionEnterStatistics(dynamic json) async {
  bool show = true;
  if (!show) {
    return [];
  } else {
    return [
      Meta(
        title: '企业总数',
        imagePath: 'assets/images/icon_pollution_all_enter.png',
        color: Color.fromRGBO(77, 167, 248, 1),
        content: json['enterCount'].toString(),
        router: '${Routes.enterList}',
      ),
      Meta(
        title: '重点企业',
        imagePath: 'assets/images/icon_pollution_point_enter.png',
        color: Color.fromRGBO(241, 190, 67, 1),
        content: json['Attention_COUNT'].toString(),
        router: '${Routes.enterList}?attentionLevel=1',
      ),
      Meta(
        title: '在线企业',
        imagePath: 'assets/images/icon_pollution_online_enter.png',
        color: Color.fromRGBO(136, 191, 89, 1),
        content: json['onlineCount'].toString(),
        router: '${Routes.enterList}?state=1',
      ),
      Meta(
        title: '废水企业',
        imagePath: 'assets/images/icon_pollution_water_enter.png',
        color: Color.fromRGBO(0, 188, 212, 1),
        content: json['waterCount'].toString(),
        router: '${Routes.enterList}?enterType=2',
      ),
      Meta(
        title: '废气企业',
        imagePath: 'assets/images/icon_pollution_air_enter.png',
        color: Color.fromRGBO(255, 87, 34, 1),
        content: json['airCount'].toString(),
        router: '${Routes.enterList}?enterType=3',
      ),
      Meta(
        title: '水气企业',
        imagePath: 'assets/images/icon_pollution_air_water.png',
        color: Color.fromRGBO(137, 137, 137, 1),
        content: json['waterAirCount'].toString(),
        router: '${Routes.enterList}?enterType=4',
      ),
      Meta(
        title: '废水排口',
        imagePath: 'assets/images/icon_pollution_water_outlet.png',
        color: Color.fromRGBO(63, 81, 181, 1),
        content: json['outletType2'].toString(),
        router: '${Routes.dischargeList}?dischargeType=outletType2',
      ),
      Meta(
        title: '废气排口',
        imagePath: 'assets/images/icon_pollution_air_outlet.png',
        color: Color.fromRGBO(233, 30, 99, 1),
        content: json['outletType3'].toString(),
        router: '${Routes.dischargeList}?dischargeType=outletType3',
      ),
      Meta(
        title: '许可证企业',
        imagePath: 'assets/images/icon_pollution_licence_enter.png',
        color: Color.fromRGBO(179, 129, 127, 1),
        content: json['licenseCount'].toString(),
        router: '${Routes.enterList}?enterType=5',
      ),
    ];
  }
}

/// 格式化巡检任务统计
Future<List<Meta>> _convertInspectionStatistics(dynamic json) async {
  bool show = true;
  if (!show) {
    return [];
  } else {
    return [
      Meta(
        title: '待巡检任务数',
        imagePath: 'assets/images/button_bg_blue.png',
        content: json['toBeProcessedC'].toString(),
        router: '${Routes.routineInspectionList}?state=1',
      ),
      Meta(
        title: '超期任务数',
        imagePath: 'assets/images/button_bg_pink.png',
        content: json['toBePrcoessedO'].toString(),
        router: '${Routes.routineInspectionList}?state=2',
      ),
      Meta(
        title: '已巡检任务数',
        imagePath: 'assets/images/button_bg_green.png',
        content: json['processedC'].toString(),
      ),
    ];
  }
}

/// 格式化督办单任务统计
Future<List<Meta>> _convertOrderStatistics(dynamic json) async {
  bool show = true;
  if (!show) {
    return [];
  } else {
    return [
      Meta(
        title: '未办结',
        imagePath: 'assets/images/button_image2.png',
        backgroundPath: 'assets/images/button_bg_lightblue.png',
        content: json['orderIncompleteCount'].toString(),
        router: '${Routes.orderList}?alarmState=00',
      ),
      Meta(
        title: '已办结',
        imagePath: 'assets/images/button_image1.png',
        backgroundPath: 'assets/images/button_bg_green.png',
        content: json['orderCompleteCount'].toString(),
        router: '${Routes.orderList}?alarmState=50',
      ),
      Meta(
        title: '全部',
        imagePath: 'assets/images/button_image4.png',
        backgroundPath: 'assets/images/button_bg_pink.png',
        content: json['superviseCount'].toString(),
        router: '${Routes.orderList}',
      ),
    ];
  }
}
