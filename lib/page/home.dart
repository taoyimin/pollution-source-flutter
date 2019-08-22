import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pollution_source/model/model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'dart:ui';

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
            child: WaterWidget(),
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

//空气质量考核
class AqiExamineWidget extends StatefulWidget {
  AqiExamineWidget({Key key}) : super(key: key);

  @override
  _AqiExamineWidgetState createState() => _AqiExamineWidgetState();
}

class _AqiExamineWidgetState extends State<AqiExamineWidget> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

//地表水统计
class WaterWidget extends StatefulWidget {
  WaterWidget({Key key}) : super(key: key);

  @override
  _WaterWidgetState createState() => _WaterWidgetState();
}

class _WaterWidgetState extends State<WaterWidget>
    with SingleTickerProviderStateMixin {
  final List _tabs = [
    {"title": "国控断面", "imagePath": "assets/images/state.png"},
    {"title": "省控断面", "imagePath": "assets/images/province.png"},
    {"title": "县界断面", "imagePath": "assets/images/county.png"},
    {"title": "饮用水断面", "imagePath": "assets/images/water.png"},
    {"title": "重金属断面", "imagePath": "assets/images/metal.png"},
  ];

  List<Water> _waters = [
    Water(423, 90.4, 54.4, 67.4),
    Water(41, 90.4, 54.4, 67.4),
    Water(41, 90.4, 54.4, 67.4),
    Water(41, 90.4, 54.4, 67.4),
    Water(41, 90.4, 54.4, 67.4),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  Widget _getWaterTabBarItem(String title, String imagePath) {
    return Tab(
      child: Row(
        children: <Widget>[
          Image.asset(
            imagePath,
            width: 16,
            height: 16,
            color: Colours.primary_color,
          ),
          SizedBox(
            width: 3,
          ),
          Text(title)
        ],
      ),
    );
  }

  Widget _getWaterCircularPercentItem(String title, double value,
      {Color progressColor = Colours.primary_color,
      Color backgroundColor = Colours.grey_color}) {
    return CircularPercentIndicator(
      radius: 80.0,
      lineWidth: 8.0,
      animation: true,
      percent: value,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "${value * 100}%",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: progressColor,
      backgroundColor: backgroundColor,
    );
  }

  Widget _getWaterTabBarViewItem(Water water) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 8.0,
                animation: true,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "4",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                    Text(
                      "数量",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colours.secondary_text),
                    ),
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
            ],
          ),
          _getWaterCircularPercentItem("同比", 0.7, progressColor: Colors.lightBlueAccent, backgroundColor: Colors.lightBlueAccent.withOpacity(0.2)),
          _getWaterCircularPercentItem("环比", 0.09, progressColor: Colors.deepOrangeAccent, backgroundColor: Colors.deepOrangeAccent.withOpacity(0.2)),
          _getWaterCircularPercentItem("达标率", 0.45, progressColor: Colors.lightGreen, backgroundColor: Colors.lightGreen.withOpacity(0.2)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Column(
          children: <Widget>[
            Container(
              height: 35,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TabBar(
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(horizontal: 6),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colours.primary_color,
                labelColor: Colours.primary_color,
                unselectedLabelColor: Colours.secondary_text,
                labelStyle: TextStyle(
                  fontSize: 12,
                ),
                controller: _tabController,
                tabs: this._tabs.map((value) {
                  return _getWaterTabBarItem(
                      value["title"], value["imagePath"]);
                }).toList(),
              ),
            ),
            Container(
              height: 120,
              child: TabBarView(
                controller: _tabController,
                children: this._waters.map((value) {
                  return _getWaterTabBarViewItem(value);
                }).toList(),
              ),
            ),
          ],
        ));
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
        width: 115,
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
      padding: EdgeInsets.all(6),
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
