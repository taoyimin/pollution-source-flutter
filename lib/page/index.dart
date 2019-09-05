import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pollution_source/model/model.dart';
import 'package:pollution_source/res/colors.dart';
import 'dart:ui';
import 'dart:math';
import 'package:pollution_source/widget/space_header.dart';
import 'dart:async';

import 'enter_list.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 总数
  bool _haveData = true;
  String _text = "hello";
  int _count = 0;

  @override
  void initState() {
    super.initState();
    print("_IndexPageState的initState方法执行了！");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: EasyRefresh.custom(
        header: SpaceHeader(),
        firstRefresh: true,
        firstRefreshWidget: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Center(
              child: SizedBox(
            height: 200.0,
            width: 300.0,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50.0,
                    height: 50.0,
                    child: SpinKitFadingCube(
                      color: Theme.of(context).primaryColor,
                      size: 25.0,
                    ),
                  ),
                  Container(
                    child: Text('加载中'),
                  )
                ],
              ),
            ),
          )),
        ),
        emptyWidget: !_haveData
            ? Container(
                height: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: Image.asset('assets/images/nodata.png'),
                    ),
                    Text(
                      '没有数据',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
                    ),
                  ],
                ),
              )
            : null,
        slivers: <Widget>[
          /*SliverAppBar(
            pinned: true,
            floating: false,
            snap: false,
            expandedHeight: 280.0,
            flexibleSpace: FlexibleSpaceBar(
              background: AqiWidget(),
            ),
          ),*/
          SliverToBoxAdapter(
            child: AqiWidget(),
          ),
          SliverToBoxAdapter(
            child: TodoTasksWidget(),
          ),
          SliverToBoxAdapter(
            child: AqiExamineWidget(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                child: Column(
                  children: <Widget>[
                    TitleWidget("最近一周变化趋势"),
                    Container(
                      height: 200,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: BarChartWidget(
                                title: "AQI",
                                subTitle: "空气质量",
                                color: Color.fromRGBO(136, 191, 89, 1),
                                imagePath:
                                    "assets/images/icon_aqi_examine_quality.png"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: BarChartWidget(
                                title: "PM2.5",
                                subTitle: "细颗粒物",
                                color: Color.fromRGBO(241, 190, 67, 1),
                                imagePath:
                                    "assets/images/icon_aqi_examine_pm25.png"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AlarmListWidget(),
          ),
          SliverToBoxAdapter(
            child: OnlineMonitorWidget(),
          ),
          SliverToBoxAdapter(
            child: WaterWidget(),
          ),
          SliverToBoxAdapter(
            child: PollutionEnterWidget(),
          ),
          SliverToBoxAdapter(
            child: SummaryStatisticsWidget(),
          ),
        ],
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _count += 20;
            });
          });
        },
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  final String title;
  final Color color;

  TitleWidget(this.title, {Key key, this.color: Colours.primary_color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/icon_card_title.png",
            height: 12,
            color: color,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: TextStyle(
                color: color,
              ),
            ),
          ),
          Transform.rotate(
            angle: pi,
            child: Image.asset(
              "assets/images/icon_card_title.png",
              height: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

//空气质量
class AqiWidget extends StatefulWidget {
  AqiWidget({Key key}) : super(key: key);

  @override
  _AqiWidgetState createState() => _AqiWidgetState();
}

class _AqiWidgetState extends State<AqiWidget> with TickerProviderStateMixin {
  //获取空气质量因子监测值的grid item
  Widget _getAqiGridItem(factorName, factorValue) {
    return Expanded(
      flex: 1, //设置一个宽度，防止宽度不同无法对齐
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            factorValue,
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          Text(
            factorName,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/index_header_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            bottom: 0,
            child: SvgPicture.asset(
              "assets/images/index_header_image.svg",
              width: 150,
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: 80,
                padding: EdgeInsets.fromLTRB(16, 35, 16, 0),
                //color: Colours.accent_color,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 30,
                      padding: EdgeInsets.all(5),
                      child: Image(
                          image:
                              AssetImage("assets/images/index_location.png")),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "赣州市",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        "2019年8月16日 15时",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "25",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(3), //3像素圆角
                          ),
                          child: Text(
                            "优",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          "首要污染物:颗粒物及二氧化硫",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _getAqiGridItem("PM2.5", "25"),
                        Container(
                          height: 26,
                          width: 1,
                          color: Colors.white,
                        ),
                        _getAqiGridItem("PM10", "25"),
                        Container(
                          height: 26,
                          width: 1,
                          color: Colors.white,
                        ),
                        _getAqiGridItem("SO₂", "25"),
                        Container(
                          height: 26,
                          width: 1,
                          color: Colors.white,
                        ),
                        _getAqiGridItem("NO₂", "25"),
                        Container(
                          height: 26,
                          width: 1,
                          color: Colors.white,
                        ),
                        _getAqiGridItem("O₃", "25"),
                        Container(
                          height: 26,
                          width: 1,
                          color: Colors.white,
                        ),
                        _getAqiGridItem("CO", "25"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*class _AqiWidgetState extends State<AqiWidget> with TickerProviderStateMixin {
  //获取空气质量因子监测值的grid item
  Widget _getAqiGridItem(factorName, factorValue) {
    return Container(
      width: 70, //设置一个宽度，防止宽度不同无法对齐
      child: Column(
        children: <Widget>[
          Text(
            factorValue,
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          Text(
            factorName,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 80,
          padding: EdgeInsets.fromLTRB(16, 35, 16, 0),
          //color: Colours.accent_color,
          child: Row(
            children: <Widget>[
              Text(
                "赣州市",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 8),
                child: Image(
                    image: AssetImage("assets/images/index_location.png")),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Expanded(
                child: Text(
                  "2019年8月16日 15时",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 100,
          //color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "25",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 58,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(3), //3像素圆角
                        ),
                        child: Text(
                          "优",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 1),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      borderRadius: BorderRadius.circular(3), //3像素圆角
                    ),
                    child: Text(
                      "空气质量指数",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        " ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 58,
                        ),
                      ),
                      Text(
                        "SO2、NO",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 1),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      borderRadius: BorderRadius.circular(3), //3像素圆角
                    ),
                    child: Text(
                      "首要污染物",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _getAqiGridItem("PM2.5", "25"),
                  _getAqiGridItem("PM10", "25"),
                  _getAqiGridItem("SO₂", "25"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _getAqiGridItem("NO₂", "25"),
                  _getAqiGridItem("O₃", "25"),
                  _getAqiGridItem("CO", "25"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}*/

//空气质量考核达标
class AqiExamineWidget extends StatefulWidget {
  AqiExamineWidget({Key key}) : super(key: key);

  @override
  _AqiExamineWidgetState createState() => _AqiExamineWidgetState();
}

class _AqiExamineWidgetState extends State<AqiExamineWidget> {
  final List<AqiExamine> _aqiExamine = [
    AqiExamine("PM2.5", "assets/images/icon_aqi_examine_pm25.png", "年平均值",
        "27μg/m3", "目标值", "41μg/m³", "月平均值", "25μg/m³"),
    AqiExamine("优良率", "assets/images/icon_aqi_examine_quality.png", "年平均值",
        "94.16%", "目标值", "91.4%", "优良天数", "145"),
  ];

  Widget _getAqiExamineColumnItem(AqiExamine aqiExamine,
      {Color color: Colours.grey_color}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: Container(
        height: 70,
        color: color.withOpacity(0.3),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    aqiExamine.imagePath,
                    width: 26,
                    height: 26,
                    color: color,
                  ),
                  Text(
                    aqiExamine.title,
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    aqiExamine.value1,
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    aqiExamine.title1,
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              width: 2,
              height: 40,
              color: Colors.white,
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    aqiExamine.value2,
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    aqiExamine.title2,
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              width: 2,
              height: 40,
              color: Colors.white,
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    aqiExamine.value3,
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    aqiExamine.title3,
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      /*decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          StyleUtil.getBoxShadow(),
        ],
      ),*/
      child: Column(
        children: <Widget>[
          TitleWidget("空气质量考核达标"),
          _getAqiExamineColumnItem(_aqiExamine[0],
              color: Color.fromRGBO(241, 190, 67, 1)),
          SizedBox(
            height: 10,
          ),
          _getAqiExamineColumnItem(_aqiExamine[1],
              color: Color.fromRGBO(136, 191, 89, 1)),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

//水环境质量情况
class WaterWidget extends StatefulWidget {
  WaterWidget({Key key}) : super(key: key);

  @override
  _WaterWidgetState createState() => _WaterWidgetState();
}

class _WaterWidgetState extends State<WaterWidget> {
  final List<Water> _waters = [
    Water("国控断面", "assets/images/icon_water_state.png", 423, 0.9, 0.8, 0.45),
    Water("省控断面", "assets/images/icon_water_province.png", 41, 0.41, 0.4, 0.11),
    Water("县界断面", "assets/images/icon_water_county.png", 41, 0.85, 0.36, 0.56),
    Water("饮用水断面", "assets/images/icon_water_water.png", 41, 0.35, 0.7, 0.34),
    Water("重金属断面", "assets/images/icon_water_metal.png", 41, 0.17, 0.9, 0.06),
  ];

  Widget _getWaterColumnItem(Water water, {Color color: Colours.grey_color}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: Container(
        height: 70,
        color: color.withOpacity(0.3),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    water.imagePath,
                    width: 26,
                    height: 26,
                    color: color,
                  ),
                  Text(
                    water.title,
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "数量:${water.count}",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "达标率:${(water.achievementRate * 100).toStringAsFixed(1)}%",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              width: 2,
              height: 40,
              color: Colors.white,
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "环比:${(water.monthOnMonth * 100).toStringAsFixed(1)}%",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "同比:${(water.yearOnYear * 100).toStringAsFixed(1)}%",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      /*decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          StyleUtil.getBoxShadow(),
        ],
      ),*/
      child: Column(
        children: <Widget>[
          TitleWidget("水环境质量情况"),
          _getWaterColumnItem(_waters[0],
              color: Color.fromRGBO(233, 119, 111, 1)),
          SizedBox(
            height: 10,
          ),
          _getWaterColumnItem(_waters[1],
              color: Color.fromRGBO(136, 191, 89, 1)),
          SizedBox(
            height: 10,
          ),
          _getWaterColumnItem(_waters[2],
              color: Color.fromRGBO(241, 190, 67, 1)),
          SizedBox(
            height: 10,
          ),
          _getWaterColumnItem(_waters[3],
              color: Color.fromRGBO(77, 167, 248, 1)),
          SizedBox(
            height: 10,
          ),
          _getWaterColumnItem(_waters[4],
              color: Color.fromRGBO(137, 137, 137, 1)),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

//代办任务
class TodoTasksWidget extends StatefulWidget {
  TodoTasksWidget({Key key}) : super(key: key);

  _TodoTasksWidgetState createState() => _TodoTasksWidgetState();
}

class _TodoTasksWidgetState extends State<TodoTasksWidget> {
  //返回代办任务row item
  Widget _getTodoTaskRowItem(title, count, image) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 70,
        child: Card(
          /*elevation: 6,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),*/
          elevation: 0,
          margin: EdgeInsets.all(0),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(
                image,
                fit: BoxFit.cover,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TitleWidget("待办任务统计"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _getTodoTaskRowItem(
                  "报警单待处理", "232", "assets/images/bg_alarm_manage_todo.png"),
              SizedBox(
                width: 6,
              ),
              _getTodoTaskRowItem(
                  "排口异常待审核", "45", "assets/images/bg_outlet_audit_todo.png"),
              SizedBox(
                width: 6,
              ),
              _getTodoTaskRowItem(
                  "因子异常待审核", "8", "assets/images/bg_factor_audit_todo.png"),
            ],
          ),
        ],
      ),
    );
  }
}

//在线监控点概况
class OnlineMonitorWidget extends StatefulWidget {
  OnlineMonitorWidget({Key key}) : super(key: key);

  @override
  _OnlineMonitorWidgetState createState() => _OnlineMonitorWidgetState();
}

class _OnlineMonitorWidgetState extends State<OnlineMonitorWidget> {
  final List<Monitor> _monitors = [
    Monitor("全部", 145, "assets/images/icon_monitor_all.png",
        Color.fromRGBO(77, 167, 248, 1)),
    Monitor("在线", 65, "assets/images/icon_monitor_online.png",
        Color.fromRGBO(136, 191, 89, 1)),
    Monitor("预警", 4, "assets/images/icon_monitor_alarm.png",
        Color.fromRGBO(241, 190, 67, 1)),
    Monitor("超标", 14, "assets/images/icon_monitor_over.png",
        Color.fromRGBO(233, 119, 111, 1)),
    Monitor("脱机", 56, "assets/images/icon_monitor_offline.png",
        Color.fromRGBO(179, 129, 127, 1)),
    Monitor("停产", 1, "assets/images/icon_monitor_stop.png",
        Color.fromRGBO(137, 137, 137, 1)),
  ];

  Widget _getOnlineMonitorRowItem(Monitor monitor) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: monitor.color.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  monitor.imagePath,
                  width: 16,
                  height: 16,
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        monitor.title,
                        style: TextStyle(
                          fontSize: 13,
                          color: monitor.color,
                        ),
                      ),
                      Text(
                        monitor.count.toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      /*decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          StyleUtil.getBoxShadow(),
        ],
      ),*/
      child: Column(
        children: <Widget>[
          TitleWidget("在线监控点概况"),
          Row(
            children: <Widget>[
              _getOnlineMonitorRowItem(_monitors[0]),
              Container(
                height: 40,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getOnlineMonitorRowItem(_monitors[1]),
              Container(
                height: 40,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getOnlineMonitorRowItem(_monitors[2]),
            ],
          ),
          Row(
            children: <Widget>[
              _getOnlineMonitorRowItem(_monitors[3]),
              Container(
                height: 40,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getOnlineMonitorRowItem(_monitors[4]),
              Container(
                height: 40,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getOnlineMonitorRowItem(_monitors[5]),
            ],
          ),
        ],
      ),
    );
  }
}

class AlarmListWidget extends StatefulWidget {
  AlarmListWidget({Key key}) : super(key: key);

  @override
  _AlarmListWidgetState createState() => _AlarmListWidgetState();
}

class _AlarmListWidgetState extends State<AlarmListWidget> {
  List<charts.Series> seriesList;
  bool animate;
  String dropdownValue = '昨日';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TitleWidget("报警管理单统计"),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 160,
            padding: EdgeInsets.all(0),
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 160,
                        child: SimplePieChart.withSampleData(),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: -16,
                  right: 60,
                  child: DropdownButton<String>(
                    underline: Container(),
                    value: dropdownValue,
                    onChanged: (String newValue) {
                      setState(() {
                        this.dropdownValue = newValue;
                      });
                    },
                    items: <String>['昨日', '上月', '去年']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SimplePieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimplePieChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory SimplePieChart.withSampleData() {
    return new SimplePieChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      behaviors: [
        new charts.DatumLegend(
          outsideJustification: charts.OutsideJustification.middleDrawArea,
          // Positions for "start" and "end" will be left and right respectively
          // for widgets with a build context that has directionality ltr.
          // For rtl, "start" and "end" will be right and left respectively.
          // Since this example has directionality of ltr, the legend is
          // positioned on the right side of the chart.
          position: charts.BehaviorPosition.end,
          // By default, if the position of the chart is on the left or right of
          // the chart, [horizontalFirst] is set to false. This means that the
          // legend entries will grow as new rows first instead of a new column.
          horizontalFirst: false,
          // This defines the padding around each legend entry.
          cellPadding: new EdgeInsets.only(right: 24.0, bottom: 4.0, top: 4.0),
          // Set [showMeasures] to true to display measures in series legend.
          showMeasures: false,
          // Configure the measure value to be shown by default in the legend.
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          entryTextStyle: charts.TextStyleSpec(),
          // Optionally provide a measure formatter to format the measure value.
          // If none is specified the value is formatted as a decimal.
          measureFormatter: (num value) {
            return value == null ? '-' : '$value个';
          },
        ),
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearAlarms, String>> _createSampleData() {
    final data = [
      new LinearAlarms(
          "待处理            92个", 92, charts.Color.fromHex(code: "#4DA7F8")),
      new LinearAlarms(
          "待审核            123个", 123, charts.Color.fromHex(code: "#F1BE43")),
      new LinearAlarms(
          "审核不通过    42个", 42, charts.Color.fromHex(code: "#E9776F")),
      new LinearAlarms(
          "已办结            14个", 14, charts.Color.fromHex(code: "#88BF59")),
    ];

    return [
      new charts.Series<LinearAlarms, String>(
        id: 'AlarmList',
        colorFn: (LinearAlarms sales, __) => sales.color,
        domainFn: (LinearAlarms sales, _) => sales.state,
        measureFn: (LinearAlarms sales, _) => sales.count,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearAlarms {
  final String state;
  final int count;
  final charts.Color color;

  LinearAlarms(this.state, this.count, this.color);
}

//污染源企业概况
class PollutionEnterWidget extends StatefulWidget {
  PollutionEnterWidget({Key key}) : super(key: key);

  @override
  _PollutionEnterWidgetState createState() => _PollutionEnterWidgetState();
}

class _PollutionEnterWidgetState extends State<PollutionEnterWidget> {
  final List<PollutionEnter> _pollutionEnter = [
    PollutionEnter("全部企业", 145, "assets/images/icon_pollution_all_enter.png",
        Color.fromRGBO(77, 167, 248, 1)),
    PollutionEnter("重点企业", 65, "assets/images/icon_pollution_point_enter.png",
        Color.fromRGBO(241, 190, 67, 1)),
    PollutionEnter("在线企业", 4, "assets/images/icon_pollution_online_enter.png",
        Color.fromRGBO(136, 191, 89, 1)),
    PollutionEnter("废水企业", 14, "assets/images/icon_pollution_water_enter.png",
        Color.fromRGBO(0, 188, 212, 1)),
    PollutionEnter("废气企业", 56, "assets/images/icon_pollution_air_enter.png",
        Color.fromRGBO(255, 87, 34, 1)),
    PollutionEnter("水气企业", 1, "assets/images/icon_pollution_air_water.png",
        Color.fromRGBO(137, 137, 137, 1)),
    PollutionEnter("废水排口", 1, "assets/images/icon_pollution_water_outlet.png",
        Color.fromRGBO(63, 81, 181, 1)),
    PollutionEnter("废气排口", 56, "assets/images/icon_pollution_air_outlet.png",
        Color.fromRGBO(233, 30, 99, 1)),
    PollutionEnter(
        "许可证企业",
        14,
        "assets/images/icon_pollution_licence_enter.png",
        Color.fromRGBO(179, 129, 127, 1)),
  ];

  Widget _getPollutionEnterRowItem(PollutionEnter pollutionEnter) {
    /*InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        print("点击了");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EnterListPage();
        }));
      },
    ),*/
    return Expanded(
      flex: 1,
      child: InkWell(
        splashColor: pollutionEnter.color.withOpacity(0.3),
        onTap: () {
          print("点击了");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EnterListPage();
          }));
        },
        child: Container(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: pollutionEnter.color.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    pollutionEnter.imagePath,
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          pollutionEnter.title,
                          style: TextStyle(
                            fontSize: 11,
                            color: pollutionEnter.color,
                          ),
                        ),
                        Text(
                          pollutionEnter.count.toString(),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      /*decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          StyleUtil.getBoxShadow(),
        ],
      ),*/
      child: Column(
        children: <Widget>[
          TitleWidget("污染源企业概况"),
          Row(
            children: <Widget>[
              _getPollutionEnterRowItem(_pollutionEnter[0]),
              Container(
                height: 30,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getPollutionEnterRowItem(_pollutionEnter[1]),
              Container(
                height: 30,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getPollutionEnterRowItem(_pollutionEnter[2]),
            ],
          ),
          Row(
            children: <Widget>[
              _getPollutionEnterRowItem(_pollutionEnter[3]),
              Container(
                height: 30,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getPollutionEnterRowItem(_pollutionEnter[4]),
              Container(
                height: 30,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getPollutionEnterRowItem(_pollutionEnter[5]),
            ],
          ),
          Row(
            children: <Widget>[
              _getPollutionEnterRowItem(_pollutionEnter[6]),
              Container(
                height: 30,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getPollutionEnterRowItem(_pollutionEnter[7]),
              Container(
                height: 30,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getPollutionEnterRowItem(_pollutionEnter[8]),
            ],
          ),
        ],
      ),
    );
  }
}

class SummaryStatisticsWidget extends StatefulWidget {
  SummaryStatisticsWidget({Key key}) : super(key: key);

  @override
  _SummaryStatisticsWidgetState createState() =>
      _SummaryStatisticsWidgetState();
}

class _SummaryStatisticsWidgetState extends State<SummaryStatisticsWidget> {
  final List<SummaryStatistics> _summaryStatistics = [
    SummaryStatistics(
      "监察执法",
      145,
      Color.fromRGBO(77, 167, 248, 1),
      "assets/images/icon_pollution_all_enter.png",
      "assets/images/bg_button3.png",
    ),
    SummaryStatistics(
      "项目审批",
      32,
      Color.fromRGBO(241, 190, 67, 1),
      "assets/images/icon_pollution_all_enter.png",
      "assets/images/bg_button2.png",
    ),
    SummaryStatistics(
      "信访投诉",
      5,
      Color.fromRGBO(136, 191, 89, 1),
      "assets/images/icon_pollution_all_enter.png",
      "assets/images/bg_button1.png",
    ),
  ];

  Widget _getSummaryStatisticsRowItem(SummaryStatistics summaryStatistics) {
    return Expanded(
      flex: 1,
      child: Container(
        color: summaryStatistics.color,
        padding: EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                summaryStatistics.backgroundPath,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  summaryStatistics.count.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                Text(
                  summaryStatistics.title,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Positioned(
              top: 2,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 14,
                  color: summaryStatistics.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TitleWidget("综合统计信息"),
          Row(
            children: <Widget>[
              _getSummaryStatisticsRowItem(_summaryStatistics[0]),
              SizedBox(
                width: 10,
              ),
              _getSummaryStatisticsRowItem(_summaryStatistics[1]),
              SizedBox(
                width: 10,
              ),
              _getSummaryStatisticsRowItem(_summaryStatistics[2]),
            ],
          ),
        ],
      ),
    );
  }
}

class BarChartWidget extends StatefulWidget {
  final Color color;
  final String title;
  final String subTitle;
  final String imagePath;

  BarChartWidget(
      {@required this.title,
      @required this.subTitle,
      @required this.color,
      @required this.imagePath,
      Key key})
      : super(key: key);

  @override
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  //final Color barColor = color;
  //final Color barBackgroundColor = const Color(0xff72d8bf);
  final double width = 6;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  StreamController<BarTouchResponse> barTouchedResultStreamController;

  int touchedGroupIndex;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, 5);
    final barGroup2 = makeGroupData(1, 6.5);
    final barGroup3 = makeGroupData(2, 5);
    final barGroup4 = makeGroupData(3, 7.5);
    final barGroup5 = makeGroupData(4, 9);
    final barGroup6 = makeGroupData(5, 11.5);
    final barGroup7 = makeGroupData(6, 6.5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;

    barTouchedResultStreamController = StreamController();
    barTouchedResultStreamController.stream
        .distinct()
        .listen((BarTouchResponse response) {
      if (response == null) {
        return;
      }

      if (response.spot == null) {
        setState(() {
          touchedGroupIndex = -1;
          showingBarGroups = List.of(rawBarGroups);
        });
        return;
      }

      touchedGroupIndex =
          showingBarGroups.indexOf(response.spot.touchedBarGroup);

      setState(() {
        if (response.touchInput is FlLongPressEnd) {
          touchedGroupIndex = -1;
          showingBarGroups = List.of(rawBarGroups);
        } else {
          showingBarGroups = List.of(rawBarGroups);
          if (touchedGroupIndex != -1) {
            showingBarGroups[touchedGroupIndex] =
                showingBarGroups[touchedGroupIndex].copyWith(
              barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                return rod.copyWith(color: Colors.yellow, y: rod.y + 1);
              }).toList(),
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.color,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                widget.subTitle,
                style: TextStyle(
                  color: Colours.secondary_text,
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: FlChart(
                  chart: BarChart(BarChartData(
                    barTouchData: BarTouchData(
                      touchTooltipData: TouchTooltipData(
                          tooltipBgColor: Colors.blueGrey,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((touchedSpot) {
                              String weekDay;
                              switch (touchedSpot.spot.x.toInt()) {
                                case 0:
                                  weekDay = '周一';
                                  break;
                                case 1:
                                  weekDay = '周二';
                                  break;
                                case 2:
                                  weekDay = '周三';
                                  break;
                                case 3:
                                  weekDay = '周四';
                                  break;
                                case 4:
                                  weekDay = '周五';
                                  break;
                                case 5:
                                  weekDay = '周六';
                                  break;
                                case 6:
                                  weekDay = '周日';
                                  break;
                              }
                              return TooltipItem(
                                  weekDay +
                                      '\n' +
                                      touchedSpot.spot.y.toString(),
                                  TextStyle(color: Colors.yellow));
                            }).toList();
                          }),
                      touchResponseSink: barTouchedResultStreamController.sink,
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: Colours.primary_text, fontSize: 11),
                          margin: 8,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return '一';
                              case 1:
                                return '二';
                              case 2:
                                return '三';
                              case 3:
                                return '四';
                              case 4:
                                return '五';
                              case 5:
                                return '六';
                              case 6:
                                return '日';
                              default:
                                return '未知';
                            }
                          }),
                      leftTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                  )),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 30,
              height: 30,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Image.asset(
                widget.imagePath,
                color: widget.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        y: y,
        color: widget.color,
        width: width,
        isRound: true,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: 20,
          color: widget.color.withOpacity(0.3),
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    barTouchedResultStreamController.close();
  }
}
