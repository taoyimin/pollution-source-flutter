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
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/module/common/common_widget.dart';

import 'device_list_model.dart';
import 'device_list_repository.dart';

/// 设备列表
class DeviceListPage extends StatefulWidget {
  final String monitorId;
  final int type; //启用页面的类型 0：点击列表项查看详情（暂无详情页） 1：点击列表项返回上一层与设备信息

  DeviceListPage({
    this.monitorId = '',
    this.type = 1,
  });

  @override
  _DeviceListPageState createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  /// 全局Key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 刷新控制器
  final EasyRefreshController _refreshController = EasyRefreshController();

  /// 列表Bloc
  final ListBloc _listBloc = ListBloc(
    listRepository: DeviceListRepository(),
  );

  Completer<void> _refreshCompleter;

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
    return DeviceListRepository.createParams(
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
              title: '设备列表',
              subtitle: '展示污染源监控设备列表，点击列表项查看该设备的详细信息',
              background: 'assets/images/button_bg_yellow.png',
              image: 'assets/images/discharge_list_bg_image.png',
              color: Colours.background_yellow,
            )
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

  Widget _buildPageLoadedList(List<Device> deviceList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
                switch (widget.type) {
                  case 0:
                    Toast.show('暂无设备详情界面');
//                    Application.router.navigateTo(context,
//                        '${Routes.deviceDetail}/${deviceList[index].deviceId}');
                    break;
                  case 1:
                    Navigator.pop(context, deviceList[index]);
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
                          'assets/images/icon_unknown_monitor.png',
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
                                '${deviceList[index].deviceName}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Gaps.vGap6,
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: ListTileWidget(
                                      '设备编号：${deviceList[index].deviceNo}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ListTileWidget(
                                      '设备类型：${deviceList[index].deviceTypeName}'),
                                ),
                              ],
                            ),
                            Gaps.vGap6,
                            ListTileWidget(
                                '制造商：${deviceList[index].markerName}'),
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
        childCount: deviceList.length,
      ),
    );
  }
}
