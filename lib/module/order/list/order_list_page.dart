import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/widget/custom_header.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';

import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/order/detail/order_detail_bloc.dart';
import 'package:pollution_source/module/order/detail/order_detail_page.dart';
import 'package:pollution_source/module/order/list/order_list.dart';

class OrderListPage extends StatefulWidget {
  final String state;
  final String enterId;
  final String monitorId;

  OrderListPage({this.state = '', this.enterId = '', this.monitorId = ''});

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
    _orderListBloc.add(OrderListLoad(
      state: widget.state,
      enterId: widget.enterId,
      monitorId: widget.monitorId,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
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
              title: '报警管理单列表',
              subtitle: '展示报警管理单列表，点击列表项查看该报警管理单的详细信息',
              background: 'assets/images/button_bg_blue.png',
              image: 'assets/images/order_list_bg_image.png',
              color: Colors.lightBlue,
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
                      return _buildPageLoadedList(state.orderList);
                    } else {
                      return PageErrorWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
                    }
                  },
                ),
              ),
            ],
            onRefresh: () async {
              _orderListBloc.add(OrderListLoad(
                isRefresh: true,
                enterName: _editController.text,
                areaCode: areaCode,
                state: widget.state,
                enterId: widget.enterId,
                monitorId: widget.monitorId,
              ));
              return _refreshCompleter.future;
            },
            onLoad: () async {
              _orderListBloc.add(OrderListLoad(
                enterName: _editController.text,
                areaCode: areaCode,
                state: widget.state,
                enterId: widget.enterId,
                monitorId: widget.monitorId,
              ));
              return _refreshCompleter.future;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageLoadedList(List<Order> orderList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BlocProvider(
                    builder: (context) => OrderDetailBloc(),
                    child: OrderDetailPage(
                      orderId: orderList[index].orderId,
                    ),
                  );
                }));
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${orderList[index].enterName}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Gaps.vGap6,
                      LabelWrapWidget(labelList: orderList[index].labelList),
                      orderList[index].labelList.length == 0
                          ? Gaps.empty
                          : Gaps.vGap6,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '监控点名称：${orderList[index].monitorName}'),
                          ),
                          Expanded(
                            flex: 1,
                            child:
                            ListTileWidget('区域：${orderList[index].districtName}'),
                          ),
                        ],
                      ),
                      Gaps.vGap6,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '报警时间：${orderList[index].alarmDateStr}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '报警单状态：${orderList[index].orderStateStr}'),
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
}
