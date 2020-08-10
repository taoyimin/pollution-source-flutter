import 'dart:async';

import 'package:bdmap_location_flutter_plugin/flutter_baidu_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_repository.dart';
import 'package:pollution_source/module/inspection/inspect/upload/device_inspect_upload_model.dart';
import 'package:pollution_source/module/inspection/routine/detail/routine_inspection_detail_repository.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/widget/git_dialog.dart';

import 'device_inspection_upload_list_repository.dart';

/// 辅助/监测设备巡检上报列表
class DeviceInspectionUploadListPage extends StatefulWidget {
  final String monitorId;
  final String itemInspectType;
  final String state;

  DeviceInspectionUploadListPage({
    @required this.monitorId,
    @required this.itemInspectType,
    this.state,
  })  : assert(monitorId != null),
        assert(itemInspectType != null);

  @override
  _DeviceInspectionUploadListPageState createState() =>
      _DeviceInspectionUploadListPageState();
}

class _DeviceInspectionUploadListPageState
    extends State<DeviceInspectionUploadListPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  /// 刷新控制器
  final EasyRefreshController _refreshController = EasyRefreshController();

  /// 查询任务列表Bloc
  final ListBloc _listBloc = ListBloc(
    listRepository: RoutineInspectionUploadListRepository(),
  );

  /// 任务上报Bloc
  final UploadBloc _uploadBloc = UploadBloc(
    uploadRepository: DeviceInspectionUploadRepository(),
  );

  /// 辅助/监测设备巡检上报类
  final DeviceInspectUpload _deviceInspectUpload = DeviceInspectUpload();

  /// 用于刷新常规巡检详情（上报成功后刷新header中的数据条数）
  DetailBloc _detailBloc;

  /// 渐变动画控制器
  AnimationController _animateController;

  /// fab颜色渐变动画
  Animation _animation;

  /// BottomSheet控制器
  PersistentBottomSheetController _bottomSheetController;

  /// fab图标
  IconData _actionIcon = Icons.edit;

  /// 用于刷新BottomSheet
  StateSetter bottomSheetStateSetter;

  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    // 首次加载
    _listBloc.add(ListLoad(params: _getRequestParam()));
    // 初始化fab颜色渐变动画
    _animateController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = ColorTween(begin: Colors.lightBlue, end: Colors.redAccent)
        .animate(_animateController);
    _animateController.addListener(() {
      setState(() {});
    });
    _refreshCompleter = Completer<void>();
  }

  @override
  void dispose() {
    // 释放资源
    _refreshController.dispose();
    _deviceInspectUpload.remark.dispose();
    _animateController.dispose();
    // 取消正在进行的请求
    // 取消正在进行的请求
    if (_listBloc?.state is ListLoading)
      (_listBloc?.state as ListLoading).cancelToken.cancel();
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
      floatingActionButton: _buildFloatingActionButton(context),
      body: EasyRefresh.custom(
        controller: _refreshController,
        header: UIUtils.getRefreshClassicalHeader(),
        slivers: <Widget>[
          BlocListener<UploadBloc, UploadState>(
            bloc: _uploadBloc,
            listener: (context, state) {
              if (state is Uploading) {
                showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => GifDialog(
                    onCancelTap: () {
                      state.cancelToken.cancel('取消上传');
                    },
                  ),
                );
              } else if (state is UploadSuccess) {
                Toast.show('${state.message}');
                Application.router.pop(context);
                // 关闭BottomSheet
                _bottomSheetController?.close();
                // 清空上报界面
                _deviceInspectUpload.selectedList.clear();
                _deviceInspectUpload.isNormal = true;
                _deviceInspectUpload.remark.text = '';
                // 刷新列表页面
                _listBloc.add(ListLoad(
                    isRefresh: true,
                    params: RoutineInspectionUploadListRepository.createParams(
                      monitorId: widget.monitorId,
                      itemInspectType: widget.itemInspectType,
                      state: widget.state,
                    )));
                // 刷新常规巡检详情界面header中的任务条数
                _detailBloc.add(DetailLoad(
                  params: RoutineInspectionDetailRepository.createParams(
                    monitorId: widget.monitorId,
                    state: widget.state,
                  ),
                ));
              } else if (state is UploadFail) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('${state.message}'),
                    action: SnackBarAction(
                        label: '我知道了',
                        textColor: Colours.primary_color,
                        onPressed: () {}),
                  ),
                );
                Application.router.pop(context);
              }
            },
            child: BlocConsumer<ListBloc, ListState>(
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
              onTap: () {
                setState(() {
                  if (_deviceInspectUpload.selectedList.contains(list[index])) {
                    // 如果已选中则移除
                    _deviceInspectUpload.selectedList.remove(list[index]);
                  } else {
                    // 如果未选中则添加
                    _deviceInspectUpload.selectedList.add(list[index]);
                  }
                });
                // 刷新BottomSheet中的选中数
                if (bottomSheetStateSetter != null)
                  bottomSheetStateSetter(() {});
              },
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      UIUtils.getBoxShadow(),
                    ],
                  ),
                  child: _buildListItem(list[index], widget.itemInspectType),
                ),
              ],
            ),
          );
        },
        childCount: list.length,
      ),
    );
  }

  Widget _buildListItem(RoutineInspectionUploadList routineInspectionUploadList,
      String itemInspectType) {
    if (itemInspectType == "1") {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${routineInspectionUploadList.itemName}：${routineInspectionUploadList.contentName}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Gaps.vGap6,
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ListTileWidget(
                          '开始日期：${routineInspectionUploadList.inspectionStartTime}'),
                    ),
                    ListTileWidget(
                        '截至日期：${routineInspectionUploadList.inspectionEndTime}'),
                  ],
                ),
              ],
            ),
          ),
          Checkbox(
            value: _deviceInspectUpload.selectedList
                .contains(routineInspectionUploadList),
            onChanged: (value) {},
          ),
        ],
      );
    } else if (itemInspectType == "5") {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${routineInspectionUploadList.itemName}：${routineInspectionUploadList.contentName}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Checkbox(
                value: _deviceInspectUpload.selectedList
                    .contains(routineInspectionUploadList),
                onChanged: (value) {},
              ),
            ],
          ),
          Gaps.vGap6,
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ListTileWidget(
                  '监测设备：${routineInspectionUploadList.deviceName}',
                ),
              ),
              ListTileWidget(
                '开始日期：${routineInspectionUploadList.inspectionStartTime}',
              ),
              Gaps.hGap16,
            ],
          ),
          Gaps.vGap6,
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ListTileWidget(
                  '监测因子：${routineInspectionUploadList.factorName}',
                ),
              ),
              ListTileWidget(
                '截至日期：${routineInspectionUploadList.inspectionEndTime}',
              ),
              Gaps.hGap16,
            ],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '位置的任务类型！itemInspectType=$itemInspectType',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Builder(builder: (context) {
      return FloatingActionButton(
        heroTag: '${widget.itemInspectType}',
        child: AnimatedSwitcher(
          transitionBuilder: (child, anim) {
            return ScaleTransition(child: child, scale: anim);
          },
          duration: Duration(milliseconds: 300),
          child: Icon(
            _actionIcon,
            key: ValueKey(_actionIcon),
            color: Colors.white,
          ),
        ),
        backgroundColor: _animation.value,
        onPressed: () {
          if (_bottomSheetController != null) {
            // 已经处于打开状态
            _bottomSheetController.close();
            return;
          }
          if (_deviceInspectUpload.selectedList.length == 0) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: const Text('请至少选择一项任务进行处理'),
                action: SnackBarAction(
                    label: '我知道了',
                    textColor: Colours.primary_color,
                    onPressed: () {}),
              ),
            );
            return;
          }
          // fab由蓝变红
          _animateController.forward();
          setState(() {
            _actionIcon = Icons.close;
          });
          // 打开BottomSheet
          _bottomSheetController = showBottomSheet(
            context: context,
            elevation: 20,
            backgroundColor: Colors.white,
            builder: (BuildContext context) {
              // 生成流程上报界面
              return _buildBottomSheet();
            },
          );
          // 监听BottomSheet关闭
          _bottomSheetController.closed.then((value) {
            // fab由红变蓝
            _animateController.reverse();
            setState(() {
              _bottomSheetController = null;
              _actionIcon = Icons.edit;
            });
          });
        },
      );
    });
  }

  Widget _buildBottomSheet() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        bottomSheetStateSetter = setState;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ImageTitleWidget(
                  title:
                      '巡检上报(已选中${_deviceInspectUpload.selectedList.length}项)',
                  imagePath: 'assets/images/icon_alarm_manage.png',
                ),
                Gaps.vGap16,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Gaps.hGap16,
                    Image.asset(
                      'assets/images/icon_location.png',
                      height: 20,
                      width: 20,
                    ),
                    Gaps.hGap10,
                    Expanded(
                      flex: 8,
                      child: LocationWidget(
                        locationCallback: (BaiduLocation baiduLocation) {
                          setState(() {
                            _deviceInspectUpload.baiduLocation = baiduLocation;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Gaps.hGap16,
                    Image.asset(
                      'assets/images/icon_fixed.png',
                      height: 20,
                      width: 20,
                    ),
                    Gaps.hGap10,
                    const Text('维护情况'),
                    Gaps.hGap20,
                    IconCheckButton(
                      text: '    正常',
                      imagePath: 'assets/images/icon_normal.png',
                      imageHeight: 28,
                      imageWidth: 28,
                      color: Colors.lightBlueAccent,
                      flex: 3,
                      checked: _deviceInspectUpload.isNormal,
                      onTap: () {
                        setState(() {
                          _deviceInspectUpload.isNormal = true;
                        });
                      },
                    ),
                    Gaps.hGap6,
                    IconCheckButton(
                      text: '    不正常',
                      imagePath: 'assets/images/icon_abnormal.png',
                      imageHeight: 28,
                      imageWidth: 28,
                      color: Colors.orangeAccent,
                      flex: 3,
                      checked: !_deviceInspectUpload.isNormal,
                      onTap: () {
                        setState(() {
                          _deviceInspectUpload.isNormal = false;
                        });
                      },
                    ),
                  ],
                ),
                Gaps.vGap10,
                DecoratedBox(
                  decoration: const BoxDecoration(color: Color(0xFFDFDFDF)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 12),
                        child: Image.asset(
                          'assets/images/icon_alarm_manage.png',
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          maxLines: 3,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          controller: _deviceInspectUpload.remark,
                          decoration: const InputDecoration(
                            fillColor: Color(0xFFDFDFDF),
                            filled: true,
                            hintText: "请输入备注",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colours.secondary_text,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    ClipButton(
                      text: '提交',
                      icon: Icons.file_upload,
                      color: Colors.lightBlue,
                      onTap: () {
                        // 发送上传事件
                        _uploadBloc.add(Upload(data: _deviceInspectUpload));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
