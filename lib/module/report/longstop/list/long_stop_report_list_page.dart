import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/report/longstop/list/long_stop_report_list_model.dart';
import 'package:pollution_source/module/report/longstop/list/long_stop_report_list_repository.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/widget/custom_header.dart';

class LongStopReportListPage extends StatefulWidget {
  final String enterId;
  final String state;
  final String valid;

  LongStopReportListPage({
    this.enterId = '',
    this.state = '',
    this.valid = '',
  });

  @override
  _LongStopReportListPageState createState() =>
      _LongStopReportListPageState();
}

class _LongStopReportListPageState extends State<LongStopReportListPage>
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
      params: LongStopReportListRepository.createParams(
        currentPage: Constant.defaultCurrentPage,
        pageSize: Constant.defaultPageSize,
        enterId: widget.enterId,
        state: widget.state,
        valid: widget.valid,
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
                  title: '长期停产申报列表',
                  subtitle: '展示长期停产申报列表，点击列表项查看该长期停产申报的详细信息',
                  subtitle2: subtitle2,
                  background: 'assets/images/button_bg_lightblue.png',
                  image: 'assets/images/report_list_bg_image.png',
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
              //刷新事件
              _listBloc.add(ListLoad(
                isRefresh: true,
                params: LongStopReportListRepository.createParams(
                  currentPage: Constant.defaultCurrentPage,
                  pageSize: Constant.defaultPageSize,
                  enterName: _editController.text,
                  areaCode: areaCode,
                  enterId: widget.enterId,
                  state: widget.state,
                  valid: widget.valid,
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
              //加载事件
              _listBloc.add(ListLoad(
                isRefresh: false,
                params: LongStopReportListRepository.createParams(
                  currentPage: currentPage,
                  pageSize: Constant.defaultPageSize,
                  enterName: _editController.text,
                  areaCode: areaCode,
                  enterId: widget.enterId,
                  state: widget.state,
                  valid: widget.valid,
                ),
              ));
              return _refreshCompleter.future;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageLoadedList(List<LongStopReport> reportList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
                Application.router.navigateTo(context,
                    '${Routes.longStopReportDetail}/${reportList[index].reportId}');
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
                        '${reportList[index].enterName}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Gaps.vGap6,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '所属区域：${reportList[index].districtName}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '开始时间：${reportList[index].startTimeStr}'),
                          ),

                        ],
                      ),
                      Gaps.vGap6,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '申报时间：${reportList[index].reportTimeStr}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '结束时间：${reportList[index].endTimeStr}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: reportList.length,
      ),
    );
  }
}
