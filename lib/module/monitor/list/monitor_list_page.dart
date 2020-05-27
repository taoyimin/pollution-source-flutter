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

/// 监控点列表
class MonitorListPage extends StatefulWidget {
  final String enterId;
  final String dischargeId;
  final String monitorType;
  final String state;
  final String outType;
  final String attentionLevel;
  final int type; //页面启动类型 0：点击列表项查看详情 1：点击列表项携带数据返回上一层

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final EasyRefreshController _refreshController = EasyRefreshController();
  final TextEditingController _enterNameController = TextEditingController();

  /// 运维用户隐藏关注程度相关布局
  final bool _showAttentionLevel = SpUtil.getInt(Constant.spUserType) != 2;

//  final List<DataDict> _stateList = [
//    DataDict(name: '全部', code: ''),
//    DataDict(name: '在线', code: '1'),
//    DataDict(name: '预警', code: '2'),
//    DataDict(name: '超标', code: '3'),
//    DataDict(name: '负值', code: '4'),
//    DataDict(name: '超大值', code: '5'),
//    DataDict(name: '零值', code: '6'),
//    DataDict(name: '脱机', code: '7'),
//    DataDict(name: '异常申报', code: '8'),
//  ];
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
  String _state;
  String _outType;
  String _monitorType;
  String _attentionLevel;
  int _currentPage = Constant.defaultCurrentPage;
  ListBloc _listBloc;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    initParam();
    // 加载区域信息
    _areaBloc.add(CollectionLoad());
    // 加载监控点类型
    _monitorTypeBloc.add(DataDictLoad());
    // 加载监控点状态
    _stateBloc.add(DataDictLoad());
    // 加载排放类型
    _outTypeBloc.add(DataDictLoad());
    // 加载关注程度
    if (_showAttentionLevel) _attentionLevelBloc.add(DataDictLoad());
    _refreshCompleter = Completer<void>();
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
                          const Text(
                            '企业名称',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gaps.vGap10,
                          Container(
                            height: UIUtils.getSearchItemHeight(
                                context, orientation),
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
                          Gaps.vGap20,
                          AreaWidget(
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
                          const Text(
                            '监控点类型',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DataDictBlocGrid(
                            checkValue: _monitorType,
                            dataDictBloc: _monitorTypeBloc,
                            onItemTap: (value) {
                              setState(() {
                                _monitorType = value;
                              });
                            },
                          ),
                          const Text(
                            '监控点状态',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DataDictBlocGrid(
                            addFirst: false,
                            checkValue: _state,
                            dataDictBloc: _stateBloc,
                            onItemTap: (value) {
                              setState(() {
                                _state = value;
                              });
                            },
                          ),
                          const Text(
                            '排放类型',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DataDictBlocGrid(
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
                            child: const Text(
                              '关注程度',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Offstage(
                            offstage: !_showAttentionLevel,
                            child: DataDictBlocGrid(
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
