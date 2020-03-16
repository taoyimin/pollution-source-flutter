import 'dart:async';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/common/dict/data_dict_widget.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
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
import 'package:pollution_source/widget/custom_header.dart';

/// 监控点列表
class MonitorListPage extends StatefulWidget {
  final String enterId;
  final String dischargeId;
  final String monitorType;
  final String state;
  final String attentionLevel;
  final int type; //页面启动类型 0：点击列表项查看详情 1：点击列表项携带数据返回上一层

  MonitorListPage({
    this.enterId = '',
    this.dischargeId = '',
    this.monitorType = '',
    this.state = '',
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

  final List<DataDict> _stateList = [
    DataDict(name: '全部', code: ''),
    DataDict(name: '在线', code: '1'),
    DataDict(name: '预警', code: '2'),
    DataDict(name: '超标', code: '3'),
    DataDict(name: '负值', code: '4'),
    DataDict(name: '超大值', code: '5'),
    DataDict(name: '零值', code: '6'),
    DataDict(name: '脱机', code: '7'),
    DataDict(name: '异常申报', code: '8'),
  ];

  /// 监控点类型Bloc
  final DataDictBloc _monitorTypeBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.outletType),
  );

  /// 关注程度Bloc
  final DataDictBloc _attentionLevelBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.attentionLevel),
  );
  String _state;
  String _monitorType;
  String _attentionLevel;
  int _currentPage = Constant.defaultCurrentPage;
  ListBloc _listBloc;
  Completer<void> _refreshCompleter;
  String _areaCode = '';

  @override
  void initState() {
    super.initState();
    initParam();
    // 加载监控点类型
    _monitorTypeBloc.add(DataDictLoad());
    // 加载关注程度
    if (_showAttentionLevel) _attentionLevelBloc.add(DataDictLoad());
    _refreshCompleter = Completer<void>();
    _listBloc = BlocProvider.of<ListBloc>(context);
    // 首次加载
    _listBloc.add(ListLoad(isRefresh: true, params: getRequestParam()));
  }

  @override
  void dispose() {
    // 释放资源
    _refreshController.dispose();
    _enterNameController.dispose();
    // 取消正在进行的请求
    final currentState = _listBloc?.state;
    if (currentState is ListLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  /// 初始化查询参数
  initParam() {
    _enterNameController.text = '';
    _monitorType = widget.monitorType;
    _state = widget.state;
    _attentionLevel = widget.attentionLevel;
  }

  /// 获取请求参数
  Map<String, dynamic> getRequestParam() {
    return MonitorListRepository.createParams(
      currentPage: _currentPage,
      pageSize: Constant.defaultPageSize,
      enterId: widget.enterId,
      dischargeId: widget.dischargeId,
      enterName: _enterNameController.text,
      areaCode: _areaCode,
      monitorType: _monitorType,
      state: _state,
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
                  title: '在线数据列表',
                  subtitle: '展示在线数据列表，点击列表项查看该在线数据的详细信息',
                  subtitle2: subtitle2,
                  background: 'assets/images/button_bg_red.png',
                  image: 'assets/images/monitor_list_bg_image.png',
                  color: Colours.background_red,
                  onSearchTap: () {
                    _scaffoldKey.currentState.openEndDrawer();
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
                      if (!state.hasNextPage) {
                        _refreshController.finishLoad(
                            noMore: !state.hasNextPage, success: true);
                      }
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
              _currentPage = Constant.defaultCurrentPage;
              _refreshController.resetLoadState();
              _listBloc.add(ListLoad(
                isRefresh: true,
                params: getRequestParam(),
              ));
              return _refreshCompleter.future;
            },
            onLoad: () async {
              final currentState = _listBloc.state;
              if (currentState is ListLoaded)
                _currentPage = currentState.currentPage + 1;
              else
                _currentPage = Constant.defaultCurrentPage;
              _listBloc.add(ListLoad(params: getRequestParam()));
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
          //创建列表项
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
                            LabelWrapWidget(
                                labelList: monitorList[index].labelList),
                            monitorList[index].labelList.length == 0
                                ? Gaps.empty
                                : Gaps.vGap6,
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: ListTileWidget(
                                      '站点名称：${monitorList[index].monitorName}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ListTileWidget(
                                      '监测类别：${monitorList[index].monitorCategoryStr}'),
                                ),
                              ],
                            ),
                            Gaps.vGap6,
                            ListTileWidget(
                                '监控点地址：${monitorList[index].monitorAddress}'),
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
        childCount: monitorList.length,
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
                        height: 36,
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
                      Gaps.vGap30,
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
                      DataDictGrid(
                        checkValue: _state,
                        dataDictList: _stateList,
                        onItemTap: (value) {
                          setState(() {
                            _state = value;
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
  }
}
