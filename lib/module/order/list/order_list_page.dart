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
import 'package:pollution_source/module/common/dict/data_dict_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/common/dict/data_dict_state.dart';
import 'package:pollution_source/module/common/dict/data_dict_widget.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/common/list/list_widget.dart';
import 'package:pollution_source/module/order/list/order_list_model.dart';
import 'package:pollution_source/module/order/list/order_list_repository.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';

import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/widget/label_widget.dart';

/// 报警管理单列表界面
class OrderListPage extends StatefulWidget {
  final String alarmState;
  final String alarmLevel;
  final String attentionLevel;
  final String enterId;
  final String monitorId;
  final DateTime startTime;

  OrderListPage({
    this.alarmState = '',
    this.alarmLevel = '',
    this.attentionLevel = '',
    this.enterId = '',
    this.monitorId = '',
    this.startTime,
  });

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final EasyRefreshController _refreshController = EasyRefreshController();
  final TextEditingController _enterNameController = TextEditingController();

  /// 环保用户显示选择区域相关布局
  final bool _showArea = SpUtil.getInt(Constant.spUserType) == 0;

  /// 区域Bloc
  final CollectionBloc _areaBloc = CollectionBloc(
    collectionRepository: AreaRepository(),
  );

  /// 报警单状态Bloc
  final DataDictBloc _alarmStateBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.orderState),
  );

  /// 关注程度Bloc
  final DataDictBloc _attentionLevelBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.attentionLevel),
  );

  /// 报警类型Bloc
  final DataDictBloc _alarmTypeBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.orderAlarmType),
  );

  /// 报警原因Bloc
  final DataDictBloc _alarmCauseBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.orderAlarmCause),
  );

  /// 报警级别Bloc
  final DataDictBloc _alarmLevelBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.orderAlarmLevel),
  );

  /// 区域信息
  Result _areaResult;

  /// 报警单状态
  String _alarmState;

  /// 关注程度
  String _attentionLevel;

  /// 报警类型
  String _alarmType;

  /// 报警原因
  String _alarmCause;

  /// 报警级别
  String _alarmLevel;

  /// 报警开始时间
  DateTime _startTime;

  /// 报警结束时间
  DateTime _endTime;

  /// 当前页
  int _currentPage = Constant.defaultCurrentPage;

  /// 列表Bloc
  ListBloc _listBloc;

  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _initParam();
    // 加载区域信息
    if (_showArea) _areaBloc.add(CollectionLoad());
    // 加载报警管理单状态
    _alarmStateBloc.add(DataDictLoad());
    // 加载关注程度
    _attentionLevelBloc.add(DataDictLoad());
    // 加载报警类型
    _alarmTypeBloc.add(DataDictLoad());
    // 加载报警原因
    _alarmCauseBloc.add(DataDictLoad());
    // 加载报警级别
    _alarmLevelBloc.add(DataDictLoad());
    _refreshCompleter = Completer<void>();
    // 初始化列表Bloc
    _listBloc = BlocProvider.of<ListBloc>(context);
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
    if (_alarmStateBloc?.state is DataDictLoading)
      (_alarmStateBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_attentionLevelBloc?.state is DataDictLoading)
      (_attentionLevelBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_alarmTypeBloc?.state is DataDictLoading)
      (_alarmTypeBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_alarmCauseBloc?.state is DataDictLoading)
      (_alarmCauseBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_alarmLevelBloc?.state is DataDictLoading)
      (_alarmLevelBloc?.state as DataDictLoading).cancelToken.cancel();
    super.dispose();
  }

  /// 初始化查询参数
  _initParam() {
    _enterNameController.text = '';
    _areaResult = null;
    _startTime = widget.startTime;
    _endTime = null;
    _alarmType = '';
    _alarmCause = '';
    _alarmLevel = widget.alarmLevel;
    _alarmState = widget.alarmState;
    _attentionLevel = widget.attentionLevel;
  }

  /// 获取请求参数
  Map<String, dynamic> _getRequestParam() {
    return OrderListRepository.createParams(
      currentPage: _currentPage,
      pageSize: Constant.defaultPageSize,
      enterId: widget.enterId,
      monitorId: widget.monitorId,
      enterName: _enterNameController.text,
      cityCode: _areaResult?.cityId ?? '',
      areaCode: _areaResult?.areaId ?? '',
      alarmState: _alarmState,
      alarmLevel: _alarmLevel,
      alarmType: _alarmType,
      alarmCause: _alarmCause,
      attentionLevel: _attentionLevel,
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
              title: '报警管理单列表',
              subtitle: '展示报警管理单列表，点击列表项查看该报警管理单的详细信息',
              background: 'assets/images/button_bg_blue.png',
              image: 'assets/images/order_list_bg_image.png',
              color: Colours.background_blue,
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

  Widget _buildPageLoadedList(List<Order> orderList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
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
                      Padding(
                        padding: EdgeInsets.only(
                            right: orderList[index].alarmLevel == null ||
                                    orderList[index].alarmLevel == '0'
                                ? 0
                                : 13),
                        child: Text(
                          '${orderList[index].enterName}',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
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
                                '报警单状态：${orderList[index].alarmStateStr}'),
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
                                '所属区域：${orderList[index].districtName}'),
                          ),
                        ],
                      ),
                      Gaps.vGap6,
                      ListTileWidget('报警描述：${orderList[index].alarmDesc}'),
                    ],
                  ),
                ),
                Offstage(
                  offstage: orderList[index].alarmLevel == null ||
                      orderList[index].alarmLevel == '0',
                  child: LabelView(
                    Size.fromHeight(80),
                    labelText: '${orderList[index].alarmLevelName}',
                    labelColor: () {
                      switch (orderList[index].alarmLevel) {
                        case '1':
                          return Colors.amber;
                        case '2':
                          return Colors.deepOrangeAccent;
                        case '3':
                          return Colors.red;
                        default:
                          return Theme.of(context).primaryColor;
                      }
                    }(),
                    labelAlignment: LabelAlignment.rightTop,
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

  Widget _buildEndDrawer() {
    return OrientationBuilder(builder: (context, orientation) {
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
                        DateTimeWidget(
                          title: '报警时间',
                          height: UIUtils.getSearchItemHeight(context, orientation),
                          startTime: _startTime,
                          endTime: _endTime,
                          maxStartTime: _endTime ??
                              DateTime.now().add(Duration(days: -1)),
                          maxEndTime: DateTime.now().add(Duration(days: -1)),
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
                          title: '报警单状态',
                          defaultDataDict: DataDict(name: '未办结', code: '00'),
                          checkValue: _alarmState,
                          dataDictBloc: _alarmStateBloc,
                          onItemTap: (value) {
                            setState(() {
                              _alarmState = value;
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
                        DataDictBlocGridWidget(
                          title: '报警原因',
                          checkValue: _alarmCause,
                          dataDictBloc: _alarmCauseBloc,
                          onItemTap: (value) {
                            setState(() {
                              _alarmCause = value;
                            });
                          },
                        ),
                        DataDictBlocGridWidget(
                          title: '报警级别',
                          checkValue: _alarmLevel,
                          dataDictBloc: _alarmLevelBloc,
                          onItemTap: (value) {
                            setState(() {
                              _alarmLevel = value;
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
    });
  }
}
