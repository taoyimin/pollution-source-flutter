import 'dart:ui';

import 'package:dio/dio.dart';

import 'index.dart';
import 'package:bloc/bloc.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/util/constant.dart';

class IndexBloc extends Bloc<IndexEvent, IndexState> {
  @override
  IndexState get initialState => IndexLoading();

  @override
  Stream<IndexState> mapEventToState(IndexEvent event) async* {
    if (event is Load) {
      try {
        Response response = await DioUtils.instance.getDio().get(HttpApi.index);
        //空气质量统计
        AqiStatistics aqiStatistics = await convertAqiStatistics(
            response.data[Constant.responseDataKey][Constant.aqiStatisticsKey]);
        //空气质量考核(过滤无效数据)
        List<AqiExamine> aqiExamineList = await Future.wait([
          convertAqiExamine(Constant.pm25ExamineKey,
              response.data[Constant.responseDataKey][Constant.pm25ExamineKey]),
          convertAqiExamine(Constant.aqiExamineKey,
              response.data[Constant.responseDataKey][Constant.aqiExamineKey]),
        ]).then((aqiExamineList) =>
            aqiExamineList.skipWhile((AqiExamine aqiExamine) {
              return !aqiExamine.show;
            }).toList());
        //水环境质量情况(过滤无效数据)
        //TODO 缺少两条数据
        /*        convertSurfaceWater(Constant.countyWaterKey,
            response.data[Constant.responseDataKey][Constant.countyWaterKey]),
    convertSurfaceWater(Constant.waterWaterKey,
    response.data[Constant.responseDataKey][Constant.waterWaterKey]),*/
        List<WaterStatistics> waterStatisticsList = await Future.wait([
          convertSurfaceWater(Constant.stateWaterKey,
              response.data[Constant.responseDataKey][Constant.stateWaterKey]),
          convertSurfaceWater(
              Constant.provinceWaterKey,
              response.data[Constant.responseDataKey]
                  [Constant.provinceWaterKey]),
          convertSurfaceWater(Constant.metalWaterKey,
              response.data[Constant.responseDataKey][Constant.metalWaterKey]),
        ]).then((waterStatisticsList) =>
            waterStatisticsList.skipWhile((WaterStatistics waterStatistics) {
              return !waterStatistics.show;
            }).toList());
        //污染源企业统计
        List<PollutionEnterStatistics> pollutionEnterStatisticsList =
            await convertPollutionEnterStatistics(
                response.data[Constant.responseDataKey]
                    [Constant.pollutionEnterStatisticsKey]);
        //在线监控点统计
        List<OnlineMonitorStatistics> onlineMonitorStatisticsList =
            await convertOnlineMonitorStatistics(
                response.data[Constant.responseDataKey]
                    [Constant.onlineMonitorStatisticsKey]);
        //代办任务统计
        List<TodoTaskStatistics> todoTaskStatisticsList =
            await convertTodoTaskStatistics(
                response.data[Constant.responseDataKey]
                    [Constant.todoTaskStatisticsKey]);
        //综合信息统计
        List<ComprehensiveStatistics> comprehensiveStatisticsList =
            await convertComprehensiveStatistics(
                response.data[Constant.responseDataKey]
                    [Constant.comprehensiveStatisticsKey]);
        //雨水企业统计
        List<RainEnterStatistics> rainEnterStatisticsList =
            await convertRainEnterStatistics(
                response.data[Constant.responseDataKey]
                    [Constant.rainEnterStatisticsKey]);
        yield IndexLoaded(
          aqiStatistics: aqiStatistics,
          aqiExamineList: aqiExamineList,
          waterStatisticsList: waterStatisticsList,
          pollutionEnterStatisticsList: pollutionEnterStatisticsList,
          onlineMonitorStatisticsList: onlineMonitorStatisticsList,
          todoTaskStatisticsList: todoTaskStatisticsList,
          comprehensiveStatisticsList: comprehensiveStatisticsList,
          rainEnterStatisticsList: rainEnterStatisticsList,
        );
      } catch (e) {
        yield IndexError(errorMessage: ExceptionHandle.handleException(e).msg);
      }
    }
  }
}

