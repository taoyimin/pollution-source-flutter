import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/inspection/routine/list/routine_inspection_list_model.dart';
import 'package:pollution_source/module/inspection/routine/list/routine_inspection_list_repository.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/widget/custom_header.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/module/common/common_widget.dart';

/// 常规巡检列表页
class RoutineInspectionListPage extends StatefulWidget {
  final String enterId;
  final String monitorId;
  final String state;

  RoutineInspectionListPage({
    this.enterId = '',
    this.monitorId = '',
    this.state = '',
  });

  @override
  _RoutineInspectionListPageState createState() =>
      _RoutineInspectionListPageState();
}

class _RoutineInspectionListPageState extends State<RoutineInspectionListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final EasyRefreshController _refreshController = EasyRefreshController();
  final TextEditingController _enterNameController = TextEditingController();
  final List<DataDict> stateList = [
    DataDict(name: '全部', code: ''),
    DataDict(name: '当前待处理', code: '1'),
    DataDict(name: '超时待处理', code: '2'),
  ];
  int stateIndex;
  ListBloc _listBloc;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    initParam();
    // 初始化列表Bloc
    _listBloc = BlocProvider.of<ListBloc>(context);
    _refreshCompleter = Completer<void>();
    //首次加载
    _listBloc.add(ListLoad(
      isRefresh: true,
      params: RoutineInspectionListRepository.createParams(
        currentPage: Constant.defaultCurrentPage,
        pageSize: Constant.defaultPageSize,
        enterId: widget.enterId,
        monitorId: widget.monitorId,
        enterName: _enterNameController.text,
        state: stateList[stateIndex].code,
      ),
    ));
  }

  @override
  void dispose() {
    //释放资源
    _refreshController.dispose();
    _enterNameController.dispose();
    //取消正在进行的请求
    final currentState = _listBloc?.state;
    if (currentState is ListLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  initParam() {
    _enterNameController.text = '';
    stateIndex = stateList.indexWhere((dataDict) {
      return dataDict.code == widget.state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Drawer(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 56, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          '企业名称',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gaps.vGap10,
                        Container(
                          height: 36,
                          child: TextField(
                            controller: _enterNameController,
                            style: const TextStyle(fontSize: 13),
                            decoration: const InputDecoration(
                              fillColor: Colours.grey_color,
                              filled: true,
                              hintText: "请输入企业名称",
                              hintStyle: TextStyle(
                                color: Colours.secondary_text,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Gaps.vGap30,
                        const Text(
                          '巡检状态',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DataDictGrid(
                          checkIndex: stateIndex,
                          dataDictList: stateList,
                          onItemTap: (index) {
                            setState(() {
                              stateIndex = index;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Row(
                  children: <Widget>[
                    ClipButton(
                      text: '重置',
                      height: 40,
                      fontSize: 13,
                      icon: Icons.refresh,
                      color: Colors.orange,
                      onTap: () {
                        setState(() {
                          initParam();
                        });
                      },
                    ),
                    Gaps.hGap10,
                    ClipButton(
                      text: '搜索',
                      height: 40,
                      fontSize: 13,
                      icon: Icons.search,
                      color: Colors.lightBlue,
                      onTap: () {
                        Navigator.pop(context);
                        _refreshController.callRefresh();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: extended.NestedScrollView(
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + kToolbarHeight;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            BlocBuilder<ListBloc, ListState>(
              builder: (context, state) {
                String subtitle2 = '';
                if (state is ListLoading)
                  subtitle2 = '数据加载中';
                else if (state is ListLoaded)
                  subtitle2 = '共${state.total}条数据';
                else if (state is ListEmpty)
                  subtitle2 = '共0条数据';
                else if (state is ListError) subtitle2 = '数据加载错误';
                return ListHeaderWidget2(
                  title: '常规巡检列表',
                  subtitle: '展示常规巡检列表，点击列表项查看该常规巡检的详细信息',
                  subtitle2: subtitle2,
                  background: 'assets/images/button_bg_green.png',
                  image: 'assets/images/routine_inspection_list_bg_image.png',
                  color: Color(0xFF29D0BF),
                  onSearchTap: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                );
              },
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
              BlocListener<ListBloc, ListState>(
                listener: (context, state) {
                  //刷新状态不触发_refreshCompleter
                  if (state is ListLoading) return;
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer();
                },
                child: BlocBuilder<ListBloc, ListState>(
                  condition: (previousState, state) {
                    //刷新状态不重构Widget
                    if (state is ListLoading)
                      return false;
                    else
                      return true;
                  },
                  builder: (context, state) {
                    if (state is ListInitial) {
                      return LoadingSliver();
                    } else if (state is ListEmpty) {
                      return EmptySliver();
                    } else if (state is ListError) {
                      return ErrorSliver(errorMessage: state.message);
                    } else if (state is ListLoaded) {
                      if (!state.hasNextPage)
                        _refreshController.finishLoad(
                            noMore: !state.hasNextPage, success: true);
                      return _buildPageLoadedList(state.list);
                    } else {
                      return ErrorSliver(
                          errorMessage: 'BlocBuilder监听到未知的的状态！state=$state');
                    }
                  },
                ),
              ),
            ],
            onRefresh: () async {
              _listBloc.add(ListLoad(
                isRefresh: true,
                params: RoutineInspectionListRepository.createParams(
                  currentPage: Constant.defaultCurrentPage,
                  pageSize: Constant.defaultPageSize,
                  enterName: _enterNameController.text,
                  enterId: widget.enterId,
                  monitorId: widget.monitorId,
                  state: stateList[stateIndex].code,
                ),
              ));
              return _refreshCompleter.future;
            },
            onLoad: () async {
              final currentState = _listBloc.state;
              int currentPage;
              if (currentState is ListLoaded)
                currentPage = currentState.currentPage + 1;
              else
                currentPage = Constant.defaultCurrentPage;
              _listBloc.add(ListLoad(
                isRefresh: false,
                params: RoutineInspectionListRepository.createParams(
                  currentPage: currentPage,
                  pageSize: Constant.defaultPageSize,
                  enterName: _enterNameController.text,
                  enterId: widget.enterId,
                  monitorId: widget.monitorId,
                  state: stateList[stateIndex].code,
                ),
              ));
              return _refreshCompleter.future;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageLoadedList(List<RoutineInspection> routineInspectionList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
                Application.router.navigateTo(context,
                    '${Routes.routineInspectionDetail}/${routineInspectionList[index].monitorId}?monitorType=${routineInspectionList[index].monitorType}&state=${stateList[stateIndex].code}');
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          '${routineInspectionList[index].enterName}',
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
                                '排口名称：${routineInspectionList[index].dischargeName}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '监控点名：${routineInspectionList[index].monitorName}'),
                          ),
                        ],
                      ),
                      Gaps.vGap6,
                      ListTileWidget(
                          '任务数：${routineInspectionList[index].taskCount}'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: routineInspectionList.length,
      ),
    );
  }
}
