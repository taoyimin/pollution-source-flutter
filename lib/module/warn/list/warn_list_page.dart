import 'dart:async';
import 'package:city_pickers/modal/result.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/collection/area/area_repository.dart';
import 'package:pollution_source/module/common/collection/area/area_widget.dart';
import 'package:pollution_source/module/common/collection/collection_bloc.dart';
import 'package:pollution_source/module/common/collection/collection_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/common/dict/data_dict_widget.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/common/list/list_widget.dart';
import 'package:pollution_source/module/warn/list/warn_list_model.dart';
import 'package:pollution_source/module/warn/list/warn_list_repository.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/module/common/common_widget.dart';

/// 实时预警单列表界面
class WarnListPage extends StatefulWidget {
  WarnListPage();

  @override
  _WarnListPageState createState() => _WarnListPageState();
}

class _WarnListPageState extends State<WarnListPage> {
  /// 全局Key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 刷新控制器
  final EasyRefreshController _refreshController = EasyRefreshController();

  /// 环保用户显示选择区域相关布局
  final bool _showArea = SpUtil.getInt(Constant.spUserType) == 0;

  /// 列表Bloc
  final ListBloc _listBloc = ListBloc(listRepository: WarnListRepository());

  /// 区域Bloc
  final CollectionBloc _areaBloc = CollectionBloc(
    collectionRepository: AreaRepository(),
  );

  /// 报警类型Bloc
  final DataDictBloc _alarmTypeBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.orderAlarmType),
  );

  /// 区域信息
  Result _areaResult;

  /// 报警类型
  String _alarmType;

  /// 开始时间
  DateTime _startTime;

  /// 结束时间
  DateTime _endTime;

  /// 当前页
  int _currentPage = Constant.defaultCurrentPage;

  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _initParam();
    // 加载区域信息
    if (_showArea) _areaBloc.add(CollectionLoad());
    // 加载报警类型
    _alarmTypeBloc.add(DataDictLoad());
    _refreshCompleter = Completer<void>();
    // 首次加载
    _listBloc.add(ListLoad(isRefresh: true, params: _getRequestParam()));
  }

  @override
  void dispose() {
    // 释放资源
    _refreshController.dispose();
    // 取消正在进行的请求
    if (_listBloc?.state is ListLoading)
      (_listBloc?.state as ListLoading).cancelToken.cancel();
    super.dispose();
  }

  /// 初始化查询参数
  _initParam() {
    _areaResult = null;
    _alarmType = '';
    _startTime = null;
    _endTime = null;
  }

  /// 获取请求参数
  Map<String, dynamic> _getRequestParam() {
    return WarnListRepository.createParams(
      currentPage: _currentPage,
      pageSize: Constant.defaultPageSize,
      cityCode: _areaResult?.cityId ?? '',
      areaCode: _areaResult?.areaId ?? '',
      alarmType: _alarmType,
      startTime: _startTime,
      endTime: _endTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildEndDrawer(),
      body: extended.NestedScrollView(
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + kToolbarHeight;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            ListHeaderWidget(
              listBloc: _listBloc,
              title: '实时预警单列表',
              subtitle: '展示实时预警单列表，点击列表项查看该实时预警单的详细信息',
              background: 'assets/images/button_bg_yellow.png',
              image: 'assets/images/discharge_list_bg_image.png',
              color: Colours.background_yellow,
              onSearchTap: () {
                _scaffoldKey.currentState.openEndDrawer();
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
              BlocConsumer<ListBloc, ListState>(
                bloc: _listBloc,
                listener: (context, state) {
                  if (state is ListLoading) return;
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer();
                },
                buildWhen: (previous, current) {
                  if (current is ListLoading)
                    return false;
                  else
                    return true;
                },
                builder: (context, state) {
                  if (state is ListInitial || state is ListLoading) {
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
        ),
      ),
    );
  }

  Widget _buildPageLoadedList(List<Warn> warnList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
                Application.router.navigateTo(
                    context, '${Routes.warnDetail}/${warnList[index].warnId}');
              },
              children: <Widget>[
                Container(
                  width: double.infinity,
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
                      children: () {
                        if (SpUtil.getInt(Constant.spUserType) == 1) {
                          // 企业用户
                          return <Widget>[
                            Text(
                              '${warnList[index].title}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Gaps.vGap6,
                            LabelWrapWidget(
                                labelList: warnList[index].labelList),
                            warnList[index].labelList.length == 0
                                ? Gaps.empty
                                : Gaps.vGap6,
                            ListTileWidget(
                                '监控点名：${warnList[index].monitorName}'),
                            Gaps.vGap6,
                            ListTileWidget(
                                '生成时间：${warnList[index].createTimeStr}'),
                            Gaps.vGap6,
                            ListTileWidget('预警详情：${warnList[index].text}'),
                          ];
                        } else {
                          return <Widget>[
                            Text(
                              '${warnList[index].enterName}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Gaps.vGap6,
                            LabelWrapWidget(
                                labelList: warnList[index].labelList),
                            warnList[index].labelList.length == 0
                                ? Gaps.empty
                                : Gaps.vGap6,
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: ListTileWidget(
                                      '监控点名：${warnList[index].monitorName}'),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: ListTileWidget(
                                      '所属区域：${warnList[index].districtName}'),
                                ),
                              ],
                            ),
                            Gaps.vGap6,
                            ListTileWidget(
                                '生成时间：${warnList[index].createTimeStr}'),
                            Gaps.vGap6,
                            ListTileWidget('预警标题：${warnList[index].title}'),
                            Gaps.vGap6,
                            ListTileWidget('预警详情：${warnList[index].text}'),
                          ];
                        }
                      }()),
                ),
              ],
            ),
          );
        },
        childCount: warnList.length,
      ),
    );
  }

  Widget _buildEndDrawer() {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Container(
          width: UIUtils.getDrawerWidth(context, orientation),
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
                          Offstage(
                            offstage: !_showArea,
                            child: AreaWidget(
                              itemHeight: UIUtils.getSearchItemHeight(
                                  context, orientation),
                              initialResult: _areaResult,
                              collectionBloc: _areaBloc,
                              confirmCallBack: (Result result) {
                                setState(() {
                                  _areaResult = result;
                                });
                              },
                            ),
                          ),
                          DateTimeWidget(
                            title: '生成时间',
                            height: UIUtils.getSearchItemHeight(
                                context, orientation),
                            startTime: _startTime,
                            endTime: _endTime,
                            onStartTimeConfirm: (dateTime, selectedIndex) {
                              setState(() {
                                _startTime = dateTime;
                              });
                            },
                            onEndTimeConfirm: (dateTime, selectedIndex) {
                              setState(() {
                                _endTime = dateTime;
                              });
                            },
                          ),
                          DataDictBlocGridWidget(
                            title: '报警类型',
                            checkValue: _alarmType,
                            dataDictBloc: _alarmTypeBloc,
                            onItemTap: (value) {
                              setState(() {
                                _alarmType = value;
                              });
                            },
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
      },
    );
  }
}
