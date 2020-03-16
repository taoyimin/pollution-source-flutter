import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_svg/svg.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'dart:ui';
import 'dart:math';
import 'dart:async';

import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:pollution_source/widget/space_header.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/index/admin/index.dart';

class AdminIndexPage extends StatefulWidget {
  AdminIndexPage({Key key}) : super(key: key);

  @override
  _AdminIndexPageState createState() => _AdminIndexPageState();
}

class _AdminIndexPageState extends State<AdminIndexPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  IndexBloc _indexBloc;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _indexBloc = BlocProvider.of<IndexBloc>(context);
    _refreshCompleter = Completer<void>();
    SystemUtils.checkUpdate(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: EasyRefresh.custom(
        header: SpaceHeader(),
        firstRefresh: true,
        firstRefreshWidget: Gaps.empty,
        slivers: <Widget>[
          BlocListener<IndexBloc, IndexState>(
            listener: (context, state) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            },
            child: BlocBuilder<IndexBloc, IndexState>(
              builder: (context, state) {
                if (state is IndexLoaded) {
                  return SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        state.aqiStatistics.show
                            ? AqiStatisticsWidget(
                                aqiStatistics: state.aqiStatistics)
                            : HeaderWidget(),
                        state.todoTaskStatisticsList.length > 0
                            ? TodoTaskStatisticsWidget(
                                metaList: state.todoTaskStatisticsList,
                              )
                            : Gaps.empty,
                        state.aqiExamineList.length > 0
                            ? AqiExamineWidget(
                                aqiExamineList: state.aqiExamineList)
                            : Gaps.empty,
                        //WeekTrendWidget(),
                        //AlarmListWidget(),
                        state.onlineMonitorStatisticsList.length > 0
                            ? OnlineMonitorStatisticsWidget(
                                metaList: state.onlineMonitorStatisticsList,
                              )
                            : Gaps.empty,
                        state.waterStatisticsList.length > 0
                            ? WaterStatisticsWidget(
                                waterStatisticsList: state.waterStatisticsList,
                              )
                            : Gaps.empty,
                        state.pollutionEnterStatisticsList.length > 0
                            ? PollutionEnterStatisticsWidget(
                                metaList: state.pollutionEnterStatisticsList)
                            : Gaps.empty,
                        state.rainEnterStatisticsList.length > 0
                            ? RainEnterStatisticsWidget(
                                metaList: state.rainEnterStatisticsList)
                            : Gaps.empty,
                        state.reportStatisticsList.length > 0
                            ? ReportStatisticsWidget(
                                metaList: state.reportStatisticsList,
                              )
                            : Gaps.empty,
                        state.comprehensiveStatisticsList.length > 0
                            ? ComprehensiveStatisticsWidget(
                                metaList: state.comprehensiveStatisticsList,
                              )
                            : Gaps.empty,
                      ],
                    ),
                  );
                } else if (state is IndexLoading) {
                  return LoadingSliver();
                } else if (state is IndexError) {
                  return ErrorSliver(errorMessage: state.errorMessage);
                } else {
                  return ErrorSliver(errorMessage: 'BlocBuilder监听到未知的的状态');
                }
              },
            ),
          ),
        ],
        onRefresh: () async {
          _indexBloc.add(Load());
          return _refreshCompleter.future;
        },
      ),
    );
  }
}

//模块标题
class TitleWidget extends StatelessWidget {
  final String title;
  final Color color;

  TitleWidget(
      {Key key, @required this.title, this.color: Colours.primary_color})
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
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

//空气质量统计
class AqiStatisticsWidget extends StatelessWidget {
  final AqiStatistics aqiStatistics;

  AqiStatisticsWidget({Key key, @required this.aqiStatistics})
      : super(key: key);

