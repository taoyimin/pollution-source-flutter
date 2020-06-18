import 'dart:async';
import 'package:city_pickers/modal/result.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/collection/area/area_repository.dart';
import 'package:pollution_source/module/common/collection/area/area_widget.dart';
import 'package:pollution_source/module/common/collection/collection_bloc.dart';
import 'package:pollution_source/module/common/collection/collection_event.dart';
import 'package:pollution_source/module/common/collection/collection_state.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/common/dict/data_dict_state.dart';
import 'package:pollution_source/module/common/dict/data_dict_widget.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/common/list/list_widget.dart';
import 'package:pollution_source/module/report/longstop/list/long_stop_report_list_model.dart';
import 'package:pollution_source/module/report/longstop/list/long_stop_report_list_repository.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/common/common_widget.dart';

/// 长期停产申报列表界面
class LongStopReportListPage extends StatefulWidget {
  final String enterId;
  final String state;
  final String valid;
  final String attentionLevel;

  LongStopReportListPage({
    this.enterId = '',
    this.state = '',
    this.valid = '',
    this.attentionLevel = '',
  });

  @override
  _LongStopReportListPageState createState() => _LongStopReportListPageState();
}

class _LongStopReportListPageState extends State<LongStopReportListPage> {
  /// 全局Key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 刷新控制器
  final EasyRefreshController _refreshController = EasyRefreshController();

  /// 企业名称编辑器
  final TextEditingController _enterNameController = TextEditingController();

  /// 运维用户隐藏关注程度相关布局
  final bool _showAttentionLevel = SpUtil.getInt(Constant.spUserType) != 2;

  /// 环保用户显示选择区域相关布局
  final bool _showArea = SpUtil.getInt(Constant.spUserType) == 0;

  /// 列表Bloc
  final ListBloc _listBloc = ListBloc(
    listRepository: LongStopReportListRepository(),
  );

  /// 区域Bloc
  final CollectionBloc _areaBloc = CollectionBloc(
    collectionRepository: AreaRepository(),
  );

  /// 是否生效Bloc
  final DataDictBloc _validBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.reportValid),
  );

  /// 关注程度Bloc
  final DataDictBloc _attentionLevelBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.attentionLevel),
  );

  /// 区域信息
  Result _areaResult;

  /// 是否有效
  String _valid;

  /// 关注程度
  String _attentionLevel;

  /// 当前页
  int _currentPage = Constant.defaultCurrentPage;

  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    initParam();
    // 加载区域信息
    if (_showArea) _areaBloc.add(CollectionLoad());
    // 加载是否生效
    _validBloc.add(DataDictLoad());
    // 加载关注程度
    if (_showAttentionLevel) _attentionLevelBloc.add(DataDictLoad());
    _refreshCompleter = Completer<void>();
    // 首次加载
    _listBloc.add(ListLoad(isRefresh: true, params: _getRequestParam()));
  }

  @override
  void dispose() {
    // 释放资源
    _enterNameController.dispose();
    _refreshController.dispose();
    // 取消正在进行的请求
    if (_listBloc?.state is ListLoading)
      (_listBloc?.state as ListLoading).cancelToken.cancel();
    if (_areaBloc?.state is CollectionLoading)
      (_areaBloc?.state as CollectionLoading).cancelToken.cancel();
    if (_validBloc?.state is DataDictLoading)
      (_validBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_attentionLevelBloc?.state is DataDictLoading)
      (_attentionLevelBloc?.state as DataDictLoading).cancelToken.cancel();
    super.dispose();
  }

  /// 初始化查询参数
  initParam() {
    _enterNameController.text = '';
    _areaResult = null;
    _valid = widget.valid;
    _attentionLevel = widget.attentionLevel;
  }

  /// 获取请求参数
  Map<String, dynamic> _getRequestParam() {
    return LongStopReportListRepository.createParams(
      currentPage: _currentPage,
      pageSize: Constant.defaultPageSize,
      enterId: widget.enterId,
      enterName: _enterNameController.text,
      cityCode: _areaResult?.cityId ?? '',
      areaCode: _areaResult?.areaId ?? '',
      state: widget.state,
      valid: _valid,
      attentionLevel: _attentionLevel,
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
              title: '长期停产申报列表',
              subtitle: '展示长期停产申报列表，点击列表项查看该长期停产申报的详细信息',
              background: 'assets/images/button_bg_lightblue.png',
              image: 'assets/images/report_list_bg_image.png',
              color: Colours.background_light_blue,
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
              // 刷新事件
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
              // 加载事件
              _listBloc.add(ListLoad(params: _getRequestParam()));
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
                      padding: const EdgeInsets.fromLTRB(16, 56, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          EnterNameWidget(
                            height: UIUtils.getSearchItemHeight(
                                context, orientation),
                            controller: _enterNameController,
                          ),
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
                          DataDictBlocGridWidget(
                            title: '是否生效',
                            checkValue: _valid,
                            dataDictBloc: _validBloc,
                            onItemTap: (value) {
                              setState(() {
                                _valid = value;
                              });
                            },
                          ),
                          Offstage(
                            offstage: !_showAttentionLevel,
                            child: DataDictBlocGridWidget(
                              title: '关注程度',
                              checkValue: _attentionLevel,
                              dataDictBloc: _attentionLevelBloc,
                              onItemTap: (value) {
                                setState(() {
                                  _attentionLevel = value;
                                });
                              },
                            ),
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
        );
      },
    );
  }
}
