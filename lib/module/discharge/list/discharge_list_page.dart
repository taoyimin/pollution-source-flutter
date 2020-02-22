import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_widget.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_model.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_repository.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';

import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/widget/custom_header.dart';

class DischargeListPage extends StatefulWidget {
  final String enterId;
  final String dischargeType;
  final String state;
  final int type; //启用页面的类型 0：点击列表项查看详情 1：点击列表项返回上一层与排口信息

  DischargeListPage({
    this.enterId = '',
    this.dischargeType = '',
    this.state = '',
    this.type = 0,
  });

  @override
  _DischargeListPageState createState() => _DischargeListPageState();
}

class _DischargeListPageState extends State<DischargeListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final EasyRefreshController _refreshController = EasyRefreshController();
  final TextEditingController _enterNameController = TextEditingController();
  final List<DataDict> dischargeTypeList = [
    DataDict(name: '全部', code: ''),
    DataDict(name: '雨水排口', code: '1'),
    DataDict(name: '废水排口', code: '2'),
    DataDict(name: '废气排口', code: '3'),
  ];
  int dischargeTypeIndex;
  ListBloc _listBloc;
  Completer<void> _refreshCompleter;
  String areaCode = '';

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
        params: DischargeListRepository.createParams(
          currentPage: Constant.defaultCurrentPage,
          pageSize: Constant.defaultPageSize,
          enterId: widget.enterId,
          enterName: _enterNameController.text,
          areaCode: areaCode,
          dischargeType: dischargeTypeList[dischargeTypeIndex].code,
          state: widget.state,
        )));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _enterNameController.dispose();
    //取消正在进行的请求
    final currentState = _listBloc?.state;
    if (currentState is ListLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  /// 初始化查询参数
  initParam() {
    _enterNameController.text = '';
    dischargeTypeIndex = dischargeTypeList.indexWhere((dataDict) {
      return dataDict.code == widget.dischargeType;
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
                    padding: const EdgeInsets.fromLTRB(16, 56, 16, 20),
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
                          '排口类型',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DataDictGrid(
                          checkIndex: dischargeTypeIndex,
                          dataDictList: dischargeTypeList,
                          onItemTap: (index) {
                            setState(() {
                              dischargeTypeIndex = index;
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
                return ListHeaderWidget(
                  title: '排口列表',
                  subtitle: '展示污染源排口列表，点击列表项查看该排口的详细信息',
                  subtitle2: subtitle2,
                  background: 'assets/images/button_bg_yellow.png',
                  image: 'assets/images/discharge_list_bg_image.png',
                  color: Colours.background_yellow,
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
                      if (!state.hasNextPage) {
                        _refreshController.finishLoad(
                            noMore: !state.hasNextPage, success: true);
                      }
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
              _refreshController.resetLoadState();
              _listBloc.add(ListLoad(
                isRefresh: true,
                params: DischargeListRepository.createParams(
                  currentPage: Constant.defaultCurrentPage,
                  pageSize: Constant.defaultPageSize,
                  areaCode: areaCode,
                  enterId: widget.enterId,
                  enterName: _enterNameController.text,
                  dischargeType: dischargeTypeList[dischargeTypeIndex].code,
                  state: widget.state,
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
                params: DischargeListRepository.createParams(
                  currentPage: currentPage,
                  pageSize: Constant.defaultPageSize,
                  enterName: _enterNameController.text,
                  areaCode: areaCode,
                  enterId: widget.enterId,
                  dischargeType: widget.dischargeType,
                  state: widget.state,
                ),
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
                switch (widget.type) {
                  case 0:
                    Application.router.navigateTo(context,
                        '${Routes.dischargeDetail}/${dischargeList[index].dischargeId}');
                    break;
                  case 1:
                    Navigator.pop(context, dischargeList[index]);
                    break;
                  default:
                    Toast.show('未知的页面类型，type=${widget.type}');
                    break;
                }
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