//格式化空气质量统计
Future<AqiStatistics> convertAqiStatistics(String string) async {
  List<String> strings = string.split(',');
  return AqiStatistics(
    key: Constant.aqiStatisticsKey,
    show: strings[0] == '1' ? true : false,
    aqi: strings[3],
    aqiLevel: strings[4],
    areaName: strings[1],
    co: strings[11],
    no2: strings[9],
    o3: strings[10],
    pm10: strings[7],
    pm25: strings[6],
    pp: '首要污染物：${strings[5]}',
    so2: strings[8],
    updateTime: strings[2],
  );
}

//格式化空气质量考核
Future<AqiExamine> convertAqiExamine(String key, String string) async {
  List<String> strings = string.split(',');
  switch (key) {
    case Constant.pm25ExamineKey:
      return AqiExamine(
        key: key,
        show: strings[0] == '1' ? true : false,
        title: 'PM2.5',
        imagePath: 'assets/images/icon_aqi_examine_pm25.png',
        color: Color.fromRGBO(241, 190, 67, 1),
        title1: '目标值',
        value1: '${strings[1]}μg/m3',
        title2: '年平均值',
        value2: '${strings[2]}μg/m3',
        title3: '月平均值',
        value3: '${strings[3]}μg/m3',
      );
    case Constant.aqiExamineKey:
      return AqiExamine(
        key: key,
        show: strings[0] == '1' ? true : false,
        title: '优良率',
        imagePath: 'assets/images/icon_aqi_examine_quality.png',
        color: Color.fromRGBO(136, 191, 89, 1),
        title1: '目标值',
        value1: '${strings[1]}%',
        title2: '年平均值',
        value2: '${strings[2]}%',
        title3: '有效天数',
        value3: strings[3],
      );
    default:
      throw Exception('空气质量考核达标模块使用了未知的标识！key=$key');
  }
}

//格式化水环境质量情况
Future<WaterStatistics> convertSurfaceWater(String key, String string) async {
  List<String> strings = string.split(',');
  switch (key) {
    case Constant.stateWaterKey:
      return WaterStatistics(
        key: key,
        show: strings[0] == '1' ? true : false,
        title: '国控断面',
        imagePath: 'assets/images/icon_water_state.png',
        color: Color.fromRGBO(233, 119, 111, 1),
        count: strings[1],
        yearOnYear: strings[2],
        achievementRate: strings[3],
        monthOnMonth: strings[4],
      );
    case Constant.provinceWaterKey:
      return WaterStatistics(
        key: key,
        show: strings[0] == '1' ? true : false,
        title: '省控断面',
        imagePath: 'assets/images/icon_water_province.png',
        color: Color.fromRGBO(136, 191, 89, 1),
        count: strings[1],
        yearOnYear: strings[2],
        achievementRate: strings[3],
        monthOnMonth: strings[4],
      );
    case Constant.countyWaterKey:
      return WaterStatistics(
        key: key,
        show: strings[0] == '1' ? true : false,
        title: '县界断面',
        imagePath: 'assets/images/icon_water_county.png',
        color: Color.fromRGBO(241, 190, 67, 1),
        count: strings[1],
        yearOnYear: strings[2],
        achievementRate: strings[3],
        monthOnMonth: strings[4],
      );
    case Constant.waterWaterKey:
      return WaterStatistics(
        key: key,
        show: strings[0] == '1' ? true : false,
        title: '饮用水断面',
        imagePath: 'assets/images/icon_water_water.png',
        color: Color.fromRGBO(77, 167, 248, 1),
        count: strings[1],
        yearOnYear: strings[2],
        achievementRate: strings[3],
        monthOnMonth: strings[4],
      );
    case Constant.metalWaterKey:
      return WaterStatistics(
        key: key,
        show: strings[0] == '1' ? true : false,
        title: '重金属断面',
        imagePath: 'assets/images/icon_water_metal.png',
        color: Color.fromRGBO(137, 137, 137, 1),
        count: strings[1],
        yearOnYear: strings[2],
        achievementRate: strings[3],
        monthOnMonth: strings[4],
      );
    default:
      throw Exception('水环境质量情况模块使用了未知的标识！key=$key');
  }
}

