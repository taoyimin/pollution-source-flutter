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
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/ui_utils.dart';

/// 废水监测设备参数巡检上报列表界面
class WaterDeviceParamUploadListPage extends StatefulWidget {
  final String monitorId;
  final String itemInspectType;
  final String state;

  WaterDeviceParamUploadListPage({
    @required this.monitorId,
    @required this.itemInspectType,
    this.state,
  })  : assert(monitorId != null),
        assert(itemInspectType != null);

  @override
  _WaterDeviceParamUploadListPageState createState() =>
      _WaterDeviceParamUploadListPageState();
}

class _WaterDeviceParamUploadListPageState
    extends State<WaterDeviceParamUploadListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  ListBloc _listBloc;

  /// 用于刷新常规巡检详情（上报成功后刷新header中的数据条数）
  DetailBloc _detailBloc;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    _listBloc = BlocProvider.of<ListBloc>(context);
    //首次加载
    _listBloc.add(ListLoad(
        params: RoutineInspectionUploadListRepository.createParams(
      monitorId: widget.monitorId,
      itemInspectType: widget.itemInspectType,
      state: widget.state,
    )));
    _refreshCompleter = Completer<void>();
  }

  @override
  void dispose() {
    //释放资源
    //取消正在进行的请求
    final currentState = _listBloc?.state;
    if (currentState is ListLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: EasyRefresh.custom(
        header: UIUtils.getRefreshClassicalHeader(),
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
                  return EmptySliver(message: '没有任务需要处理');
                } else if (state is ListError) {
                  return ErrorSliver(errorMessage: state.message);
                } else if (state is ListLoaded) {
                  return _buildPageLoadedList(
                      RoutineInspectionUploadList.convert(state.list));
                } else {
                  return ErrorSliver(
                      errorMessage: 'BlocBuilder监听到未知的的状态！state=$state');
                }
              },
            ),
          ),
        ],
        onRefresh: () async {
          _listBloc.add(ListLoad(
              isRefresh: true,
              params: RoutineInspectionUploadListRepository.createParams(
                monitorId: widget.monitorId,
                itemInspectType: widget.itemInspectType,
                state: widget.state,
              )));
          return _refreshCompleter.future;
        },
      ),
    );
  }

  Widget _buildPageLoadedList(List<RoutineInspectionUploadList> list) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () async {
                bool success = await Application.router.navigateTo(context,
                    '${Routes.waterDeviceParamUpload}?json=${Uri.encodeComponent(json.encode(list[index].toJson()))}');
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
                    params: RoutineInspectionUploadListRepository.createParams(
                      monitorId: widget.monitorId,
                      itemInspectType: widget.itemInspectType,
                      state: widget.state,
                    ),
                  ));
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
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                '${list[index].deviceName}',
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
                                      '开始日期：${list[index].inspectionStartTime}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ListTileWidget(
                                      '截至日期：${list[index].inspectionEndTime}'),
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
