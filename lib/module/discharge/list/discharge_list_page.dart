import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_model.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_repository.dart';
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

class _DischargeListPageState extends State<DischargeListPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  ListBloc _listBloc;
  EasyRefreshController _refreshController;
  TextEditingController _editController;
  Completer<void> _refreshCompleter;
  String areaCode = '';

  @override
  void initState() {
    super.initState();
    _listBloc = BlocProvider.of<ListBloc>(context);
    _refreshController = EasyRefreshController();
    _refreshCompleter = Completer<void>();
    _scrollController = ScrollController();
    _editController = TextEditingController();
    //首次加载
    _listBloc.add(ListLoad(
        isRefresh: true,
        params: DischargeListRepository.createParams(
          currentPage: Constant.defaultCurrentPage,
          pageSize: Constant.defaultPageSize,
          enterId: widget.enterId,
          dischargeType: widget.dischargeType,
          state: widget.state,
        )));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    _editController.dispose();
    //取消正在进行的请求
    final currentState = _listBloc?.state;
    if (currentState is ListLoading) currentState.cancelToken?.cancel();
    super.dispose();
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
            BlocBuilder<ListBloc, ListState>(
              builder: (context, state) {
                String subtitle2 = '';
                if(state is ListLoading)
                  subtitle2 = '数据加载中';
                else if (state is ListLoaded)
                  subtitle2 = '共${state.total}条数据';
                else if (state is ListEmpty)
                  subtitle2 = '共0条数据';
                else if(state is ListError)
                  subtitle2 = '数据加载错误';
                return ListHeaderWidget(
                  title: '排口列表',
                  subtitle: '展示污染源排口列表，点击列表项查看该排口的详细信息',
                  subtitle2: subtitle2,
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
                    itemBuilder: (BuildContext context) =>
                    <PopupMenuItem<String>>[
                      UIUtils.getSelectView(Icons.message, '发起群聊', 'A'),
                      UIUtils.getSelectView(Icons.group_add, '添加服务', 'B'),
                    ],
                    onSelected: (String action) {
                      // 点击选项的时候
                      switch (action) {
                        case 'A':
                          break;
                        case 'B':
                          break;
                      }
                    },
                  ),
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
                params: DischargeListRepository.createParams(
                  currentPage: Constant.defaultCurrentPage,
                  pageSize: Constant.defaultPageSize,
                  enterName: _editController.text,
                  areaCode: areaCode,
                  enterId: widget.enterId,
                  dischargeType: widget.dischargeType,
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
                  enterName: _editController.text,
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
