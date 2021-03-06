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
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_repository.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';

import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/module/common/common_widget.dart';

/// 监控点列表界面
class MonitorListPage extends StatefulWidget {
  final String enterId;
  final String dischargeId;
  final String monitorType;
  final String state;
  final String outType;
  final String attentionLevel;

  /// 页面启动类型 0：点击列表项查看详情
  /// 1：点击列表项携带数据返回上一层
  /// 2：上报仪器参数界面选择监控点时打开，点击列表项携带数据返回上一层，并且监控点类型只能选废水
  final int type;

  MonitorListPage({
    this.enterId = '',
    this.dischargeId = '',
    this.monitorType = '',
    this.state = '',
    this.outType = '',
    this.attentionLevel = '',
    this.type = 0,
  });

  @override
  _MonitorListPageState createState() => _MonitorListPageState();
}

class _MonitorListPageState extends State<MonitorListPage> {
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
    listRepository: MonitorListRepository(),
  );

  /// 区域Bloc
  final CollectionBloc _areaBloc = CollectionBloc(
    collectionRepository: AreaRepository(),
  );

  /// 监控点类型Bloc
  final DataDictBloc _monitorTypeBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.outletType),
  );

  /// 监控点类型Bloc
  final DataDictBloc _stateBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.monitorState),
  );

  /// 排放类型Bloc
  final DataDictBloc _outTypeBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.outType),
  );

  /// 关注程度Bloc
  final DataDictBloc _attentionLevelBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.attentionLevel),
  );

  /// 区域信息
  Result _areaResult;

  /// 排口状态
  String _state;

  /// 排放类型
  String _outType;

  /// 监控点类型
  String _monitorType;

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
    // 加载监控点类型
    _monitorTypeBloc.add(DataDictLoad());
    // 加载监控点状态
    _stateBloc.add(DataDictLoad());
    // 加载排放类型
    _outTypeBloc.add(DataDictLoad());
    // 加载关注程度
    if (_showAttentionLevel) _attentionLevelBloc.add(DataDictLoad());
    _refreshCompleter = Completer<void>();
    // 首次加载
    _listBloc.add(ListLoad(isRefresh: true, params: _getRequestParam()));
  }

  @override
  void dispose() {
    // 释放资源
    _refreshController.dispose();
    _enterNameController.dispose();
    // 取消正在进行的请求
    if (_listBloc?.state is ListLoading)
      (_listBloc?.state as ListLoading).cancelToken.cancel();
    if (_areaBloc?.state is CollectionLoading)
      (_areaBloc?.state as CollectionLoading).cancelToken.cancel();
    if (_monitorTypeBloc?.state is DataDictLoading)
      (_monitorTypeBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_stateBloc?.state is DataDictLoading)
      (_stateBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_outTypeBloc?.state is DataDictLoading)
      (_outTypeBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_attentionLevelBloc?.state is DataDictLoading)
      (_attentionLevelBloc?.state as DataDictLoading).cancelToken.cancel();
    super.dispose();
  }

  /// 初始化查询参数
  initParam() {
    _enterNameController.text = '';
    _areaResult = null;
    _monitorType = widget.monitorType;
    _state = widget.state;
    _outType = widget.outType;
    _attentionLevel = widget.attentionLevel;
  }

  /// 获取请求参数
  Map<String, dynamic> _getRequestParam() {
    return MonitorListRepository.createParams(
      currentPage: _currentPage,
      pageSize: Constant.defaultPageSize,
      enterId: widget.enterId,
      dischargeId: widget.dischargeId,
      enterName: _enterNameController.text,
      cityCode: _areaResult?.cityId ?? '',
      areaCode: _areaResult?.areaId ?? '',
      monitorType: _monitorType,
      state: _state,
      outType: _outType,
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
          final String title = widget.type == 0 ? '在线数据' : '监控点';
          return <Widget>[
            ListHeaderWidget(
              listBloc: _listBloc,
              title: '$title列表',
              subtitle: '展示污染源$title列表，点击列表项查看该$title的详细信息',
              background: 'assets/images/button_bg_red.png',
              image: 'assets/images/monitor_list_bg_image.png',
              color: Colours.background_red,
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

  Widget _buildPageLoadedList(List<Monitor> monitorList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
                switch (widget.type) {
                  case 0:
                    Application.router.navigateTo(context,
                        '${Routes.monitorDetail}/${monitorList[index].monitorId}');
                    break;
                  case 1:
                  case 2:
                    Navigator.pop(context, monitorList[index]);
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
                          monitorList[index].imagePath,
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
                                '${monitorList[index].enterName}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Gaps.vGap6,
                            ListTileWidget(
                                '站点名称：${monitorList[index].monitorName}'),
                            Gaps.vGap6,
                            ListTileWidget(
                                '监测类型：${monitorList[index].monitorCategoryStr}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: monitorList.length,
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
                      padding: EdgeInsets.fromLTRB(16, 56, 16, 20),
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
                            title: '监控点类型',
                            checkValue: _monitorType,
                            dataDictBloc: _monitorTypeBloc,
                            onItemTap: (value) {
                              setState(() {
                                _monitorType = value;
                              });
                            },
                          ),
                          DataDictBlocGridWidget(
                            title: '监控点状态',
                            addFirst: false,
                            checkValue: _state,
                            dataDictBloc: _stateBloc,
                            onItemTap: (value) {
                              setState(() {
                                _state = value;
                              });
                            },
                          ),
                          DataDictBlocGridWidget(
                            title: '排放类型',
                            checkValue: _outType,
                            dataDictBloc: _outTypeBloc,
                            onItemTap: (value) {
                              setState(() {
                                _outType = value;
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
                          if(widget.type == 2 && _monitorType != 'outletType2'){
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('仪器参数上报只能选择废水监控点！'),
                                action: SnackBarAction(
                                    label: '我知道了',
                                    textColor: Colours.primary_color,
                                    onPressed: () {}),
                              ),
                            );
                          }else {
                            Navigator.pop(context);
                            _refreshController.callRefresh();
                          }
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