//格式化污染源企业统计
Future<List<PollutionEnterStatistics>> convertPollutionEnterStatistics(
    String string) async {
  List<String> strings = string.split(',');
  bool show = strings[0] == '1' ? true : false;
  return [
    PollutionEnterStatistics(
      key: Constant.pollutionEnterStatisticsKey,
      show: show,
      title: '企业总数',
      imagePath: 'assets/images/icon_pollution_all_enter.png',
      color: Color.fromRGBO(77, 167, 248, 1),
      count: strings[1],
    ),
    PollutionEnterStatistics(
      key: Constant.pollutionEnterStatisticsKey,
      show: show,
      title: '重点企业',
      imagePath: 'assets/images/icon_pollution_point_enter.png',
      color: Color.fromRGBO(241, 190, 67, 1),
      count: strings[2],
    ),
    PollutionEnterStatistics(
      key: Constant.pollutionEnterStatisticsKey,
      show: show,
      title: '在线企业',
      imagePath: 'assets/images/icon_pollution_online_enter.png',
      color: Color.fromRGBO(136, 191, 89, 1),
      count: strings[3],
    ),
    PollutionEnterStatistics(
      key: Constant.pollutionEnterStatisticsKey,
      show: show,
      title: '废水企业',
      imagePath: 'assets/images/icon_pollution_water_enter.png',
      color: Color.fromRGBO(0, 188, 212, 1),
      count: strings[4],
    ),
    PollutionEnterStatistics(
      key: Constant.pollutionEnterStatisticsKey,
      show: show,
      title: '废气企业',
      imagePath: 'assets/images/icon_pollution_air_enter.png',
      color: Color.fromRGBO(255, 87, 34, 1),
      count: strings[5],
    ),
    PollutionEnterStatistics(
      key: Constant.pollutionEnterStatisticsKey,
      show: show,
      title: '水气企业',
      imagePath: 'assets/images/icon_pollution_air_water.png',
      color: Color.fromRGBO(137, 137, 137, 1),
      count: strings[6],
    ),
    PollutionEnterStatistics(
      key: Constant.pollutionEnterStatisticsKey,
      show: show,
      title: '废水排口',
      imagePath: 'assets/images/icon_pollution_water_outlet.png',
      color: Color.fromRGBO(63, 81, 181, 1),
      count: strings[7],
    ),
    PollutionEnterStatistics(
      key: Constant.pollutionEnterStatisticsKey,
      show: show,
      title: '废气排口',
      imagePath: 'assets/images/icon_pollution_air_outlet.png',
      color: Color.fromRGBO(233, 30, 99, 1),
      count: strings[8],
    ),
    PollutionEnterStatistics(
      key: Constant.pollutionEnterStatisticsKey,
      show: show,
      title: '许可证企业',
      imagePath: 'assets/images/icon_pollution_licence_enter.png',
      color: Color.fromRGBO(179, 129, 127, 1),
      count: strings[9],
    ),
  ];
}

