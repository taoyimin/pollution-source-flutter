import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/page/enter_detail.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/dimens.dart';
import 'package:pollution_source/util/ui_util.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/widget/label.dart';
import 'package:pollution_source/widget/search.dart';

import 'enter_list.dart';

class EnterListPage extends StatefulWidget {
  @override
  _EnterListPageState createState() => _EnterListPageState();
}

class _EnterListPageState extends State<EnterListPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;
  EnterListBloc _enterListBloc;
  EasyRefreshController _refreshController;
  TextEditingController _editController;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    _refreshCompleter = Completer<void>();
    _enterListBloc = BlocProvider.of<EnterListBloc>(context);
    _enterListBloc.dispatch(EnterListLoad());
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

  //根据企业标签model获取企业标签widget
  List<Widget> _getEnterLabelWidgetList(List<EnterLabel> alarmTypeList) {
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

  Widget _getPageLoadedWidget(List<Enter> enterList) {
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(3),
                        child: Image.asset(
                          enterList[index].imagePath,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Text(
                                enterList[index].name,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(height: 6,),
                            Wrap(
                              spacing: 6,
                              runSpacing: 3,
                              children: _getEnterLabelWidgetList(enterList[index].enterLabelList),
                            ),
                            SizedBox(height: 6,),
                            Text(
                              "地址：${enterList[index].address}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colours.secondary_text,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 6,),
                            Text(
                              "行业类别：${enterList[index].industryType}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colours.secondary_text,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Offstage(
                  offstage: !enterList[index].isImportant,
                  child: LabelView(
                    Size.fromHeight(100),
                    labelText: "重点",
                    labelColor: Theme.of(context).primaryColor,
                    labelAlignment: LabelAlignment.rightTop,
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
                              return EnterDetailPage();
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
        childCount: enterList.length,
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
              title: const Text("企业列表"),
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
                            "assets/images/button_bg_lightblue.png",
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
                              "assets/images/enter_list_bg_image.png",
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
                                    "展示污染源企业列表，点击列表项查看该企业的详细信息",
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
                                        color: Colors.blue,
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
                            "assets/images/button_bg_lightblue.png",
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
              BlocListener<EnterListBloc, EnterListState>(
                listener: (context, state) {
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer();
                },
                child: BlocBuilder<EnterListBloc, EnterListState>(
                  builder: (context, state) {
                    if (state is EnterListLoading) {
                      return getPageLoadingWidget(context);
                    } else if (state is EnterListEmpty) {
                      return getPageEmptyWidget();
                    } else if (state is EnterListError) {
                      return getPageErrorWidget(state.errorMessage);
                    } else if (state is EnterListLoaded) {
                      if (!state.hasNextPage)
                        _refreshController.finishLoad(
                            noMore: !state.hasNextPage, success: true);
                      return _getPageLoadedWidget(state.enterList);
                    } else {
                      return SliverFillRemaining();
                    }
                  },
                ),
              ),
            ],
            onRefresh: () async {
              _enterListBloc.dispatch(EnterListLoad(
                isRefresh: true,
                enterName: _editController.text,
              ));
              return _refreshCompleter.future;
            },
            onLoad: () async {
              _enterListBloc.dispatch(EnterListLoad(
                enterName: _editController.text,
              ));
              return _refreshCompleter.future;
            },
          ),
        ),
      ),
    );
  }
}
