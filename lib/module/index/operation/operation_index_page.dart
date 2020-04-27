import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/collection/collection_bloc.dart';
import 'package:pollution_source/module/common/collection/collection_event.dart';
import 'package:pollution_source/module/common/collection/monitor/monitor_statistics_repository.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
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

  /// 监控点统计Bloc
  final CollectionBloc monitorStatisticsBloc =
      CollectionBloc(collectionRepository: MonitorStatisticsRepository());
  final EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    _indexBloc = BlocProvider.of<IndexBloc>(context);
    _refreshCompleter = Completer<void>();
  }

  @override
  void dispose() {
    // 释放资源
    _refreshController.dispose();
    super.dispose();
  }

  /// 获取监控点统计接口请求参数
  Map<String, dynamic> _getRequestParam() {
    return MonitorStatisticsRepository.createParams(
      userType: '3',
      userId: '${SpUtil.getInt(Constant.spUserId)}',
      outType: '0',
      attentionLevel: '${SpUtil.getString(Constant.spAttentionLevel)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: EasyRefresh.custom(
        controller: _refreshController,
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
                        MonitorStatisticsWidget(
                          collectionBloc: monitorStatisticsBloc,
                          onReloadTap: () {
                            monitorStatisticsBloc.add(
                                CollectionLoad(params: _getRequestParam()));
                          },
                        ),
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
                  return ErrorSliver(
                    errorMessage: state.errorMessage,
                    onReloadTap: () => _refreshController.callRefresh(),
                  );
                } else {
                  return ErrorSliver(
                    errorMessage: 'BlocBuilder监听到未知的的状态',
                    onReloadTap: () => _refreshController.callRefresh(),
                  );
                }
              },
            ),
          ),
        ],
        onRefresh: () async {
          _indexBloc.add(Load());
          monitorStatisticsBloc.add(CollectionLoad(params: _getRequestParam()));
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
              ),
              Gaps.hGap6,
              // 超期任务数
              InkWellButton2(
                meta: metaList[1],
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
              InkWellButton3(
                meta: metaList[0],
              ),
              Gaps.hGap10,
              InkWellButton3(
                meta: metaList[1],
              ),
              Gaps.hGap10,
              InkWellButton3(
                meta: metaList[2],
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
          InkWellButtonGrid(metaList: metaList),
        ],
      ),
    );
  }
}
