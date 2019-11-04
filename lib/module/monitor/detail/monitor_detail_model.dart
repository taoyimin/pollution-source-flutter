import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/util/utils.dart';

//监控点详情
class MonitorDetail extends Equatable {
  final int enterId; //企业ID
  final int dischargeId; //排口ID
  final int monitorId; //监控点ID
  final String enterName; //企业名称
  final String enterAddress; //企业地址
  final String monitorName; //监控点名称
  final String monitorTypeStr; //监控点类型
  final String outletTypeStr; //监控点类别
  final String networkTypeStr; //网络类型
  final String monitorAddress; //监控点地址
  final String mnCode; //数采仪编码
  final bool isCurved; //图表是否为曲线
  final bool showDotData; //图表是否显示点
  final List<ChartData> chartDataList; //图表数据

  const MonitorDetail({
    this.enterId,
    this.dischargeId,
    this.monitorId,
    this.enterName,
    this.enterAddress,
    this.monitorName,
    this.monitorTypeStr,
    this.outletTypeStr,
    this.networkTypeStr,
    this.monitorAddress,
    this.mnCode,
    this.isCurved,
    this.showDotData,
    this.chartDataList,
  });

  @override
  List<Object> get props => [
        enterId,
        dischargeId,
        monitorId,
        enterName,
        enterAddress,
        monitorName,
        monitorTypeStr,
        outletTypeStr,
        networkTypeStr,
        monitorAddress,
        mnCode,
        isCurved,
        showDotData,
        chartDataList,
      ];

  MonitorDetail copyWith({
    bool isCurved,
    bool showDotData,
    List<ChartData> chartDataList,
  }) {
    return MonitorDetail(
      enterId: this.enterId,
      dischargeId: this.dischargeId,
      monitorId: this.monitorId,
      enterName: this.enterName,
      enterAddress: this.enterAddress,
      monitorName: this.monitorName,
      monitorTypeStr: this.monitorTypeStr,
      outletTypeStr: this.outletTypeStr,
      networkTypeStr: this.networkTypeStr,
      monitorAddress: this.monitorAddress,
      mnCode: this.mnCode,
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

    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return MonitorDetail(
        enterId: 0,
        dischargeId: 0,
        monitorId: 0,
        enterName: '-',
        enterAddress: '-',
        monitorName: '-',
        monitorTypeStr: '-',
        outletTypeStr: '-',
        networkTypeStr: '-',
        monitorAddress: '-',
        mnCode: '-',
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
    } else {
      return MonitorDetail(
        enterId: json['enterId'],
        dischargeId: json['dischargeId'],
        monitorId: json['monitorId'],
        enterName: json['enterName'],
        enterAddress: json['enterAddress'],
        monitorName: json['monitorName'],
        monitorTypeStr: json['monitorTypeStr'],
        outletTypeStr: json['outletTypeStr'],
        networkTypeStr: json['networkTypeStr'],
        monitorAddress: json['monitorAddress'],
        mnCode: json['mnCode'],
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
