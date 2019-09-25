import 'dart:ui';

import 'package:dio/dio.dart';

import 'index.dart';
import 'package:bloc/bloc.dart';
import 'package:pollution_source/http/http.dart';

class IndexBloc extends Bloc<IndexEvent, IndexState> {
  @override
  IndexState get initialState => IndexLoading();

  @override
  Stream<IndexState> mapEventToState(IndexEvent event) async* {
    if (event is Load) {
      try {
        if (event.isFirst) yield IndexLoading();
        Response response = await Dio(httpOptions).get(HttpApi.index);
        if (response.data['code'] == 200) {
          //空气质量统计
          AqiStatistics aqiStatistics =
              await convertAqiStatistics(response.data['data']['10']);
          //空气质量考核
          List<AqiExamine> aqiExamineList = await Future.wait([
            convertAqiExamine('20', response.data['data']['20']),
            convertAqiExamine('21', response.data['data']['21'])
          ]).then((aqiExamineList) => filterUselessAqiExamine(aqiExamineList));
          //水环境质量情况
          //TODO
          List<SurfaceWater> surfaceWaterList = await Future.wait([
            convertSurfaceWater('30', response.data['data']['30']),
            convertSurfaceWater('31', response.data['data']['31']),
            convertSurfaceWater('34', response.data['data']['34'])
          ]).then((surfaceWaterList) =>
              filterUselessSurfaceWater(surfaceWaterList));
          yield IndexLoaded(
            aqiStatistics: aqiStatistics,
            aqiExamineList: aqiExamineList,
            surfaceWaterList: surfaceWaterList,
          );
        } else {
          yield IndexError();
        }
      } catch (e) {
        print('异常信息:$e');
        yield IndexError();
      }
    }
  }
}

//过滤无效的数据
List<AqiExamine> filterUselessAqiExamine(List<AqiExamine> list) {
  return list.skipWhile((AqiExamine aqiExamine) {
    return !aqiExamine.show;
  }).toList();
}

List<SurfaceWater> filterUselessSurfaceWater(List<SurfaceWater> list) {
  return list.skipWhile((SurfaceWater surfaceWater) {
    return !surfaceWater.show;
  }).toList();
}

Future<AqiStatistics> convertAqiStatistics(String string) async {
  List<String> strings = string.split(',');
  return AqiStatistics(
    key: '10',
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

Future<AqiExamine> convertAqiExamine(String key, String string) async {
  List<String> strings = string.split(',');
  switch (key) {
    case '20':
      return AqiExamine(
        key: key,
        show: strings[0] == '0' ? true : false,
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
    case '21':
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

Future<SurfaceWater> convertSurfaceWater(String key, String string) async {
  List<String> strings = string.split(',');
  switch (key) {
    case '30':
      return SurfaceWater(
        key: key,
        show: strings[0] == '1' ? true : false,
        title: '国控断面',
        imagePath: 'assets/images/icon_water_state.png',
        color: Color.fromRGBO(233, 119, 111, 1),
        count: strings[0],
        yearOnYear: strings[1],
        achievementRate: string[2],
        monthOnMonth: strings[3],
      );
    case '31':
      return SurfaceWater(
        key: key,
        show: strings[0] == '1' ? true : false,
        title: '省控断面',
        imagePath: 'assets/images/icon_water_province.png',
        color: Color.fromRGBO(136, 191, 89, 1),
        count: strings[0],
        yearOnYear: strings[1],
        achievementRate: string[2],
        monthOnMonth: strings[3],
      );
    case '32':
      return SurfaceWater(
        key: key,
        show: strings[0] == '1' ? true : false,
        title: '县界断面',
        imagePath: 'assets/images/icon_water_county.png',
        color: Color.fromRGBO(241, 190, 67, 1),
        count: strings[0],
        yearOnYear: strings[1],
        achievementRate: string[2],
        monthOnMonth: strings[3],
      );
    case '33':
      return SurfaceWater(
        key: key,
        show: strings[0] == '1' ? true : false,
        title: '饮用水断面',
        imagePath: 'assets/images/icon_water_water.png',
        color: Color.fromRGBO(77, 167, 248, 1),
        count: strings[0],
        yearOnYear: strings[1],
        achievementRate: string[2],
        monthOnMonth: strings[3],
      );
    case '34':
      return SurfaceWater(
        key: key,
        show: strings[0] == '1' ? true : false,
        title: '重金属断面',
        imagePath: 'assets/images/icon_water_metal.png',
        color: Color.fromRGBO(137, 137, 137, 1),
        count: strings[0],
        yearOnYear: strings[1],
        achievementRate: string[2],
        monthOnMonth: strings[3],
      );
    default:
      throw Exception('水环境质量情况模块使用了未知的标识！key=$key');
  }
}
