import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/page/task_detail_old.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/dimens.dart';
import 'package:pollution_source/util/ui_util.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/widget/sliver_appbar.dart';

import 'order_list.dart';

class OrderListPage extends StatefulWidget {
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
    _refreshController = EasyRefreshController();
    _refreshCompleter = Completer<void>();
    _orderListBloc = BlocProvider.of<OrderListBloc>(context);
    _orderListBloc.dispatch(OrderListLoad());
    _scrollController = ScrollController();
    _editController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
    _editController.dispose();
  }

  //根据报警类型model获取报警类型widget
  List<Widget> _getAlarmTypeWidgetList(List<AlarmType> alarmTypeList) {
    return alarmTypeList.map((alarmType) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: alarmType.color.withOpacity(0.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              alarmType.imagePath,
              width: 8,
              height: 8,
              color: alarmType.color,
            ),
            Text(
              alarmType.name,
              style: TextStyle(color: alarmType.color, fontSize: 10),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _getPageLoadedWidget(List<Order> orderList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimens.gap_dp8, vertical: Dimens.gap_dp5),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(Dimens.gap_dp12),
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
                        orderList[index].name,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Wrap(
                        spacing: 6,
                        runSpacing: 3,
                        children: _getAlarmTypeWidgetList(
                            orderList[index].alarmTypeList),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              "排口名称：${orderList[index].outletName}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colours.secondary_text,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "区域：${orderList[index].area}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colours.secondary_text,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              "报警时间：${orderList[index].alarmTime}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colours.secondary_text,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "报警单状态：${orderList[index].statue}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colours.secondary_text,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "报警描述：${orderList[index].alarmRemark}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colours.secondary_text,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
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
                    ),
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
            ListSliverAppbarWidget(
              title: '报警管理单列表',
              subtitle: '展示报警管理单列表，点击列表项查看该报警管理单的详细信息',
              background: 'assets/images/button_bg_green.png',
              image: 'assets/images/task_list_bg_image.png',
              color: Color(0xFF29D0BF),
              showSearch: true,
              editController: _editController,
              scrollController: _scrollController,
              onSearchPressed: () => _refreshController.callRefresh(),
              areaPickerListener: (areaId){
                areaCode = areaId;
                print('***$areaCode');
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
                      return getPageLoadingWidget(context);
                    } else if (state is OrderListEmpty) {
                      return getPageEmptyWidget();
                    } else if (state is OrderListError) {
                      return getPageErrorWidget(state.errorMessage);
                    } else if (state is OrderListLoaded) {
                      if (!state.hasNextPage)
                        _refreshController.finishLoad(
                            noMore: !state.hasNextPage, success: true);
                      return _getPageLoadedWidget(state.orderList);
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
                status: '5',
              ));
              return _refreshCompleter.future;
            },
            onLoad: () async {
              _orderListBloc.dispatch(OrderListLoad(
                enterName: _editController.text,
                areaCode: areaCode,
                status: '5',
              ));
              return _refreshCompleter.future;
            },
          ),
        ),
      ),
    );
  }
}
