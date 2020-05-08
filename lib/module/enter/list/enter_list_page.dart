import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/common/dict/data_dict_widget.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/enter/list/enter_list_repository.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/label_widget.dart';
import 'package:pollution_source/widget/custom_header.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/module/common/common_widget.dart';

/// 企业列表
class EnterListPage extends StatefulWidget {
  final String state;
  final String hasAll;
  final String enterType;
  final String attentionLevel;
  final bool automaticallyImplyLeading; //是否显示左上角返回箭头
  final int type; //启用页面的类型 0：点击列表项查看详情 1：点击列表项返回上一层与企业信息

  EnterListPage({
    this.state = '',
    this.hasAll = '',
    this.enterType = '',
    this.attentionLevel = '',
    this.automaticallyImplyLeading = true,
    this.type = 0,
  });

  @override
  _EnterListPageState createState() => _EnterListPageState();
}

class _EnterListPageState extends State<EnterListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final EasyRefreshController _refreshController = EasyRefreshController();
  final TextEditingController _enterNameController = TextEditingController();

  /// 企业类型菜单
  final List<DataDict> _enterTypeList = [
    DataDict(name: '全部', code: ''),
    //DataDict(name: '雨水企业', code: '1'),
    DataDict(name: '废水企业', code: '2'),
    DataDict(name: '废气企业', code: '3'),
    DataDict(name: '水气企业', code: '4'),
    DataDict(name: '许可证企业', code: '5'),
  ];

  /// 是否在线菜单
  final List<DataDict> _stateList = [
    DataDict(name: '全部', code: ''),
    DataDict(name: '在线', code: '1'),
  ];

  /// 关注程度Bloc
  final DataDictBloc _attentionLevelBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.attentionLevel),
  );
  ListBloc _listBloc;
  Completer<void> _refreshCompleter;
  String _enterType;
  String _state;
  String _attentionLevel;
  int _currentPage = Constant.defaultCurrentPage;
  String _areaCode = '';

  @override
  void initState() {
    super.initState();
    _initParam();
    // 加载关注程度
    _attentionLevelBloc.add(DataDictLoad());
    // 初始化列表Bloc
    _listBloc = BlocProvider.of<ListBloc>(context);
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
    final currentState = _listBloc?.state;
    if (currentState is ListLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  /// 初始化查询参数
  _initParam() {
    _enterNameController.text = '';
    _enterType = widget.enterType;
    _state = widget.state;
    _attentionLevel = widget.attentionLevel;
  }

  /// 获取请求参数
  Map<String, dynamic> _getRequestParam() {
    return EnterListRepository.createParams(
      currentPage: _currentPage,
      pageSize: Constant.defaultPageSize,
      hasAll: widget.hasAll,
      enterName: _enterNameController.text,
      areaCode: _areaCode,
      state: _state,
      enterType: _enterType,
      attentionLevel: _attentionLevel,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  title: '企业列表',
                  subtitle: '展示污染源企业列表，点击列表项查看该企业的详细信息',
                  subtitle2: subtitle2,
                  background: 'assets/images/button_bg_lightblue.png',
                  image: 'assets/images/enter_list_bg_image.png',
                  color: Colours.background_light_blue,
                  automaticallyImplyLeading: widget.automaticallyImplyLeading,
                  onSearchTap: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  },
//                  popupMenuButton: PopupMenuButton<String>(
//                    itemBuilder: (BuildContext context) =>
//                        <PopupMenuItem<String>>[
//                      UIUtils.getSelectView(Icons.message, '发起群聊', 'A'),
//                      UIUtils.getSelectView(Icons.group_add, '添加服务', 'B'),
//                    ],
//                    onSelected: (String action) {
//                      // 点击选项的时候
//                      switch (action) {
//                        case 'A':
//                          break;
//                        case 'B':
//                          break;
//                      }
//                    },
//                  ),
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
        ),
      ),
    );
  }

  Widget _buildPageLoadedList(List<Enter> enterList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // 创建列表项
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
                switch (widget.type) {
                  case 0:
                    Application.router.navigateTo(context,
                        '${Routes.enterDetail}/${enterList[index].enterId}');
                    break;
                  case 1:
                    Navigator.pop(context, enterList[index]);
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
                          enterList[index].imagePath,
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
                              padding: EdgeInsets.only(
                                  right: enterList[index].isImportant ? 13 : 0),
                              child: Text(
                                '${enterList[index].enterName}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Gaps.vGap6,
                            LabelWrapWidget(
                                labelList: enterList[index].labelList),
                            enterList[index].labelList.length == 0
                                ? Gaps.empty
                                : Gaps.vGap6,
                            ListTileWidget(
                                '地址：${enterList[index].enterAddress}'),
                            Gaps.vGap6,
                            ListTileWidget(
                                '行业类别：${enterList[index].industryTypeStr}'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Offstage(
                  offstage: !enterList[index].isImportant,
                  child: LabelView(
                    Size.fromHeight(80),
                    labelText: "重点",
                    labelColor: Theme.of(context).primaryColor,
                    labelAlignment: LabelAlignment.rightTop,
                  ),
                ),
              ],
            ),
          );
        },
        childCount: enterList.length,
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
                        '企业类型',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DataDictGrid(
                        checkValue: _enterType,
                        dataDictList: _enterTypeList,
                        onItemTap: (value) {
                          setState(() {
                            _enterType = value;
                          });
                        },
                      ),
                      const Text(
                        '是否安装在线',
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
                      const Text(
                        '关注程度',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DataDictBlocGrid(
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
  }
}
