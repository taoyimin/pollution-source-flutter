import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pollution_source/model/model.dart';
import 'package:pollution_source/page/task_detail.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/dimens.dart';
import 'package:pollution_source/util/ui_util.dart';
import 'package:pollution_source/widget/label.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/widget/search.dart';

import 'enter_detail.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;

  int _listCount = 100;

  //AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
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
    /*_animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      value: 1.0,
    );*/
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    //_animationController.dispose();
  }

  Widget _selectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(icon, color: Colors.blue),
            new Text(text),
          ],
        ));
  }

  IconData _actionIcon = Icons.search;

  changePage() {
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
              title: Text("报警管理单列表"),
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
                                  child: Text(
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
                                  child: Text(
                                    "点我筛选",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF22D2BE),
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
                      padding: EdgeInsets.fromLTRB(16, 70, 16, 0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/images/button_bg_green.png",
                          ),
                        ),
                      ),
                      child: EnterSearchWidget(),
                    ),
                  ],
                ),
              ),
              /*bottom: PreferredSize(
                child: SearchWidget(height: 100,),
                preferredSize: Size(double.infinity, 100),
              ),*/
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
                      changePage();
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
            /*SliverPersistentHeader(
              pinned: true,
              delegate: SearchBarDelegate(
                animation: animation,
              ),
            ),*/
          ];
        },
        body: extended.NestedScrollViewInnerScrollPositionKeyWidget(
          Key('Tab0'),
          EasyRefresh.custom(
            header: getRefreshClassicalHeader(),
            footer: getLoadClassicalFooter(),
            slivers: <Widget>[
              TaskListWidget(),
            ],
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  _listCount = 20;
                });
              });
            },
            onLoad: () async {
              await Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  _listCount += 10;
                });
              });
            },
          ),
        ),
      ),
    );
  }
}

class TaskListWidget extends StatefulWidget {
  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  final List<Task> taskList = [
    Task(
      name: "深圳市腾讯计算机系统有限公司",
      imagePath: "assets/images/icon_alarm_error.png",
      createTime: "2019-09-12",
      deadline: "2019-09-14",
      outletName: "废水排放口",
      alarmType: "排放流量异常",
      alarmRemark: "报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述",
    ),
    Task(
      name: "深圳市腾讯计算机系统有限公司",
      imagePath: "assets/images/icon_alarm_no_upload.png",
      createTime: "2019-09-12",
      deadline: "2019-09-14",
      outletName: "废水排放口",
      alarmType: "无数据上传",
      alarmRemark: "报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述",
    ),
    Task(
      name: "深圳市腾讯计算机系统有限公司",
      imagePath: "assets/images/icon_alarm_outrange.png",
      createTime: "2019-09-12",
      deadline: "2019-09-14",
      outletName: "废水排放口",
      alarmType: "污染物超标",
      alarmRemark: "报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述",
    ),
    Task(
      name: "深圳市腾讯计算机系统有限公司",
      imagePath: "assets/images/icon_alarm_error.png",
      createTime: "2019-09-12",
      deadline: "2019-09-14",
      outletName: "废水排放口",
      alarmType: "排放流量异常",
      alarmRemark: "报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述",
    ),
    Task(
      name: "深圳市腾讯计算机系统有限公司",
      imagePath: "assets/images/icon_alarm_no_upload.png",
      createTime: "2019-09-12",
      deadline: "2019-09-14",
      outletName: "废水排放口",
      alarmType: "无数据上传",
      alarmRemark: "报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述",
    ),
    Task(
      name: "深圳市腾讯计算机系统有限公司",
      imagePath: "assets/images/icon_alarm_outrange.png",
      createTime: "2019-09-12",
      deadline: "2019-09-14",
      outletName: "废水排放口",
      alarmType: "污染物超标",
      alarmRemark: "报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述",
    ),
    Task(
      name: "深圳市腾讯计算机系统有限公司",
      imagePath: "assets/images/icon_alarm_error.png",
      createTime: "2019-09-12",
      deadline: "2019-09-14",
      outletName: "废水排放口",
      alarmType: "排放流量异常",
      alarmRemark: "报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述",
    ),
    Task(
      name: "深圳市腾讯计算机系统有限公司",
      imagePath: "assets/images/icon_alarm_no_upload.png",
      createTime: "2019-09-12",
      deadline: "2019-09-14",
      outletName: "废水排放口",
      alarmType: "无数据上传",
      alarmRemark: "报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述",
    ),
    Task(
      name: "深圳市腾讯计算机系统有限公司",
      imagePath: "assets/images/icon_alarm_outrange.png",
      createTime: "2019-09-12",
      deadline: "2019-09-14",
      outletName: "废水排放口",
      alarmType: "污染物超标",
      alarmRemark: "报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述",
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: 125,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset(
                            taskList[index].imagePath,
                            width: 40,
                            height: 40,
                          ),
                          Container(
                            width: 50,
                            child: Text(
                              taskList[index].alarmType,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              taskList[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "排口名称：${taskList[index].outletName}",
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
                                    "创建时间：${taskList[index].createTime}",
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
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "报警类型：${taskList[index].alarmType}",
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
                                    "截至时间：${taskList[index].deadline}",
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
                            Text(
                              "报警描述：${taskList[index].alarmRemark}",
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
        childCount: taskList.length,
      ),
    );
  }
}
