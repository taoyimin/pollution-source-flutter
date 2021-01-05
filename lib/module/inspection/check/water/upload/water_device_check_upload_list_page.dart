import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_repository.dart';
import 'package:pollution_source/module/inspection/routine/detail/routine_inspection_detail_repository.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/ui_utils.dart';

/// 废水监测设备校验上报列表
class WaterDeviceCheckUploadListPage extends StatefulWidget {
  final String monitorId;
  final String itemInspectType;
  final String state;

  WaterDeviceCheckUploadListPage({
    @required this.monitorId,
    @required this.itemInspectType,
    this.state,
  })  : assert(monitorId != null),
        assert(itemInspectType != null);

  @override
  _WaterDeviceCheckUploadListPageState createState() =>
      _WaterDeviceCheckUploadListPageState();
}

class _WaterDeviceCheckUploadListPageState
    extends State<WaterDeviceCheckUploadListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// 刷新控制器
  final EasyRefreshController _refreshController = EasyRefreshController();

  /// 任务列表Bloc
  final ListBloc _listBloc = ListBloc(
    listRepository: RoutineInspectionUploadListRepository(),
  );

  /// 常规巡检详情Bloc，用于上报成功后刷新header中的数据条数
  DetailBloc _detailBloc;

  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    // 首次加载
    _listBloc.add(ListLoad(params: _getRequestParam()));
  }

  @override
  void dispose() {
    // 释放资源
    _refreshController.dispose();
    // 取消正在进行的请求
    final currentState = _listBloc?.state;
    if (currentState is ListLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  /// 获取请求参数
  Map<String, dynamic> _getRequestParam() {
    return RoutineInspectionUploadListRepository.createParams(
      monitorId: widget.monitorId,
      itemInspectType: widget.itemInspectType,
      state: widget.state,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: EasyRefresh.custom(
        controller: _refreshController,
        header: UIUtils.getRefreshClassicalHeader(),
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
                return EmptySliver(message: '没有任务需要处理');
              } else if (state is ListError) {
                return ErrorSliver(
                  errorMessage: state.message,
                  onReloadTap: () => _refreshController.callRefresh(),
                );
              } else if (state is ListLoaded) {
                return _buildPageLoadedList(
                    RoutineInspectionUploadList.convert(state.list));
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
          _listBloc.add(ListLoad(isRefresh: true, params: _getRequestParam()));
          return _refreshCompleter.future;
        },
      ),
    );
  }

  Widget _buildPageLoadedList(List<RoutineInspectionUploadList> list) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () async {
                if (widget.state == '1') {
                  bool success = await Application.router.navigateTo(context,
                      '${Routes.waterDeviceCheckUpload}?json=${Uri.encodeComponent(json.encode(list[index].toJson()))}');
                  if (success ?? false) {
                    // 刷新常规巡检详情界面header中的任务条数
                    _detailBloc.add(DetailLoad(
                      params: RoutineInspectionDetailRepository.createParams(
                        monitorId: widget.monitorId,
                        state: widget.state,
                      ),
                    ));
                    // 刷新列表页面
                    _listBloc.add(ListLoad(
                      isRefresh: true,
                      params:
                      RoutineInspectionUploadListRepository.createParams(
                        monitorId: widget.monitorId,
                        itemInspectType: widget.itemInspectType,
                        state: widget.state,
                      ),
                    ));
                  }
                } else {
                  // 未巡检和已巡检的任务暂不支持查看详情
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('暂不支持查看详情'),
                      action: SnackBarAction(
                          label: '我知道了',
                          textColor: Colours.primary_color,
                          onPressed: () {}),
                    ),
                  );
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${list[index].deviceName}',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Gaps.vGap6,
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 6,
                                  child: ListTileWidget(
                                    '监控点名：${list[index].monitorName}',
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: ListTileWidget(
                                    '开始日期：${list[index].inspectionStartTime}',
                                  ),
                                ),
                              ],
                            ),
                            Gaps.vGap6,
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 6,
                                  child: ListTileWidget(
                                    '监测因子：${list[index].factorName}',
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: ListTileWidget(
                                    '截至日期：${list[index].inspectionEndTime}',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: list.length,
      ),
    );
  }
}
