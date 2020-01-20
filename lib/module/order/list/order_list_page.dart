import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/order/list/order_list_model.dart';
import 'package:pollution_source/module/order/list/order_list_repository.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/widget/custom_header.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';

import 'package:pollution_source/module/common/common_widget.dart';

/// 报警管理单列表界面
class OrderListPage extends StatefulWidget {
  final String state;
  final String overdue;
  final String enterId;
  final String monitorId;

  OrderListPage({
    this.state = '',
    this.overdue = '',
    this.enterId = '',
    this.monitorId = '',
  });

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
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
      params: OrderListRepository.createParams(
        currentPage: Constant.defaultCurrentPage,
        pageSize: Constant.defaultPageSize,
        state: widget.state,
        overdue: widget.overdue,
        enterId: widget.enterId,
        monitorId: widget.monitorId,
      ),
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
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
                if (state is ListLoading)
                  subtitle2 = '数据加载中';
                else if (state is ListLoaded)
                  subtitle2 = '共${state.total}条数据';
                else if (state is ListEmpty)
                  subtitle2 = '共0条数据';
                else if (state is ListError) subtitle2 = '数据加载错误';
                return ListHeaderWidget(
                  title: '报警管理单列表',
                  subtitle: '展示报警管理单列表，点击列表项查看该报警管理单的详细信息',
                  subtitle2: subtitle2,
                  background: 'assets/images/button_bg_blue.png',
                  image: 'assets/images/order_list_bg_image.png',
                  color: Colors.blue,
                  showSearch: true,
                  editController: _editController,
                  scrollController: _scrollController,
                  onSearchPressed: () => _refreshController.callRefresh(),
                  areaPickerListener: (areaId) {
                    areaCode = areaId;
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
                params: OrderListRepository.createParams(
                  currentPage: Constant.defaultCurrentPage,
                  pageSize: Constant.defaultPageSize,
                  enterName: _editController.text,
                  areaCode: areaCode,
                  state: widget.state,
                  overdue: widget.overdue,
                  enterId: widget.enterId,
                  monitorId: widget.monitorId,
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
                params: OrderListRepository.createParams(
                  currentPage: currentPage,
                  pageSize: Constant.defaultPageSize,
                  enterName: _editController.text,
                  areaCode: areaCode,
                  state: widget.state,
                  overdue: widget.overdue,
                  enterId: widget.enterId,
                  monitorId: widget.monitorId,
                ),
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
                Application.router.navigateTo(context,
                    '${Routes.orderDetail}/${orderList[index].orderId}');
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
                            child: ListTileWidget(
                                '区域：${orderList[index].districtName}'),
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
