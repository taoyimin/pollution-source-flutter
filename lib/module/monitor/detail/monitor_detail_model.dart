import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/util/constant.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/util/utils.dart';

//监控点详情
class MonitorDetail extends Equatable {
  final String enterName; //企业名称
  final String enterAddress;  //企业地址
  final String monitorName; //监控点名称
  final String monitorType; //监控点类型
  final String monitorTime; //监控时间
  final String areaName;  //区域
  final String monitorAddress;  //监控点地址
  final String dataCollectionNumber;  //数采仪编码
  final bool isCurved; //图表是否为曲线
  final bool showDotData; //图表是否显示点
  final List<ChartData> chartDataList;  //图表数据

  const MonitorDetail({
    this.enterName,
    this.enterAddress,
    this.monitorName,
    this.monitorType,
    this.monitorTime,
    this.areaName,
    this.monitorAddress,
    this.dataCollectionNumber,
    this.isCurved,
    this.showDotData,
    this.chartDataList,
  });

  @override
  List<Object> get props => [
        enterName,
        enterAddress,
        monitorName,
        monitorType,
        monitorTime,
        areaName,
        monitorAddress,
        dataCollectionNumber,
        isCurved,
        showDotData,
        chartDataList,
      ];

  MonitorDetail copyWith(
      {bool isCurved, bool showDotData, List<ChartData> chartDataList}) {
    return MonitorDetail(
      enterName: this.enterName,
      enterAddress: this.enterAddress,
      monitorName: this.monitorName,
      monitorType: this.monitorType,
      monitorTime: this.monitorTime,
      areaName: this.areaName,
      monitorAddress: this.monitorAddress,
      dataCollectionNumber: this.dataCollectionNumber,
      isCurved: isCurved ?? this.isCurved,
      showDotData: showDotData ?? this.showDotData,
      chartDataList: chartDataList ?? this.chartDataList,
    );
  }

  static MonitorDetail fromJson(dynamic json) {
    List<PointData> points1 = _getRandomPoints();
    List<PointData> points2 = _getRandomPoints();
    List<PointData> points3 = _getRandomPoints();
    List<PointData> points4 = _getRandomPoints();
    List<PointData> points5 = _getRandomPoints();
    List<PointData> points6 = _getRandomPoints();

    return MonitorDetail(
      enterName: '深圳市腾讯计算机系统有限公司',
      enterAddress: '深圳市南山区高新区高新南一路飞亚达大厦5-10楼',
      monitorName: '废水排放口',
      monitorType: '废水',
      monitorTime: '2019年10月15日 10时22分',
      areaName: '南昌市 市辖区',
      monitorAddress: '江西省安义东阳镇',
      dataCollectionNumber: '86377750110022',
      isCurved: SpUtil.getBool(Constant.spIsCurved, defValue: true),
      showDotData: SpUtil.getBool(Constant.spShowDotData, defValue: true),
      chartDataList: [
        ChartData(
          factorName: 'PH',
          checked: true,
          lastValue: '13.11',
          unit: 'μg/cm3',
          color: UIUtils.getRandomColor(),
          maxX: Utils.getMax(points1.map((point) {
            return point.x;
          }).toList()),
          maxY: Utils.getMax(points1.map((point) {
            return point.y;
          }).toList()),
          minX: Utils.getMin(points1.map((point) {
            return point.x;
          }).toList()),
          minY: Utils.getMin(points1.map((point) {
            return point.y;
          }).toList()),
          points: points1,
        ),
        ChartData(
          factorName: '二氧化硫',
          checked: false,
          lastValue: '42.5',
          unit: 'μg/cm3',
          color: UIUtils.getRandomColor(),
          maxX: Utils.getMax(points2.map((point) {
            return point.x;
          }).toList()),
          maxY: Utils.getMax(points2.map((point) {
            return point.y;
          }).toList()),
          minX: Utils.getMin(points2.map((point) {
            return point.x;
          }).toList()),
          minY: Utils.getMin(points2.map((point) {
            return point.y;
          }).toList()),
          points: points2,
        ),
        ChartData(
          factorName: '氨氮',
          checked: false,
          lastValue: '11.4',
          unit: 'μg/cm3',
          color: UIUtils.getRandomColor(),
          maxX: Utils.getMax(points3.map((point) {
            return point.x;
          }).toList()),
          maxY: Utils.getMax(points3.map((point) {
            return point.y;
          }).toList()),
          minX: Utils.getMin(points3.map((point) {
            return point.x;
          }).toList()),
          minY: Utils.getMin(points3.map((point) {
            return point.y;
          }).toList()),
          points: points3,
        ),
        ChartData(
          factorName: '化学需氧量',
          checked: false,
          lastValue: '45.24',
          unit: 'μg/cm3',
          color: UIUtils.getRandomColor(),
          maxX: Utils.getMax(points4.map((point) {
            return point.x;
          }).toList()),
          maxY: Utils.getMax(points4.map((point) {
            return point.y;
          }).toList()),
          minX: Utils.getMin(points4.map((point) {
            return point.x;
          }).toList()),
          minY: Utils.getMin(points4.map((point) {
            return point.y;
          }).toList()),
          points: points4,
        ),
        ChartData(
          factorName: '臭氧',
          checked: false,
          lastValue: '0.125',
          unit: 'μg/cm3',
          color: UIUtils.getRandomColor(),
          maxX: Utils.getMax(points5.map((point) {
            return point.x;
          }).toList()),
          maxY: Utils.getMax(points5.map((point) {
            return point.y;
          }).toList()),
          minX: Utils.getMin(points5.map((point) {
            return point.x;
          }).toList()),
          minY: Utils.getMin(points5.map((point) {
            return point.y;
          }).toList()),
          points: points5,
        ),
        ChartData(
          factorName: '实测NXO',
          checked: false,
          lastValue: '45.12',
          unit: 'μg/cm3',
          color: UIUtils.getRandomColor(),
          maxX: Utils.getMax(points6.map((point) {
            return point.x;
          }).toList()),
          maxY: Utils.getMax(points6.map((point) {
            return point.y;
          }).toList()),
          minX: Utils.getMin(points6.map((point) {
            return point.x;
          }).toList()),
          minY: Utils.getMin(points6.map((point) {
            return point.y;
          }).toList()),
          points: points6,
        ),
      ],
    );
  }

  static List<PointData> _getRandomPoints() {
    return [
      PointData(x: 1571209281000, y: Random.secure().nextInt(50).toDouble()),
      PointData(x: 1571209311000, y: Random.secure().nextInt(50).toDouble()),
      PointData(x: 1571209401000, y: Random.secure().nextInt(50).toDouble()),
      PointData(x: 1571209461000, y: Random.secure().nextInt(50).toDouble()),
      PointData(x: 1571209521000, y: Random.secure().nextInt(50).toDouble()),
      PointData(x: 1571209581000, y: Random.secure().nextInt(50).toDouble()),
      PointData(x: 1571209641000, y: Random.secure().nextInt(50).toDouble()),
    ];
  }
}
