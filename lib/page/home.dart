import 'package:flutter/material.dart';
import 'package:pollution_source/model/model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'dart:ui';
import 'dart:math';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: false,
            snap: false,
            expandedHeight: 280.0,
            flexibleSpace: FlexibleSpaceBar(
              background: AqiWidget(),
            ),
          ),
          SliverToBoxAdapter(
            child: TodoTasksWidget(),
          ),
          SliverToBoxAdapter(
            child: AqiExamineWidget(),
          ),
          SliverToBoxAdapter(
            child: OnlineMonitorWidget(),
          ),
          SliverToBoxAdapter(
            child: WaterWidget(),
          ),
          /*SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            sliver: OnlineMonitorWidget(),
          ),*/
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 4.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.teal[100 * (index % 9)],
                  child: Text('grid item $index'),
                );
              },
              childCount: 20,
            ),
          ),
        ],
        onRefresh: () async {},
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
}

//空气质量考核达标
class AqiExamineWidget extends StatefulWidget {
  AqiExamineWidget({Key key}) : super(key: key);

  @override
  _AqiExamineWidgetState createState() => _AqiExamineWidgetState();
}

class _AqiExamineWidgetState extends State<AqiExamineWidget> {
  final List<AqiExamine> _aqiExamine = [
    AqiExamine("PM2.5", "assets/images/icon_aqi_examine_pm25.png", "年平均值", "27μg/m3", "目标值", "41μg/m³", "月平均值",
        "25μg/m³"),
    AqiExamine(
        "优良率", "assets/images/icon_aqi_examine_quality.png", "年平均值", "94.16%", "目标值", "91.4%", "优良天数", "145"),
  ];

  Widget _getAqiExamineColumnItem(AqiExamine aqiExamine,
      {Color color: Colours.grey_color}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 12),
            color: Color(0xFFDFDFDF),
            blurRadius: 25,
            spreadRadius: -9,
          ),
        ],
      ),
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
        horizontal: 16,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 12),
            color: Color(0xFFDFDFDF),
            blurRadius: 25,
            spreadRadius: -9,
          ),
        ],
      ),
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
        height: 80,
        child: Card(
          elevation: 6,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(
                image,
                fit: BoxFit.cover,
              ),
              InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  print('Card tapped.');
                },
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
                  )
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _getTodoTaskRowItem(
              "报警单待处理", "232", "assets/images/bg_alarm_manage_todo.png"),
          _getTodoTaskRowItem(
              "排口异常待审核", "45", "assets/images/bg_outlet_audit_todo.png"),
          _getTodoTaskRowItem(
              "因子异常待审核", "8", "assets/images/bg_factor_audit_todo.png"),
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
                  width: 20,
                  height: 20,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 12),
            color: Color(0xFFDFDFDF),
            blurRadius: 25,
            spreadRadius: -9,
          ),
        ],
      ),
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
