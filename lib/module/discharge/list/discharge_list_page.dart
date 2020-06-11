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

/// 排口列表
class DischargeListPage extends StatefulWidget {
  final String enterId;
  final String dischargeType;
  final String state;
  final String attentionLevel;
  final int type; //启用页面的类型 0：点击列表项查看详情 1：点击列表项返回上一层与排口信息

  DischargeListPage({
    this.enterId = '',
    this.dischargeType = '',
    this.state = '',
    this.attentionLevel = '',
    this.type = 0,
  });

  @override
  _DischargeListPageState createState() => _DischargeListPageState();
}

class _DischargeListPageState extends State<DischargeListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final EasyRefreshController _refreshController = EasyRefreshController();
  final TextEditingController _enterNameController = TextEditingController();

  /// 环保用户显示选择区域相关布局
  final bool _showArea = SpUtil.getInt(Constant.spUserType) == 0;

  /// 区域Bloc
  final CollectionBloc _areaBloc = CollectionBloc(
    collectionRepository: AreaRepository(),
  );

  /// 排口类型Bloc
  final DataDictBloc _dischargeTypeBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.outletType),
  );

  /// 关注程度Bloc
  final DataDictBloc _attentionLevelBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.attentionLevel),
  );

  /// 区域信息
  Result _areaResult;

  /// 排口类型
  String _dischargeType;

  /// 关注程度
  String _attentionLevel;

  /// 当前页
  int _currentPage = Constant.defaultCurrentPage;

  // 列表Bloc
  ListBloc _listBloc;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    initParam();
    // 加载区域信息
    if (_showArea) _areaBloc.add(CollectionLoad());
    // 加载排口类型
    _dischargeTypeBloc.add(DataDictLoad());
    // 加载关注程度
    _attentionLevelBloc.add(DataDictLoad());
    _refreshCompleter = Completer<void>();
    // 初始化列表Bloc
    _listBloc = BlocProvider.of<ListBloc>(context);
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
    if (_dischargeTypeBloc?.state is DataDictLoading)
      (_dischargeTypeBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_attentionLevelBloc?.state is DataDictLoading)
      (_attentionLevelBloc?.state as DataDictLoading).cancelToken.cancel();
    super.dispose();
  }

  /// 初始化查询参数
  initParam() {
    _enterNameController.text = '';
    _areaResult = null;
    _dischargeType = widget.dischargeType;
    _attentionLevel = widget.attentionLevel;
  }

  /// 获取请求参数
  Map<String, dynamic> _getRequestParam() {
    return DischargeListRepository.createParams(
      currentPage: _currentPage,
      pageSize: Constant.defaultPageSize,
      enterId: widget.enterId,
      enterName: _enterNameController.text,
      cityCode: _areaResult?.cityId ?? '',
      areaCode: _areaResult?.areaId ?? '',
      dischargeType: _dischargeType,
      state: widget.state,
      attentionLevel: widget.attentionLevel,
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
              title: '排口列表',
              subtitle: '展示污染源排口列表，点击列表项查看该排口的详细信息',
              background: 'assets/images/button_bg_yellow.png',
              image: 'assets/images/discharge_list_bg_image.png',
              color: Colours.background_yellow,
              onSearchTap: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
            )
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

  Widget _buildPageLoadedList(List<Discharge> dischargeList) {
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
                            title: '排口类型',
                            checkValue: _dischargeType,
                            dataDictBloc: _dischargeTypeBloc,
                            onItemTap: (value) {
                              setState(() {
                                _dischargeType = value;
                              });
                            },
                          ),
                          DataDictBlocGridWidget(
                            title: '关注程度',
                            checkValue: _attentionLevel,
                            dataDictBloc: _attentionLevelBloc,
                            onItemTap: (value) {
                              setState(() {
                                _attentionLevel = value;
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
        );
      },
    );
  }
}
