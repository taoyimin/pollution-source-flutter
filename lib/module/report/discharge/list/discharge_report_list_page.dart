import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/report/discharge/list/discharge_report_list_model.dart';
import 'package:pollution_source/module/report/discharge/list/discharge_report_list_repository.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/widget/custom_header.dart';

class DischargeReportListPage extends StatefulWidget {
  final String enterId;
  final String dischargeId;
  final String monitorId;
  final String state;
  final String valid;

  DischargeReportListPage({
    this.enterId = '',
    this.dischargeId = '',
    this.monitorId = '',
    this.state = '',
    this.valid = '',
  });

  @override
  _DischargeReportListPageState createState() =>
      _DischargeReportListPageState();
}

class _DischargeReportListPageState extends State<DischargeReportListPage>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final EasyRefreshController _refreshController = EasyRefreshController();
  final TextEditingController _enterNameController = TextEditingController();
  final List<DataDict> validList = [
    DataDict(name: '全部', code: ''),
    DataDict(name: '生效中', code: '0'),
    DataDict(name: '已失效', code: '1'),
  ];
  int validIndex;
  ListBloc _listBloc;
  Completer<void> _refreshCompleter;
  String areaCode = '';

  @override
  void initState() {
    super.initState();
    initParam();
    // 初始化列表Bloc
    _listBloc = BlocProvider.of<ListBloc>(context);
    _refreshCompleter = Completer<void>();
    // 首次加载
    _listBloc.add(ListLoad(
      isRefresh: true,
      params: DischargeReportListRepository.createParams(
        currentPage: Constant.defaultCurrentPage,
        pageSize: Constant.defaultPageSize,
        enterId: widget.enterId,
        dischargeId: widget.dischargeId,
        monitorId: widget.monitorId,
        enterName: _enterNameController.text,
        areaCode: areaCode,
        state: widget.state,
        valid: validList[validIndex].code,
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
  initParam() {
    _enterNameController.text = '';
    validIndex = validList.indexWhere((dataDict) {
      return dataDict.code == widget.valid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Container(
        width: MediaQuery.of(context).size.width * 0.75,
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
                          '是否有效',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DataDictGrid(
                          checkIndex: validIndex,
                          dataDictList: validList,
                          onItemTap: (index) {
                            setState(() {
                              validIndex = index;
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
      ),
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
                return ListHeaderWidget2(
                  title: '排口异常申报列表',
                  subtitle: '展示排口异常申报列表，点击列表项查看该排口异常申报的详细信息',
                  subtitle2: subtitle2,
                  background: 'assets/images/button_bg_green.png',
                  image: 'assets/images/report_list_bg_image.png',
                  color: Color(0xFF29D0BF),
                  onSearchTap: (){
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
                      if (!state.hasNextPage){
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
              //刷新事件
              _listBloc.add(ListLoad(
                isRefresh: true,
                params: DischargeReportListRepository.createParams(
                  currentPage: Constant.defaultCurrentPage,
                  pageSize: Constant.defaultPageSize,
                  enterName: _enterNameController.text,
                  areaCode: areaCode,
                  enterId: widget.enterId,
                  dischargeId: widget.dischargeId,
                  monitorId: widget.monitorId,
                  state: widget.state,
                  valid: validList[validIndex].code,
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
                params: DischargeReportListRepository.createParams(
                  currentPage: currentPage,
                  pageSize: Constant.defaultPageSize,
                  enterName: _enterNameController.text,
                  areaCode: areaCode,
                  enterId: widget.enterId,
                  dischargeId: widget.dischargeId,
                  monitorId: widget.monitorId,
                  state: widget.state,
                  valid: validList[validIndex].code,
                ),
              ));
              return _refreshCompleter.future;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageLoadedList(List<DischargeReport> reportList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
                Application.router.navigateTo(context,
                    '${Routes.dischargeReportDetail}/${reportList[index].reportId}');
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
                                '监控点名：${reportList[index].monitorName}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '所属区域：${reportList[index].districtName}'),
                          ),
                        ],
                      ),
                      Gaps.vGap6,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '停产类型：${reportList[index].stopTypeStr}'),
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
