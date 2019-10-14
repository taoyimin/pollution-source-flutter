import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/enter/enter_detail_page.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/widget/label_widget.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'enter_list.dart';

class EnterListPage extends StatefulWidget {
  final String state;
  final String enterType;
  final String attentionLevel;

  EnterListPage({
    this.state = '',
    this.enterType = '',
    this.attentionLevel = '',
  });

  @override
  _EnterListPageState createState() => _EnterListPageState();
}

class _EnterListPageState extends State<EnterListPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  EnterListBloc _enterListBloc;
  EasyRefreshController _refreshController;
  TextEditingController _editController;
  Completer<void> _refreshCompleter;

  String areaCode = '';

  @override
  void initState() {
    super.initState();
    _enterListBloc = BlocProvider.of<EnterListBloc>(context);
    _refreshController = EasyRefreshController();
    _refreshCompleter = Completer<void>();
    _scrollController = ScrollController();
    _editController = TextEditingController();
    //首次加载
    _enterListBloc.dispatch(EnterListLoad(
      state: widget.state,
      enterType: widget.enterType,
      attentionLevel: widget.attentionLevel,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
    _editController.dispose();
  }

  Widget _getPageLoadedList(List<Enter> enterList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EnterDetailPage();
                    },
                  ),
                );
              },
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      getBoxShadow(),
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
                            ListTileWidget('地址：${enterList[index].address}'),
                            Gaps.vGap6,
                            ListTileWidget(
                                '行业类别：${enterList[index].industryType}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: extended.NestedScrollView(
        controller: _scrollController,
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + kToolbarHeight;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            ListHeaderWidget(
              title: '企业列表',
              subtitle: '展示污染源企业列表，点击列表项查看该企业的详细信息',
              background: 'assets/images/button_bg_lightblue.png',
              image: 'assets/images/enter_list_bg_image.png',
              color: Colors.blue,
              showSearch: true,
              editController: _editController,
              scrollController: _scrollController,
              onSearchPressed: () => _refreshController.callRefresh(),
              areaPickerListener: (areaId) {
                areaCode = areaId;
              },
              popupMenuButton: PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  selectView(Icons.message, '发起群聊', 'A'),
                  selectView(Icons.group_add, '添加服务', 'B'),
                ],
                onSelected: (String action) {
                  // 点击选项的时候
                  switch (action) {
                    case 'A':
                      break;
                    case 'B':
                      break;
                  }
                },
              ),
            ),
          ];
        },
        body: extended.NestedScrollViewInnerScrollPositionKeyWidget(
          Key('list'),
          EasyRefresh.custom(
            controller: _refreshController,
            header: getRefreshClassicalHeader(),
            footer: getLoadClassicalFooter(),
            slivers: <Widget>[
              BlocListener<EnterListBloc, EnterListState>(
                listener: (context, state) {
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer();
                },
                child: BlocBuilder<EnterListBloc, EnterListState>(
                  builder: (context, state) {
                    if (state is EnterListLoading) {
                      return PageLoadingWidget();
                    } else if (state is EnterListEmpty) {
                      return PageEmptyWidget();
                    } else if (state is EnterListError) {
                      return PageErrorWidget(errorMessage: state.errorMessage);
                    } else if (state is EnterListLoaded) {
                      if (!state.hasNextPage)
                        _refreshController.finishLoad(
                            noMore: !state.hasNextPage, success: true);
                      return _getPageLoadedList(state.enterList);
                    } else {
                      return SliverFillRemaining();
                    }
                  },
                ),
              ),
            ],
            onRefresh: () async {
              _enterListBloc.dispatch(EnterListLoad(
                isRefresh: true,
                enterName: _editController.text,
                areaCode: areaCode,
                state: widget.state,
                enterType: widget.enterType,
                attentionLevel: widget.attentionLevel,
              ));
              return _refreshCompleter.future;
            },
            onLoad: () async {
              _enterListBloc.dispatch(EnterListLoad(
                enterName: _editController.text,
                areaCode: areaCode,
                state: widget.state,
                enterType: widget.enterType,
                attentionLevel: widget.attentionLevel,
              ));
              return _refreshCompleter.future;
            },
          ),
        ),
      ),
    );
  }
}
