import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/page/enter_detail.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/dimens.dart';
import 'package:pollution_source/util/ui_util.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/widget/label.dart';
import 'package:pollution_source/widget/search.dart';
import 'package:pollution_source/widget/sliver_appbar.dart';

import 'enter_list.dart';

class EnterListPage extends StatefulWidget {
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

  String areaCode='';

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    _refreshCompleter = Completer<void>();
    _enterListBloc = BlocProvider.of<EnterListBloc>(context);
    _enterListBloc.dispatch(EnterListLoad());
    _scrollController = ScrollController();
    _editController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
    _editController.dispose();
  }

  //根据企业标签model获取企业标签widget
  List<Widget> _getEnterLabelWidgetList(List<EnterLabel> alarmTypeList) {
    return alarmTypeList.map((alarmType) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: alarmType.color.withOpacity(0.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              alarmType.imagePath,
              width: 8,
              height: 8,
              color: alarmType.color,
            ),
            Text(
              alarmType.name,
              style: TextStyle(color: alarmType.color, fontSize: 10),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _getPageLoadedWidget(List<Enter> enterList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimens.gap_dp8, vertical: Dimens.gap_dp5),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(Dimens.gap_dp12),
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
                        padding: EdgeInsets.all(3),
                        child: Image.asset(
                          enterList[index].imagePath,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Text(
                                enterList[index].name,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(height: 6,),
                            Wrap(
                              spacing: 6,
                              runSpacing: 3,
                              children: _getEnterLabelWidgetList(enterList[index].enterLabelList),
                            ),
                            SizedBox(height: 6,),
                            Text(
                              "地址：${enterList[index].address}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colours.secondary_text,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 6,),
                            Text(
                              "行业类别：${enterList[index].industryType}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colours.secondary_text,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Offstage(
                  offstage: !enterList[index].isImportant,
                  child: LabelView(
                    Size.fromHeight(100),
                    labelText: "重点",
                    labelColor: Theme.of(context).primaryColor,
                    labelAlignment: LabelAlignment.rightTop,
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
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
                    ),
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
            ListSliverAppbarWidget(
              title: '企业列表',
              subtitle: '展示污染源企业列表，点击列表项查看该企业的详细信息',
              background: 'assets/images/button_bg_lightblue.png',
              image: 'assets/images/enter_list_bg_image.png',
              color: Colors.blue,
              showSearch: true,
              editController: _editController,
              scrollController: _scrollController,
              onSearchPressed: () => _refreshController.callRefresh(),
              areaPickerListener: (areaId){
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
                      return getPageLoadingWidget(context);
                    } else if (state is EnterListEmpty) {
                      return getPageEmptyWidget();
                    } else if (state is EnterListError) {
                      return getPageErrorWidget(state.errorMessage);
                    } else if (state is EnterListLoaded) {
                      if (!state.hasNextPage)
                        _refreshController.finishLoad(
                            noMore: !state.hasNextPage, success: true);
                      return _getPageLoadedWidget(state.enterList);
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
              ));
              return _refreshCompleter.future;
            },
            onLoad: () async {
              _enterListBloc.dispatch(EnterListLoad(
                enterName: _editController.text,
              ));
              return _refreshCompleter.future;
            },
          ),
        ),
      ),
    );
  }
}
