import 'dart:async';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/common/dict/data_dict_state.dart';
import 'package:pollution_source/module/common/dict/data_dict_widget.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/order/list/order_list_model.dart';
import 'package:pollution_source/module/order/list/order_list_repository.dart';
import 'package:pollution_source/res/colors.dart';
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
  final String alarmLevel;
  final String attentionLevel;
  final String enterId;
  final String monitorId;

  OrderListPage({
    this.state = '',
    this.alarmLevel = '',
    this.attentionLevel = '',
    this.enterId = '',
    this.monitorId = '',
  });

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final EasyRefreshController _refreshController = EasyRefreshController();
  final TextEditingController _enterNameController = TextEditingController();
  final List<DataDict> stateList = [
    DataDict(name: '全部', code: ''),
    DataDict(name: '待处理', code: '2'),
    DataDict(name: '已退回', code: '4'),
    DataDict(name: '已办结', code: '5'),
  ];
  final List<DataDict> alarmLevelList = [
    DataDict(name: '全部', code: ''),
    DataDict(name: '正常', code: '0'),
    DataDict(name: '黄色预警', code: '1'),
    DataDict(name: '橙色预警', code: '2'),
    DataDict(name: '红色预警', code: '3'),
  ];
  final List<DataDict> attentionLevelList = [
    DataDict(name: '全部', code: ''),
    DataDict(name: '非重点', code: '0'),
    DataDict(name: '重点', code: '1'),
  ];
  int stateIndex;
  int alarmLevelIndex;
  int attentionLevelIndex;
  int alarmTypeIndex;
  DateTime startTime;
  DateTime endTime;
  ListBloc _listBloc;
  DataDictBloc _alarmTypeBloc;
  Completer<void> _refreshCompleter;
  String areaCode = '';

  @override
  void initState() {
    super.initState();
    _initParam();
    // 初始化列表Bloc
    _listBloc = BlocProvider.of<ListBloc>(context);
    //初始化报警类型Bloc
    _alarmTypeBloc = DataDictBloc(
        dataDictRepository: DataDictRepository(HttpApi.orderAlarmType));
    //加载报警类型
    _alarmTypeBloc.add(DataDictLoad());
    _refreshCompleter = Completer<void>();
    // 首次加载
    _listBloc.add(ListLoad(
      isRefresh: true,
      params: OrderListRepository.createParams(
        currentPage: Constant.defaultCurrentPage,
        pageSize: Constant.defaultPageSize,
        enterId: widget.enterId,
        monitorId: widget.monitorId,
        enterName: _enterNameController.text,
        areaCode: areaCode,
        state: stateList[stateIndex].code,
        alarmLevel: alarmLevelList[alarmLevelIndex].code,
        attentionLevel: attentionLevelList[attentionLevelIndex].code,
        startTime: startTime,
        endTime: endTime,
        alarmType: _getDataDictBlocValue(_alarmTypeBloc, alarmTypeIndex),
      ),
    ));
  }

  @override
  void dispose() {
    // 释放资源
    _enterNameController.dispose();
    _refreshController.dispose();
    // 取消正在进行的请求
    final currentState = _listBloc?.state;
    if (currentState is ListLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  /// 初始化查询参数
  _initParam() {
    _enterNameController.text = '';
    startTime = null;
    endTime = null;
    alarmTypeIndex = 0;
    stateIndex = stateList.indexWhere((dataDict) {
      return dataDict.code == widget.state;
    });
    alarmLevelIndex = alarmLevelList.indexWhere((dataDict) {
      return dataDict.code == widget.alarmLevel;
    });
    attentionLevelIndex = attentionLevelList.indexWhere((dataDict) {
      return dataDict.code == widget.attentionLevel;
    });
  }

  String _getDataDictBlocValue(DataDictBloc bloc, int index) {
    final currentState = bloc.state;
    if (currentState is DataDictLoaded) {
      return currentState.dataDictList[index].code;
    } else {
      return '';
    }
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
                  title: '报警管理单列表',
                  subtitle: '展示报警管理单列表，点击列表项查看该报警管理单的详细信息',
                  subtitle2: subtitle2,
                  background: 'assets/images/button_bg_blue.png',
                  image: 'assets/images/order_list_bg_image.png',
                  color: Colours.background_blue,
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
              _refreshController.resetLoadState();
              _listBloc.add(ListLoad(
                isRefresh: true,
                params: OrderListRepository.createParams(
                  currentPage: Constant.defaultCurrentPage,
                  pageSize: Constant.defaultPageSize,
                  enterId: widget.enterId,
                  monitorId: widget.monitorId,
                  enterName: _enterNameController.text,
                  areaCode: areaCode,
                  state: stateList[stateIndex].code,
                  alarmLevel: alarmLevelList[alarmLevelIndex].code,
                  attentionLevel: attentionLevelList[attentionLevelIndex].code,
                  startTime: startTime,
                  endTime: endTime,
                  alarmType:
                      _getDataDictBlocValue(_alarmTypeBloc, alarmTypeIndex),
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
                  enterId: widget.enterId,
                  monitorId: widget.monitorId,
                  enterName: _enterNameController.text,
                  areaCode: areaCode,
                  state: stateList[stateIndex].code,
                  alarmLevel: alarmLevelList[alarmLevelIndex].code,
                  attentionLevel: attentionLevelList[attentionLevelIndex].code,
                  startTime: startTime,
                  endTime: endTime,
                  alarmType:
                      _getDataDictBlocValue(_alarmTypeBloc, alarmTypeIndex),
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
                      Gaps.vGap20,
                      const Text(
                        '报警单状态',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DataDictGrid(
                        checkIndex: stateIndex,
                        dataDictList: stateList,
                        onItemTap: (index) {
                          setState(() {
                            stateIndex = index;
                          });
                        },
                      ),
                      Gaps.vGap10,
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
                                  maxDateTime: endTime ?? DateTime.now(),
                                  locale: DateTimePickerLocale.zh_cn,
                                  onClose: () {},
                                  onConfirm: (dateTime, selectedIndex) {
                                    setState(() {
                                      startTime = dateTime;
                                    });
                                  },
                                );
                              },
                              child: Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: startTime != null
                                        ? Colours.primary_color
                                        : Colours.divider_color,
                                  ),
                                  color: startTime != null
                                      ? Colours.primary_color.withOpacity(0.3)
                                      : Colours.divider_color,
                                ),
                                child: Center(
                                  child: Text(
                                    DateUtil.getDateStrByDateTime(startTime,
                                            format:
                                                DateFormat.ZH_YEAR_MONTH_DAY) ??
                                        '开始时间',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: startTime != null
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
                                  minDateTime: startTime,
                                  maxDateTime: DateTime.now(),
                                  locale: DateTimePickerLocale.zh_cn,
                                  onClose: () {},
                                  onConfirm: (dateTime, selectedIndex) {
                                    setState(() {
                                      endTime = dateTime;
                                    });
                                  },
                                );
                              },
                              child: Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: endTime != null
                                        ? Colours.primary_color
                                        : Colours.divider_color,
                                  ),
                                  color: endTime != null
                                      ? Colours.primary_color.withOpacity(0.3)
                                      : Colours.divider_color,
                                ),
                                child: Center(
                                  child: Text(
                                    DateUtil.getDateStrByDateTime(endTime,
                                            format:
                                                DateFormat.ZH_YEAR_MONTH_DAY) ??
                                        '结束时间',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: endTime != null
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
                      Gaps.vGap20,
                      const Text(
                        '报警类型',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DataDictBlocGrid(
                        checkIndex: alarmTypeIndex,
                        dataDictBloc: _alarmTypeBloc,
                        onItemTap: (index) {
                          setState(() {
                            alarmTypeIndex = index;
                          });
                        },
                      ),
                      Gaps.vGap10,
                      const Text(
                        '工单级别',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DataDictGrid(
                        checkIndex: alarmLevelIndex,
                        dataDictList: alarmLevelList,
                        onItemTap: (index) {
                          setState(() {
                            alarmLevelIndex = index;
                          });
                        },
                      ),
                      Gaps.vGap10,
                      const Text(
                        '关注程度',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DataDictGrid(
                        checkIndex: attentionLevelIndex,
                        dataDictList: attentionLevelList,
                        onItemTap: (index) {
                          setState(() {
                            attentionLevelIndex = index;
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
  }
}
