import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/page/task_detail_old.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_util.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'order_list.dart';

class OrderListPage extends StatefulWidget {
  final String state;

  OrderListPage({this.state = ''});

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  OrderListBloc _orderListBloc;
  EasyRefreshController _refreshController;
  TextEditingController _editController;
  Completer<void> _refreshCompleter;
  String areaCode = '';

  @override
  void initState() {
    super.initState();
    _orderListBloc = BlocProvider.of<OrderListBloc>(context);
    _refreshController = EasyRefreshController();
    _refreshCompleter = Completer<void>();
    _scrollController = ScrollController();
    _editController = TextEditingController();
    //首次加载
    _orderListBloc.dispatch(OrderListLoad(state: widget.state));
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
    _editController.dispose();
  }

  Widget _getPageLoadedList(List<Order> orderList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellWidget(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return TaskDetailPage();
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
                      getBoxShadow(),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${orderList[index].enterName}',
                        style:const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Gaps.vGap6,
                      LabelWrapWidget(labelList: orderList[index].labelList),
                      orderList[index].labelList.length == 0
                          ? Gaps.empty
                          :Gaps.vGap6,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '监控点名称：${orderList[index].outletName}'),
                          ),
                          Expanded(
                            flex: 1,
                            child:
                                ListTileWidget('区域：${orderList[index].area}'),
                          ),
                        ],
                      ),
                      Gaps.vGap6,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '报警时间：${orderList[index].alarmTime}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '报警单状态：${orderList[index].statue}'),
                          ),
                        ],
                      ),
                      Gaps.vGap6,
                      ListTileWidget('报警描述：${orderList[index].alarmRemark}'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: orderList.length,
      ),
    );
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
              title: '报警管理单列表',
              subtitle: '展示报警管理单列表，点击列表项查看该报警管理单的详细信息',
              background: 'assets/images/button_bg_green.png',
              image: 'assets/images/task_list_bg_image.png',
              color: Color(0xFF29D0BF),
              showSearch: true,
              editController: _editController,
              scrollController: _scrollController,
              onSearchPressed: () => _refreshController.callRefresh(),
              areaPickerListener: (areaId) {
                areaCode = areaId;
              },
              popupMenuButton: PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  selectView(Icons.message, '发起群聊', 'A'),
                  selectView(Icons.group_add, '添加服务', 'B'),
                  selectView(Icons.cast_connected, '扫一扫码', 'C'),
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
            header: getRefreshClassicalHeader(),
            footer: getLoadClassicalFooter(),
            slivers: <Widget>[
              BlocListener<OrderListBloc, OrderListState>(
                listener: (context, state) {
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer();
                },
                child: BlocBuilder<OrderListBloc, OrderListState>(
                  builder: (context, state) {
                    if (state is OrderListLoading) {
                      return PageLoadingWidget();
                    } else if (state is OrderListEmpty) {
                      return PageEmptyWidget();
                    } else if (state is OrderListError) {
                      return PageErrorWidget(errorMessage: state.errorMessage);
                    } else if (state is OrderListLoaded) {
                      if (!state.hasNextPage)
                        _refreshController.finishLoad(
                            noMore: !state.hasNextPage, success: true);
                      return _getPageLoadedList(state.orderList);
                    } else {
                      return SliverFillRemaining();
                    }
                  },
                ),
              ),
            ],
            onRefresh: () async {
              _orderListBloc.dispatch(OrderListLoad(
                isRefresh: true,
                enterName: _editController.text,
                areaCode: areaCode,
                state: widget.state,
              ));
              return _refreshCompleter.future;
            },
            onLoad: () async {
              _orderListBloc.dispatch(OrderListLoad(
                enterName: _editController.text,
                areaCode: areaCode,
                state: widget.state,
              ));
              return _refreshCompleter.future;
            },
          ),
        ),
      ),
    );
  }
}
