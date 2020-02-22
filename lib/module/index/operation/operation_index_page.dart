import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/index/admin/index_page.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/widget/space_header.dart';

import 'operation_index_bloc.dart';
import 'operation_index_event.dart';
import 'operation_index_state.dart';

class OperationIndexPage extends StatefulWidget {
  OperationIndexPage({Key key}) : super(key: key);

  @override
  _OperationIndexPageState createState() => _OperationIndexPageState();
}

class _OperationIndexPageState extends State<OperationIndexPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  Completer<void> _refreshCompleter;
  IndexBloc _indexBloc;

  @override
  void initState() {
    super.initState();
    _indexBloc = BlocProvider.of<IndexBloc>(context);
    _refreshCompleter = Completer<void>();
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
                        HeaderWidget(),
                        state.inspectionStatisticsList.length > 0
                            ? RoutineInspectionStatisticsWidget(
                            metaList: state.inspectionStatisticsList)
                            : Gaps.empty,
                        state.onlineMonitorStatisticsList.length > 0
                            ? OnlineMonitorStatisticsWidget(
                          metaList: state.onlineMonitorStatisticsList,
                        )
                            : Gaps.empty,
                        state.pollutionEnterStatisticsList.length > 0
                            ? PollutionEnterStatisticsWidget(
                            metaList: state.pollutionEnterStatisticsList)
                            : Gaps.empty,
                        state.orderStatisticsList.length > 0
                            ? OrderStatisticsWidget(
                            metaList: state.orderStatisticsList)
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
            bottom: 20,
            child: Image.asset(
              "assets/images/image_operation_index_header.png",
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(16, 75, 16, 0),
                //color: Colours.accent_color,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      '欢迎使用\n运维APP',
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

/// 常规巡检概况
class RoutineInspectionStatisticsWidget extends StatelessWidget {
  final List<Meta> metaList;

  RoutineInspectionStatisticsWidget({Key key, this.metaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TitleWidget(title: "常规巡检概况"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // 待巡检任务数
              InkWellButton2(
                meta: metaList[0],
                onTap: () {
                  Application.router.navigateTo(
                      context, '${Routes.routineInspectionList}?state=1');
                },
              ),
              Gaps.hGap6,
              // 超期任务数
              InkWellButton2(
                meta: metaList[1],
                onTap: () {
                  Application.router.navigateTo(
                      context, '${Routes.routineInspectionList}?state=2');
                },
              ),
              Gaps.hGap6,
              // 已巡检任务数
              InkWellButton2(
                meta: metaList[2],
                onTap: () {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('暂不支持查询已巡检任务'),
                      action: SnackBarAction(
                          label: '我知道了',
                          textColor: Colours.primary_color,
                          onPressed: () {}),
                    ),
                  );
                },
              ),
            ],
          ),
          //RoutineInspectionTabViewWidget(),
        ],
      ),
    );
  }
}

@deprecated
class RoutineInspectionTabViewWidget extends StatefulWidget {
  @override
  _RoutineInspectionTabViewWidgetState createState() =>
      _RoutineInspectionTabViewWidgetState();
}

@deprecated
class _RoutineInspectionTabViewWidgetState
    extends State<RoutineInspectionTabViewWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          indicatorColor: Colours.primary_color,
          labelColor: Colours.primary_color,
          unselectedLabelColor: Colours.primary_color.withOpacity(0.5),
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: '离我最近',
            ),
            Tab(
              text: '即将截止',
            ),
          ],
        ),
        Container(
          height: 250,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        UIUtils.getBoxShadow(),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Gaps.hGap10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  '企业名称企业名称企业名称企业',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Gaps.vGap6,
                              Row(
                                children: <Widget>[
                                  ListTileWidget('地址：企业名称企业名称企业名称'),
                                  ListTileWidget('距离我500米'),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Gaps.vGap6,
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        UIUtils.getBoxShadow(),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Gaps.hGap10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  '企业名称企业名称企业名称企业',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Gaps.vGap6,
                              Row(
                                children: <Widget>[
                                  ListTileWidget('地址：企业名称企业名称企业名称'),
                                  ListTileWidget('距离我500米'),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Gaps.vGap6,
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        UIUtils.getBoxShadow(),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Gaps.hGap10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  '企业名称企业名称企业名称企业',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Gaps.vGap6,
                              Row(
                                children: <Widget>[
                                  ListTileWidget('地址：企业名称企业名称企业名称'),
                                  ListTileWidget('距离我500米'),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 100,
                width: 200,
                child: Text('222'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 在线监控点概况
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
              //全部
              InkWellButton1(
                ratio: 1.15,
                meta: metaList[0],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}');
                },
              ),
              VerticalDividerWidget(height: 40),
              //在线
              InkWellButton1(
                ratio: 1.15,
                meta: metaList[1],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}?state=1');
                },
              ),
              VerticalDividerWidget(height: 40),
              //预警
              InkWellButton1(
                ratio: 1.15,
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
              //超标
              InkWellButton1(
                ratio: 1.15,
                meta: metaList[3],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}?state=3');
                },
              ),
              VerticalDividerWidget(height: 40),
              //脱机
              InkWellButton1(
                ratio: 1.15,
                meta: metaList[4],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}?state=4');
                },
              ),
              VerticalDividerWidget(height: 40),
              //异常
              InkWellButton1(
                ratio: 1.15,
                meta: metaList[5],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.monitorList}?state=5');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 督办单统计
class OrderStatisticsWidget extends StatelessWidget {
  final List<Meta> metaList;

  OrderStatisticsWidget({Key key, this.metaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TitleWidget(title: "报警管理单概况"),
          Row(
            children: <Widget>[
              // 督办单待处理数
              InkWellButton3(
                meta: metaList[0],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.orderList}?state=2');
                },
              ),
              Gaps.hGap10,
              // 督办单退回数
              InkWellButton3(
                meta: metaList[1],
                onTap: () {
                  Application.router.navigateTo(
                      context, '${Routes.orderList}?state=4');
                },
              ),
              Gaps.hGap10,
              // 督办单已办结数
              InkWellButton3(
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

/// 污染源企业概况
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
                  Application.router.navigateTo(context, '${Routes.enterList}');
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
                      .navigateTo(context, '${Routes.enterList}?state=1');
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
                      .navigateTo(context, '${Routes.enterList}?enterType=2');
                },
              ),
              VerticalDividerWidget(height: 30),
              //废气企业
              InkWellButton1(
                meta: metaList[4],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.enterList}?enterType=3');
                },
              ),
              VerticalDividerWidget(height: 30),
              //水气企业
              InkWellButton1(
                meta: metaList[5],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.enterList}?enterType=4');
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
                      context, '${Routes.dischargeList}?dischargeType=2');
                },
              ),
              VerticalDividerWidget(height: 30),
              //废气排口
              InkWellButton1(
                meta: metaList[7],
                onTap: () {
                  Application.router.navigateTo(
                      context, '${Routes.dischargeList}?dischargeType=3');
                },
              ),
              VerticalDividerWidget(height: 30),
              //许可证企业
              InkWellButton1(
                meta: metaList[8],
                onTap: () {
                  Application.router
                      .navigateTo(context, '${Routes.enterList}?enterType=5');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