//格式化在线监控点概况
Future<List<OnlineMonitorStatistics>> convertOnlineMonitorStatistics(
    String string) async {
  List<String> strings = string.split(',');
  bool show = strings[0] == '1' ? true : false;
  return [
    OnlineMonitorStatistics(
      key: Constant.onlineMonitorStatisticsKey,
      show: show,
      title: '全部',
      imagePath: 'assets/images/icon_monitor_all.png',
      color: Color.fromRGBO(77, 167, 248, 1),
      count: strings[1],
    ),
    OnlineMonitorStatistics(
      key: Constant.onlineMonitorStatisticsKey,
      show: show,
      title: '在线',
      imagePath: 'assets/images/icon_monitor_online.png',
      color: Color.fromRGBO(136, 191, 89, 1),
      count: strings[2],
    ),
    OnlineMonitorStatistics(
      key: Constant.onlineMonitorStatisticsKey,
      show: show,
      title: '预警',
      imagePath: 'assets/images/icon_monitor_alarm.png',
      color: Color.fromRGBO(241, 190, 67, 1),
      count: strings[3],
    ),
    OnlineMonitorStatistics(
      key: Constant.onlineMonitorStatisticsKey,
      show: show,
      title: '超标',
      imagePath: 'assets/images/icon_monitor_over.png',
      color: Color.fromRGBO(233, 119, 111, 1),
      count: strings[4],
    ),
    OnlineMonitorStatistics(
      key: Constant.onlineMonitorStatisticsKey,
      show: show,
      title: '脱机',
      imagePath: 'assets/images/icon_monitor_offline.png',
      color: Color.fromRGBO(179, 129, 127, 1),
      count: strings[5],
    ),
    OnlineMonitorStatistics(
      key: Constant.onlineMonitorStatisticsKey,
      show: show,
      title: '停产',
      imagePath: 'assets/images/icon_monitor_stop.png',
      color: Color.fromRGBO(137, 137, 137, 1),
      count: strings[6],
    ),
  ];
}

//格式化代办任务统计
Future<List<TodoTaskStatistics>> convertTodoTaskStatistics(
    String string) async {
  List<String> strings = string.split(',');
  bool show = strings[0] == '1' ? true : false;
  return [
    TodoTaskStatistics(
      key: Constant.todoTaskStatisticsKey,
      show: show,
      title: '报警单待处理',
      imagePath: 'assets/images/button_bg_blue.png',
      count: strings[1],
    ),
    TodoTaskStatistics(
      key: Constant.todoTaskStatisticsKey,
      show: show,
      title: '排口异常待审核',
      imagePath: 'assets/images/button_bg_green.png',
      count: strings[2],
    ),
    TodoTaskStatistics(
      key: Constant.todoTaskStatisticsKey,
      show: show,
      title: '因子异常待审核',
      imagePath: 'assets/images/button_bg_pink.png',
      count: strings[3],
    ),
  ];
}

//综合统计信息
Future<List<ComprehensiveStatistics>> convertComprehensiveStatistics(
    String string) async {
  List<String> strings = string.split(',');
  bool show = strings[0] == '1' ? true : false;
  return [
    ComprehensiveStatistics(
      key: Constant.comprehensiveStatisticsKey,
      show: show,
      title: '监察执法',
      color: Color.fromRGBO(77, 167, 248, 1),
      imagePath: 'assets/images/button_image3.png',
      count: strings[1],
    ),
    ComprehensiveStatistics(
      key: Constant.comprehensiveStatisticsKey,
      show: show,
      title: '项目审批',
      color: Color.fromRGBO(241, 190, 67, 1),
      imagePath: 'assets/images/button_image2.png',
      count: strings[2],
    ),
    ComprehensiveStatistics(
      key: Constant.comprehensiveStatisticsKey,
      show: show,
      title: '信访投诉',
      color: Color.fromRGBO(136, 191, 89, 1),
      imagePath: 'assets/images/button_image1.png',
      count: strings[3],
    ),
  ];
}

//雨水企业统计
Future<List<RainEnterStatistics>> convertRainEnterStatistics(
    String string) async {
  List<String> strings = string.split(',');
  bool show = strings[0] == '1' ? true : false;
  return [
    RainEnterStatistics(
      key: Constant.rainEnterStatisticsKey,
      show: show,
      title: '全部企业',
      color: Color.fromRGBO(77, 167, 248, 1),
      imagePath: 'assets/images/icon_pollution_all_enter.png',
      count: strings[1],
    ),
    RainEnterStatistics(
      key: Constant.rainEnterStatisticsKey,
      show: show,
      title: '在线企业',
      color: Color.fromRGBO(241, 190, 67, 1),
      imagePath: 'assets/images/icon_pollution_online_enter.png',
      count: strings[2],
    ),
    RainEnterStatistics(
      key: Constant.rainEnterStatisticsKey,
      show: show,
      title: '排口总数',
      color: Color.fromRGBO(136, 191, 89, 1),
      imagePath: 'assets/images/icon_pollution_water_outlet.png',
      count: strings[3],
    ),
  ];
}
