import 'dart:async';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/common/map_info_page.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/module/common/common_widget.dart';

import 'notice_list_model.dart';
import 'notice_list_repository.dart';

/// 消息通知列表
class NoticeListPage extends StatefulWidget {
  NoticeListPage();

  @override
  _NoticeListPageState createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> {
  final EasyRefreshController _refreshController = EasyRefreshController();
  ListBloc _listBloc;
  Completer<void> _refreshCompleter;
  int _currentPage = Constant.defaultCurrentPage;

  /// 开始时间
  DateTime _startTime;

  /// 结束时间
  DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _initParam();
    // 初始化列表Bloc
    _listBloc = BlocProvider.of<ListBloc>(context);
    _refreshCompleter = Completer<void>();
    // 首次加载
    _listBloc.add(ListLoad(isRefresh: true, params: _getRequestParam()));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    // 取消正在进行的请求
    final currentState = _listBloc?.state;
    if (currentState is ListLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  /// 初始化查询参数
  _initParam() {
    _startTime = null;
    _endTime = null;
  }

  /// 获取请求参数
  Map<String, dynamic> _getRequestParam() {
    return NoticeListRepository.createParams(
      currentPage: _currentPage,
      pageSize: Constant.defaultPageSize,
      startTime: _startTime,
      endTime: _endTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('消息通知列表'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      endDrawer: _buildEndDrawer(),
      body: EasyRefresh.custom(
        controller: _refreshController,
        header: UIUtils.getRefreshClassicalHeader(),
        footer: UIUtils.getLoadClassicalFooter(),
        slivers: <Widget>[
          BlocListener<ListBloc, ListState>(
            listener: (context, state) {
              // 刷新状态不触发_refreshCompleter
              if (state is ListLoading) return;
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            },
            child: BlocBuilder<ListBloc, ListState>(
              condition: (previousState, state) {
                // 刷新状态不重构Widget
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
                  return ErrorSliver(
                    errorMessage: state.message,
                    onReloadTap: () => _refreshController.callRefresh(),
                  );
                } else if (state is ListLoaded) {
                  if (!state.hasNextPage) {
                    _refreshController.finishLoad(
                        noMore: !state.hasNextPage, success: true);
                  }
                  return _buildPageLoadedList(state.list);
                } else {
                  return ErrorSliver(
                    errorMessage: 'BlocBuilder监听到未知的的状态！state=$state',
                    onReloadTap: () => _refreshController.callRefresh(),
                  );
                }
              },
            ),
          ),
        ],
        onRefresh: () async {
          _currentPage = Constant.defaultCurrentPage;
          _refreshController.resetLoadState();
          _listBloc.add(ListLoad(
            isRefresh: true,
            params: _getRequestParam(),
          ));
          return _refreshCompleter.future;
        },
        onLoad: () async {
          final currentState = _listBloc.state;
          if (currentState is ListLoaded)
            _currentPage = currentState.currentPage + 1;
          else
            _currentPage = Constant.defaultCurrentPage;
          _listBloc.add(ListLoad(params: _getRequestParam()));
          return _refreshCompleter.future;
        },
      ),
    );
  }

  Widget _buildPageLoadedList(List<Notice> noticeList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // 创建列表项
          return InkWellButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MapInfoPage(
                      title: '消息通知详情',
                      mapInfo: noticeList[index].getMapInfo(),
                    );
                  },
                ),
              );
            },
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(bottom: BorderSide(color: Colours.divider_color)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${noticeList[index].title}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Gaps.vGap6,
                    ListTileWidget('${noticeList[index].text}'),
                    Gaps.vGap6,
                    ListTileWidget('${noticeList[index].time}'),
                  ],
                ),
              ),
            ],
          );
        },
        childCount: noticeList.length,
      ),
    );
  }

  Widget _buildEndDrawer() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 46, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        '报警时间',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.vGap10,
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                DatePicker.showDatePicker(
                                  context,
                                  dateFormat: 'yyyy年-MM月-dd日',
                                  initialDateTime: _startTime,
                                  maxDateTime: _endTime ?? DateTime.now(),
                                  locale: DateTimePickerLocale.zh_cn,
                                  onClose: () {},
                                  onConfirm: (dateTime, selectedIndex) {
                                    setState(() {
                                      _startTime = dateTime;
                                    });
                                  },
                                );
                              },
                              child: Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: _startTime != null
                                        ? Colours.primary_color
                                        : Colours.divider_color,
                                  ),
                                  color: _startTime != null
                                      ? Colours.primary_color.withOpacity(0.3)
                                      : Colours.divider_color,
                                ),
                                child: Center(
                                  child: Text(
                                    DateUtil.getDateStrByDateTime(_startTime,
                                            format:
                                                DateFormat.ZH_YEAR_MONTH_DAY) ??
                                        '开始时间',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _startTime != null
                                          ? Colours.primary_color
                                          : Colours.secondary_text,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            child: const Center(
                              child: Text(
                                '至',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colours.secondary_text,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                DatePicker.showDatePicker(
                                  context,
                                  dateFormat: 'yyyy年-MM月-dd日',
                                  initialDateTime: _endTime,
                                  minDateTime: _startTime,
                                  maxDateTime: DateTime.now(),
                                  locale: DateTimePickerLocale.zh_cn,
                                  onClose: () {},
                                  onConfirm: (dateTime, selectedIndex) {
                                    setState(() {
                                      _endTime = dateTime;
                                    });
                                  },
                                );
                              },
                              child: Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: _endTime != null
                                        ? Colours.primary_color
                                        : Colours.divider_color,
                                  ),
                                  color: _endTime != null
                                      ? Colours.primary_color.withOpacity(0.3)
                                      : Colours.divider_color,
                                ),
                                child: Center(
                                  child: Text(
                                    DateUtil.getDateStrByDateTime(_endTime,
                                            format:
                                                DateFormat.ZH_YEAR_MONTH_DAY) ??
                                        '结束时间',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _endTime != null
                                          ? Colours.primary_color
                                          : Colours.secondary_text,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
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
                        _initParam();
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
    );
  }
}
