import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/monitor/detail/monitor_detail_bloc.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_page.dart';

import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/widget/custom_header.dart';
import 'package:pollution_source/module/monitor/list/monitor_list.dart';

class MonitorListPage extends StatefulWidget {
  final String enterId;
  final String dischargeId;
  final String monitorType;
  final String state;

  MonitorListPage({
    this.enterId = '',
    this.dischargeId = '',
    this.monitorType = '',
    this.state = '',
  });

  @override
  _MonitorListPageState createState() => _MonitorListPageState();
}

class _MonitorListPageState extends State<MonitorListPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  MonitorListBloc _monitorListBloc;
  EasyRefreshController _refreshController;
  TextEditingController _editController;
  Completer<void> _refreshCompleter;
  String areaCode = '';

  @override
  void initState() {
    super.initState();
    _monitorListBloc = BlocProvider.of<MonitorListBloc>(context);
    _refreshController = EasyRefreshController();
    _refreshCompleter = Completer<void>();
    _scrollController = ScrollController();
    _editController = TextEditingController();
    //首次加载
    _monitorListBloc.add(MonitorListLoad(
      enterId: widget.enterId,
      dischargeId: widget.dischargeId,
      monitorType: widget.monitorType,
      state: widget.state,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
    _editController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: extended.NestedScrollView(
        controller: _scrollController,
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + kToolbarHeight;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            ListHeaderWidget(
              title: '监测数据列表',
              subtitle: '展示监测数据列表，点击列表项查看该监测数据的详细信息',
              background: 'assets/images/button_bg_red.png',
              image: 'assets/images/monitor_list_bg_image.png',
              color: Colors.red,
              showSearch: true,
              editController: _editController,
              scrollController: _scrollController,
              onSearchPressed: () => _refreshController.callRefresh(),
              areaPickerListener: (areaId) {
                areaCode = areaId;
              },
              popupMenuButton: PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  UIUtils.getSelectView(Icons.message, '发起群聊', 'A'),
                  UIUtils.getSelectView(Icons.group_add, '添加服务', 'B'),
                  UIUtils.getSelectView(Icons.cast_connected, '扫一扫码', 'C'),
                ],
                onSelected: (String action) {
                  // 点击选项的时候
                  switch (action) {
                    case 'A':
                      break;
                    case 'B':
                      break;
                    case 'C':
                      break;
                  }
                },
              ),
            ),
          ];
        },
        body: extended.NestedScrollViewInnerScrollPositionKeyWidget(
          Key('list'),
          EasyRefresh.custom(
            controller: _refreshController,
            header: UIUtils.getRefreshClassicalHeader(),
            footer: UIUtils.getLoadClassicalFooter(),
            slivers: <Widget>[
              BlocListener<MonitorListBloc, MonitorListState>(
                listener: (context, state) {
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer();
                },
                child: BlocBuilder<MonitorListBloc, MonitorListState>(
                  builder: (context, state) {
                    if (state is MonitorListLoading) {
                      return PageLoadingWidget();
                    } else if (state is MonitorListEmpty) {
                      return PageEmptyWidget();
                    } else if (state is MonitorListError) {
                      return PageErrorWidget(errorMessage: state.errorMessage);
                    } else if (state is MonitorListLoaded) {
                      if (!state.hasNextPage)
                        _refreshController.finishLoad(
                            noMore: !state.hasNextPage, success: true);
                      return _buildPageLoadedList(state.monitorList);
                    } else {
                      return PageErrorWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
                    }
                  },
                ),
              ),
            ],
            onRefresh: () async {
              _monitorListBloc.add(MonitorListLoad(
                isRefresh: true,
                enterName: _editController.text,
                areaCode: areaCode,
                enterId: widget.enterId,
                dischargeId: widget.dischargeId,
                monitorType: widget.monitorType,
                state: widget.state,
              ));
              return _refreshCompleter.future;
            },
            onLoad: () async {
              _monitorListBloc.add(MonitorListLoad(
                enterName: _editController.text,
                areaCode: areaCode,
                enterId: widget.enterId,
                dischargeId: widget.dischargeId,
                monitorType: widget.monitorType,
                state: widget.state,
              ));
              return _refreshCompleter.future;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageLoadedList(List<Monitor> monitorList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BlocProvider(
                        builder: (context) => MonitorDetailBloc(),
                        child: MonitorDetailPage(
                          monitorId: monitorList[index].monitorId,
                        ),
                      );
                    },
                  ),
                );
              },
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
                      Container(
                        padding: const EdgeInsets.all(3),
                        child: Image.asset(
                          monitorList[index].imagePath,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Gaps.hGap10,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                '${monitorList[index].enterName}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Gaps.vGap6,
                            LabelWrapWidget(
                                labelList: monitorList[index].labelList),
                            monitorList[index].labelList.length == 0
                                ? Gaps.empty
                                : Gaps.vGap6,
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: ListTileWidget(
                                      '监控点名称：${monitorList[index].monitorName}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ListTileWidget(
                                      '监控点类别：${monitorList[index].monitorCategoryStr}'),
                                ),
                              ],
                            ),
                            Gaps.vGap6,
                            ListTileWidget(
                                '监控点地址：${monitorList[index].monitorAddress}'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: monitorList.length,
      ),
    );
  }
}