  Widget _getAqiStatisticsRowItem(factorName, factorValue) {
    return Expanded(
      flex: 1, //设置一个宽度，防止宽度不同无法对齐
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            factorValue,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          Text(
            factorName,
            style: const TextStyle(
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
                padding: const EdgeInsets.fromLTRB(16, 35, 16, 0),
                //color: Colours.accent_color,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.all(5),
                      child: Image(
                          image:
                              AssetImage("assets/images/index_location.png")),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      aqiStatistics.areaName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        aqiStatistics.updateTime,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      aqiStatistics.aqi,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(3), //3像素圆角
                          ),
                          child: Text(
                            aqiStatistics.aqiLevel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          aqiStatistics.pp,
                          style: const TextStyle(
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
                        _getAqiStatisticsRowItem(
                          "PM2.5",
                          aqiStatistics.pm25,
                        ),
                        VerticalDividerWidget(
                          height: 26,
                          width: 1,
                          color: Colors.white,
                        ),
                        _getAqiStatisticsRowItem(
                          "PM10",
                          aqiStatistics.pm10,
                        ),
                        VerticalDividerWidget(
                          height: 26,
                          width: 1,
                          color: Colors.white,
                        ),
                        _getAqiStatisticsRowItem(
                          "SO₂",
                          aqiStatistics.so2,
                        ),
                        VerticalDividerWidget(
                          height: 26,
                          width: 1,
                          color: Colors.white,
                        ),
                        _getAqiStatisticsRowItem(
                          "NO₂",
                          aqiStatistics.no2,
                        ),
                        VerticalDividerWidget(
                          height: 26,
                          width: 1,
                          color: Colors.white,
                        ),
                        _getAqiStatisticsRowItem(
                          "O₃",
                          aqiStatistics.o3,
                        ),
                        VerticalDividerWidget(
                          height: 26,
                          width: 1,
                          color: Colors.white,
                        ),
                        _getAqiStatisticsRowItem(
                          "CO",
                          aqiStatistics.co,
                        ),
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

class HeaderWidget extends StatelessWidget {
  HeaderWidget({Key key}) : super(key: key);

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
                padding: const EdgeInsets.fromLTRB(16, 65, 16, 0),
                //color: Colours.accent_color,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      '欢迎使用\n污染源APP',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
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

//空气质量考核达标
class AqiExamineWidget extends StatelessWidget {
  final List<AqiExamine> aqiExamineList;

  AqiExamineWidget({Key key, @required this.aqiExamineList}) : super(key: key);

  Widget _getAqiExamineColumnItem(AqiExamine aqiExamine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 70,
        color: aqiExamine.color.withOpacity(0.3),
        padding: const EdgeInsets.all(10),
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
                    color: aqiExamine.color,
                  ),
                  Text(
                    aqiExamine.title,
                    style: TextStyle(
                      color: aqiExamine.color,
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
            VerticalDividerWidget(height: 40, width: 2, color: Colors.white),
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
            VerticalDividerWidget(height: 40, width: 2, color: Colors.white),
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
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: <Widget>[
          TitleWidget(title: "空气质量考核达标"),
          Column(
            children: aqiExamineList
                .map((aqiExamine) => _getAqiExamineColumnItem(aqiExamine))
                .toList(),
          ),
        ],
      ),
    );
  }
}

//水环境质量情况
class WaterStatisticsWidget extends StatelessWidget {
  final List<WaterStatistics> waterStatisticsList;

  WaterStatisticsWidget({Key key, this.waterStatisticsList}) : super(key: key);

  Widget _getWaterStatisticsColumnItem(WaterStatistics waterStatistics) {
    return Container(
      height: 70,
      color: waterStatistics.color.withOpacity(0.3),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
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
                  waterStatistics.imagePath,
                  width: 26,
                  height: 26,
                  color: waterStatistics.color,
                ),
                Text(
                  waterStatistics.title,
                  style: TextStyle(
                    color: waterStatistics.color,
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
                  "数量:${waterStatistics.count}",
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  "达标率:${waterStatistics.achievementRate}%",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          VerticalDividerWidget(height: 40, width: 2, color: Colors.white),
          Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "环比:${waterStatistics.monthOnMonth}%",
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  "同比:${waterStatistics.yearOnYear}%",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: <Widget>[
          TitleWidget(title: "水环境质量情况"),
          Column(
            children: waterStatisticsList
                .map((waterStatistics) =>
                    _getWaterStatisticsColumnItem(waterStatistics))
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// 代办任务统计
class TodoTaskStatisticsWidget extends StatelessWidget {
  final List<Meta> metaList;

  TodoTaskStatisticsWidget({Key key, this.metaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TitleWidget(title: "待办任务统计"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // 待处理督办单
              InkWellButton2(
                meta: metaList[0],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.orderList}?state=2');
                },
              ),
              Gaps.hGap6,
              // 超期待处理督办单
              InkWellButton2(
                meta: metaList[1],
                onTap: () {
                  Application.router.navigateTo(
                      context, '${Routes.orderList}?state=2&alarmLevel=3');
                },
              ),
              Gaps.hGap6,
              // 已办结督办单
              InkWellButton2(
                meta: metaList[2],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.orderList}?state=5');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 异常申报统计
class ReportStatisticsWidget extends StatelessWidget {
  final List<Meta> metaList;

  ReportStatisticsWidget({Key key, this.metaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TitleWidget(title: "异常申报(有效数)统计"),
          Row(
            children: <Widget>[
              // 长期停产
              InkWellButton3(
                meta: metaList[0],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.longStopReportList}?valid=0');
                },
              ),
              Gaps.hGap10,
              // 排口异常
              InkWellButton3(
                meta: metaList[1],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.dischargeReportList}?valid=0');
                },
              ),
              Gaps.hGap10,
              // 因子异常
              InkWellButton3(
                meta: metaList[2],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.factorReportList}?valid=0');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//在线监控点概况
class OnlineMonitorStatisticsWidget extends StatelessWidget {
  final List<Meta> metaList;

  OnlineMonitorStatisticsWidget({Key key, this.metaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: <Widget>[
          TitleWidget(title: "在线监控点概况"),
          Row(
            children: <Widget>[
              // 全部
              InkWellButton1(
                meta: metaList[0],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}');
                },
              ),
              VerticalDividerWidget(height: 40),
              // 在线
              InkWellButton1(
                meta: metaList[1],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}?state=1');
                },
              ),
              VerticalDividerWidget(height: 40),
              // 预警
              InkWellButton1(
                meta: metaList[2],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}?state=2');
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              // 超标
              InkWellButton1(
                meta: metaList[3],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}?state=3');
                },
              ),
              VerticalDividerWidget(height: 40),
              // 负值
              InkWellButton1(
                meta: metaList[4],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}?state=4');
                },
              ),
              VerticalDividerWidget(height: 40),
              // 超大值
              InkWellButton1(
                meta: metaList[5],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}?state=5');
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              // 零值
              InkWellButton1(
                meta: metaList[6],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}?state=6');
                },
              ),
              VerticalDividerWidget(height: 40),
              // 脱机
              InkWellButton1(
                meta: metaList[7],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}?state=7');
                },
              ),
              VerticalDividerWidget(height: 40),
              // 异常申报
              InkWellButton1(
                meta: metaList[8],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}?state=8');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//污染源企业概况
class PollutionEnterStatisticsWidget extends StatelessWidget {
  final List<Meta> metaList;

  PollutionEnterStatisticsWidget({Key key, this.metaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: <Widget>[
          TitleWidget(title: "污染源企业概况"),
          Row(
            children: <Widget>[
              //全部企业
              InkWellButton1(
                meta: metaList[0],
                onTap: () {
                  Application.router.navigateTo(context, '${Routes.enterList}?attentionLevel=');
                },
              ),
              VerticalDividerWidget(height: 30),
              //重点企业
              InkWellButton1(
                meta: metaList[1],
                onTap: () {
                  Application.router.navigateTo(
                      context, '${Routes.enterList}?attentionLevel=1');
                },
              ),
              VerticalDividerWidget(height: 30),
              //在线企业
              InkWellButton1(
                meta: metaList[2],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.enterList}?state=1&attentionLevel=');
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              //废水企业
              InkWellButton1(
                meta: metaList[3],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.enterList}?enterType=2&attentionLevel=');
                },
              ),
              VerticalDividerWidget(height: 30),
              //废气企业
              InkWellButton1(
                meta: metaList[4],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.enterList}?enterType=3&attentionLevel=');
                },
              ),
              VerticalDividerWidget(height: 30),
              //水气企业
              InkWellButton1(
                meta: metaList[5],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.enterList}?enterType=4&attentionLevel=');
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              //废水排口
              InkWellButton1(
                meta: metaList[6],
                onTap: () {
                  Application.router.navigateTo(
                      context, '${Routes.dischargeList}?dischargeType=outletType2');
                },
              ),
              VerticalDividerWidget(height: 30),
              //废气排口
              InkWellButton1(
                meta: metaList[7],
                onTap: () {
                  Application.router.navigateTo(
                      context, '${Routes.dischargeList}?dischargeType=outletType3');
                },
              ),
              VerticalDividerWidget(height: 30),
              //许可证企业
              InkWellButton1(
                meta: metaList[8],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.enterList}?enterType=5&attentionLevel=');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//雨水企业概况
class RainEnterStatisticsWidget extends StatelessWidget {
  final List<Meta> metaList;

  RainEnterStatisticsWidget({Key key, this.metaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: <Widget>[
          TitleWidget(title: "雨水企业概况"),
          Row(
            children: <Widget>[
              //全部企业
              InkWellButton1(
                meta: metaList[0],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.enterList}?enterType=1');
                },
              ),
              VerticalDividerWidget(height: 30),
              //在线企业
              InkWellButton1(
                meta: metaList[1],
                onTap: () {
                  Application.router.navigateTo(
                      context, '${Routes.enterList}?enterType=1&state=1');
                },
              ),
              VerticalDividerWidget(height: 30),
              //排口总数
              InkWellButton1(
                meta: metaList[2],
                onTap: () {
                  Application.router.navigateTo(
                      context, '${Routes.dischargeList}?dischargeType=outletType1');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//综合统计信息
class ComprehensiveStatisticsWidget extends StatelessWidget {
  final List<Meta> metaList;

  ComprehensiveStatisticsWidget({Key key, this.metaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TitleWidget(title: "综合统计信息"),
          Row(
            children: <Widget>[
              //监察执法
              InkWellButton3(
                meta: metaList[0],
                onTap: () {},
              ),
              Gaps.hGap10,
              //项目审批
              InkWellButton3(
                meta: metaList[1],
                onTap: () {},
              ),
              Gaps.hGap10,
              //信访投诉
              InkWellButton3(
                meta: metaList[2],
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeekTrendWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        child: Column(
          children: <Widget>[
            TitleWidget(title: "最近一周变化趋势"),
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
                  Gaps.hGap10,
                  Expanded(
                    flex: 1,
                    child: BarChartWidget(
                        title: "PM2.5",
                        subTitle: "细颗粒物",
                        color: Color.fromRGBO(241, 190, 67, 1),
                        imagePath: "assets/images/icon_aqi_examine_pm25.png"),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  int touchedIndex;

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
              Gaps.vGap4,
              Text(
                widget.subTitle,
                style: const TextStyle(
                  color: Colours.secondary_text,
                  fontSize: 12,
                ),
              ),
              Gaps.vGap10,
              Expanded(
                child: BarChart(BarChartData(
                  barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.blueGrey,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String weekDay;
                          switch (group.x.toInt()) {
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
                          return BarTooltipItem(
                            weekDay + '\n' + rod.y.toString(),
                            TextStyle(
                              color: Colors.yellow,
                            ),
                          );
                        },
                      ),
                      touchCallback: (BarTouchResponse barTouchResponse) {
                        setState(() {
                          if (barTouchResponse.spot != null &&
                              barTouchResponse.touchInput is! FlPanEnd &&
                              barTouchResponse.touchInput is! FlLongPressEnd) {
                            touchedIndex =
                                barTouchResponse.spot.touchedBarGroupIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      }),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      textStyle:
                          TextStyle(color: Colours.primary_text, fontSize: 11),
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
                      },
                    ),
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
        //isRound: true,
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
    barTouchedResultStreamController.close();
    super.dispose();
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
          TitleWidget(title: "报警管理单统计"),
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

  factory SimplePieChart.withSampleData() {
    return new SimplePieChart(
      _createSampleData(),
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
          position: charts.BehaviorPosition.end,
          horizontalFirst: false,
          cellPadding: new EdgeInsets.only(right: 24.0, bottom: 4.0, top: 4.0),
          showMeasures: false,
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          entryTextStyle: charts.TextStyleSpec(),
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
          "待处理            92*个", 92, charts.Color.fromHex(code: "#4DA7F8")),
      new LinearAlarms(
          "待审核            123*个", 123, charts.Color.fromHex(code: "#F1BE43")),
      new LinearAlarms(
          "已退回            42*个", 42, charts.Color.fromHex(code: "#E9776F")),
      new LinearAlarms(
          "已办结            14*个", 14, charts.Color.fromHex(code: "#88BF59")),
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

class LinearAlarms {
  final String state;
  final int count;
  final charts.Color color;

  LinearAlarms(this.state, this.count, this.color);
}
