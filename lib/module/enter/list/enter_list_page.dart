import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/common/common_model.dart';
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

class EnterListPage extends StatefulWidget {
  final String state;
  final String enterType;
  final String attentionLevel;
  final bool automaticallyImplyLeading; //是否显示左上角返回箭头
  final int type; //启用页面的类型 0：点击列表项查看详情 1：点击列表项返回上一层与企业信息

  EnterListPage({
    this.state = '',
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
  final List<DataDict> enterTypeList = [
    DataDict(name: '全部', code: ''),
    DataDict(name: '雨水企业', code: '1'),
    DataDict(name: '废水企业', code: '2'),
    DataDict(name: '废气企业', code: '3'),
    DataDict(name: '水气企业', code: '4'),
    DataDict(name: '许可证企业', code: '5'),
  ];
  final List<DataDict> stateList = [
    DataDict(name: '全部', code: ''),
    DataDict(name: '在线', code: '1'),
  ];
  final List<DataDict> attentionLevelList = [
    DataDict(name: '全部', code: ''),
    DataDict(name: '非重点', code: '0'),
    DataDict(name: '重点', code: '1'),
  ];
  ListBloc _listBloc;
  Completer<void> _refreshCompleter;
  int enterTypeIndex;
  int stateIndex;
  int attentionLevelIndex;
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
      params: EnterListRepository.createParams(
        currentPage: Constant.defaultCurrentPage,
        pageSize: Constant.defaultPageSize,
        enterName: _enterNameController.text,
        areaCode: areaCode,
        state: stateList[stateIndex].code,
        enterType: enterTypeList[enterTypeIndex].code,
        attentionLevel: attentionLevelList[attentionLevelIndex].code,
      ),
    ));
  }

  @override
  void dispose() {
    //释放资源
    _enterNameController.dispose();
    _refreshController.dispose();
    //取消正在进行的请求
    final currentState = _listBloc?.state;
    if (currentState is ListLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  /// 初始化查询参数
  initParam() {
    _enterNameController.text = '';
    enterTypeIndex = enterTypeList.indexWhere((dataDict) {
      return dataDict.code == widget.enterType;
    });
    stateIndex = stateList.indexWhere((dataDict) {
      return dataDict.code == widget.state;
    });
    attentionLevelIndex = attentionLevelList.indexWhere((dataDict) {
      return dataDict.code == widget.attentionLevel;
    });
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
                params: EnterListRepository.createParams(
                  currentPage: Constant.defaultCurrentPage,
                  pageSize: Constant.defaultPageSize,
                  enterName: _enterNameController.text,
                  areaCode: areaCode,
                  state: stateList[stateIndex].code,
                  enterType: enterTypeList[enterTypeIndex].code,
                  attentionLevel: attentionLevelList[attentionLevelIndex].code,
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
                params: EnterListRepository.createParams(
                  currentPage: currentPage,
                  pageSize: Constant.defaultPageSize,
                  enterName: _enterNameController.text,
                  areaCode: areaCode,
                  state: stateList[stateIndex].code,
                  enterType: enterTypeList[enterTypeIndex].code,
                  attentionLevel: attentionLevelList[attentionLevelIndex].code,
                ),
              ));
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
          //创建列表项
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
                              padding: const EdgeInsets.only(right: 10),
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

  Widget _buildEndDrawer(){
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
                  padding:const EdgeInsets.fromLTRB(16, 56, 16, 20),
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
                        checkIndex: enterTypeIndex,
                        dataDictList: enterTypeList,
                        onItemTap: (index) {
                          setState(() {
                            enterTypeIndex = index;
                          });
                        },
                      ),
                      const Text(
                        '是否在线',
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
