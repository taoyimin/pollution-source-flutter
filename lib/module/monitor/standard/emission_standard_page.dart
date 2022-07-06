import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
as extended;
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/common/list/list_widget.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/module/common/common_widget.dart';

import 'emission_standard_model.dart';
import 'emission_standard_repository.dart';

/// 排放标准列表界面
class EmissionStandardPage extends StatefulWidget {
  final String monitorId;
  final String enterName;
  final String monitorName;

  EmissionStandardPage({this.monitorId, this.enterName, this.monitorName});

  @override
  _EmissionStandardPageState createState() => _EmissionStandardPageState();
}

class _EmissionStandardPageState extends State<EmissionStandardPage> {
  /// 全局Key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 刷新控制器
  final EasyRefreshController _refreshController = EasyRefreshController();

  Completer<void> _refreshCompleter;

  /// 列表Bloc
  final ListBloc _listBloc =
  ListBloc(listRepository: EmissionStandardRepository());

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    // 首次加载
    _listBloc.add(ListLoad(isRefresh: true, params: _getRequestParam()));
  }

  @override
  void dispose() {
    // 释放资源
    _refreshController.dispose();
    // 取消正在进行的请求
    if (_listBloc?.state is ListLoading)
      (_listBloc?.state as ListLoading).cancelToken.cancel();
    super.dispose();
  }

  /// 获取请求参数
  Map<String, dynamic> _getRequestParam() {
    return EmissionStandardRepository.createParams(
      monitorId: widget.monitorId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: extended.NestedScrollView(
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + kToolbarHeight;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            ListHeaderWidget(
              listBloc: _listBloc,
              title: '排放标准',
              subtitle: '企业名称:${widget.enterName}\n监控点名:${widget.monitorName}',
              background: 'assets/images/button_bg_green.png',
              image: 'assets/images/discharge_list_bg_image.png',
              color: Colours.background_green,
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
                bloc: _listBloc,
                listener: (context, state) {
                  // 刷新状态不触发_refreshCompleter
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
              _refreshController.resetLoadState();
              _listBloc.add(ListLoad(
                isRefresh: true,
                params: _getRequestParam(),
              ));
              return _refreshCompleter.future;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageLoadedList(List<EmissionStandard> emissionStandardList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // 创建列表项
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return MapInfoPage(
                //         title: '排放标准详情',
                //         mapInfo: emissionStandardList[index].getMapInfo(),
                //       );
                //     },
                //   ),
                // );
              },
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      UIUtils.getBoxShadow(),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${emissionStandardList[index].factorName}【${emissionStandardList[index].disStandardName}】',
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
                                '报警下限:${emissionStandardList[index].alarmLower}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '报警上限:${emissionStandardList[index].alarmUpper}'),
                          ),
                        ],
                      ),
                      Gaps.vGap6,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '超标下限:${emissionStandardList[index].overproofLower}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '超标上限:${emissionStandardList[index].overproofUpper}'),
                          ),
                        ],
                      ),
                      Gaps.vGap6,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '最小量程:${emissionStandardList[index].rangeLower}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '最大量程:${emissionStandardList[index].rangeUpper}'),
                          ),
                        ],
                      ),
                      Gaps.vGap6,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '测量量程下限:${emissionStandardList[index].measureLower}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '测量量程上限:${emissionStandardList[index].measureUpper}'),
                          ),
                        ],
                      ),
                      Gaps.vGap6,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '告警比较值:${emissionStandardList[index].compareTypeStr}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '适应数据类型:${emissionStandardList[index].dataTypeStr}'),
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
        childCount: emissionStandardList.length,
      ),
    );
  }
}
