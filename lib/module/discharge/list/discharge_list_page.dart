import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/discharge/detail/discharge_detail_bloc.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_page.dart';

import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'discharge_list.dart';

class DischargeListPage extends StatefulWidget {
  final String enterId;
  final String dischargeType;
  final String state;

  DischargeListPage({
    this.enterId = '',
    this.dischargeType = '',
    this.state = '',
  });

  @override
  _DischargeListPageState createState() => _DischargeListPageState();
}

class _DischargeListPageState extends State<DischargeListPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  DischargeListBloc _dischargeListBloc;
  EasyRefreshController _refreshController;
  TextEditingController _editController;
  Completer<void> _refreshCompleter;
  String areaCode = '';

  @override
  void initState() {
    super.initState();
    _dischargeListBloc = BlocProvider.of<DischargeListBloc>(context);
    _refreshController = EasyRefreshController();
    _refreshCompleter = Completer<void>();
    _scrollController = ScrollController();
    _editController = TextEditingController();
    //首次加载
    _dischargeListBloc.add(DischargeListLoad(
      enterId: widget.enterId,
      dischargeType: widget.dischargeType,
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
              title: '排口列表',
              subtitle: '展示排口列表，点击列表项查看该排口的详细信息',
              background: 'assets/images/button_bg_yellow.png',
              image: 'assets/images/discharge_list_bg_image.png',
              color: Colors.orangeAccent,
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
              BlocListener<DischargeListBloc, DischargeListState>(
                listener: (context, state) {
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer();
                },
                child: BlocBuilder<DischargeListBloc, DischargeListState>(
                  builder: (context, state) {
                    if (state is DischargeListLoading) {
                      return PageLoadingWidget();
                    } else if (state is DischargeListEmpty) {
                      return PageEmptyWidget();
                    } else if (state is DischargeListError) {
                      return PageErrorWidget(errorMessage: state.errorMessage);
                    } else if (state is DischargeListLoaded) {
                      if (!state.hasNextPage)
                        _refreshController.finishLoad(
                            noMore: !state.hasNextPage, success: true);
                      return _buildPageLoadedList(state.dischargeList);
                    } else {
                      return PageErrorWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
                    }
                  },
                ),
              ),
            ],
            onRefresh: () async {
              _dischargeListBloc.add(DischargeListLoad(
                isRefresh: true,
                enterName: _editController.text,
                areaCode: areaCode,
                enterId: widget.enterId,
                dischargeType: widget.dischargeType,
                state: widget.state,
              ));
              return _refreshCompleter.future;
            },
            onLoad: () async {
              _dischargeListBloc.add(DischargeListLoad(
                enterName: _editController.text,
                areaCode: areaCode,
                enterId: widget.enterId,
                dischargeType: widget.dischargeType,
                state: widget.state,
              ));
              return _refreshCompleter.future;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageLoadedList(List<Discharge> dischargeList) {
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
                        builder: (context) => DischargeDetailBloc(),
                        child: DischargeDetailPage(
                          dischargeId: dischargeList[index].dischargeId,
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
                          dischargeList[index].imagePath,
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
                                '${dischargeList[index].enterName}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Gaps.vGap6,
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: ListTileWidget(
                                      '排口名称：${dischargeList[index].dischargeName}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ListTileWidget(
                                      '排口类型：${dischargeList[index].dischargeTypeStr}'),
                                ),
                              ],
                            ),
                            Gaps.vGap6,
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: ListTileWidget(
                                      '排放规律：${dischargeList[index].dischargeRuleStr}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ListTileWidget(
                                      '排口类别：${dischargeList[index].dischargeCategoryStr}'),
                                ),
                              ],
                            ),
                            Gaps.vGap6,
                            ListTileWidget(
                                '排口地址：${dischargeList[index].dischargeAddress}'),
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
        childCount: dischargeList.length,
      ),
    );
  }
}
