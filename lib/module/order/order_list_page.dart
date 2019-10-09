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
import 'package:pollution_source/widget/search.dart';

import 'order_list.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;
  OrderListBloc _orderListBloc;
  EasyRefreshController _refreshController;
  TextEditingController _editController;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    _refreshCompleter = Completer<void>();
    _orderListBloc = BlocProvider.of<OrderListBloc>(context);
    _orderListBloc.dispatch(OrderListLoad());
    _scrollController = ScrollController();
    _editController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(
      () {
        switch (_tabController.index) {
          case 0:
            setState(
              () {
                if (_actionIcon == Icons.close) {
                  _actionIcon = Icons.search;
                }
              },
            );
            break;
          case 1:
            setState(
              () {
                if (_actionIcon == Icons.search) {
                  _actionIcon = Icons.close;
                }
              },
            );
            break;
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    _refreshController.dispose();
    _editController.dispose();
  }

  Widget _selectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
      value: id,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(icon, color: Colors.blue),
          Text(text),
        ],
      ),
    );
  }

  IconData _actionIcon = Icons.search;

  _changePage() {
    setState(
      () {
        if (_actionIcon == Icons.search) {
          _actionIcon = Icons.close;
          _tabController.index = 1;
        } else {
          _actionIcon = Icons.search;
          _tabController.index = 0;
        }
      },
    );
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
            SliverAppBar(
              title: const Text("报警管理单列表"),
              expandedHeight: 150.0,
              pinned: true,
              floating: false,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                background: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/button_bg_green.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            right: -20,
                            bottom: 0,
                            child: Image.asset(
                              "assets/images/task_list_bg_image.png",
                              width: 300,
                            ),
                          ),
                          Positioned(
                            top: 80,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 110,
                                  child: const Text(
                                    "展示报警管理单列表，点击列表项查看该报警管理单的详细信息",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      _scrollController.jumpTo(0);
                                      _changePage();
                                    },
                                    child: const Text(
                                      "点我筛选",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF29D0BF),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 70, 16, 0),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/images/button_bg_green.png",
                          ),
                        ),
                      ),
                      child: EnterSearchWidget(
                        editController: _editController,
                        onSearchPressed: () {
                          _refreshController.callRefresh();
                        },
                        areaPickerListener: (areaCode) {
                          print('areaPickerListener=$areaCode');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                AnimatedSwitcher(
                  transitionBuilder: (child, anim) {
                    return ScaleTransition(child: child, scale: anim);
                  },
                  duration: Duration(milliseconds: 300),
                  child: IconButton(
                    key: ValueKey(_actionIcon),
                    icon: Icon(_actionIcon),
                    onPressed: () {
                      _scrollController.jumpTo(0);
                      _changePage();
                    },
                  ),
                ),
                // 隐藏的菜单
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<String>>[
                    this._selectView(Icons.message, '发起群聊', 'A'),
                    this._selectView(Icons.group_add, '添加服务', 'B'),
                    this._selectView(Icons.cast_connected, '扫一扫码', 'C'),
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
              ],
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
                status: '5',
              ));
              return _refreshCompleter.future;
            },
            onLoad: () async {
              _orderListBloc.dispatch(OrderListLoad(
                enterName: _editController.text,
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
