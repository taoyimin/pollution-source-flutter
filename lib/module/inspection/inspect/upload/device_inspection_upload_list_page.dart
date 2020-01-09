import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
import 'package:pollution_source/module/common/page/page_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_repository.dart';
import 'package:pollution_source/module/process/upload/process_upload_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';

class DeviceInspectionUploadListPage extends StatefulWidget {
  final String monitorId;
  final String itemInspectType;

  DeviceInspectionUploadListPage(
      {@required this.monitorId, @required this.itemInspectType})
      : assert(monitorId != null),
        assert(itemInspectType != null);

  @override
  _DeviceInspectionUploadListPageState createState() =>
      _DeviceInspectionUploadListPageState();
}

class _DeviceInspectionUploadListPageState
    extends State<DeviceInspectionUploadListPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  ListBloc _listBloc;
  PageBloc _pageBloc;
  UploadBloc _uploadBloc;
  Completer<void> _refreshCompleter;
  TextEditingController _remarkController;
  AnimationController controller;
  Animation animation;
  PersistentBottomSheetController _bottomSheetController;
  IconData _actionIcon = Icons.add;

  @override
  void initState() {
    super.initState();
    _listBloc = BlocProvider.of<ListBloc>(context);
    //首次加载
    _listBloc.add(ListLoad(
        params: RoutineInspectionUploadListRepository.createParams(
      monitorId: widget.monitorId,
      itemInspectType: widget.itemInspectType,
    )));
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
    _pageBloc = PageBloc();
    //首次加载
    _pageBloc.add(PageLoad(model: ProcessUpload()));
    //初始化编辑框控制器
    _remarkController = TextEditingController();
    //初始化fab颜色渐变动画
    controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.lightBlue, end: Colors.redAccent)
        .animate(controller);
    controller.addListener(() {
      setState(() {});
    });
    _refreshCompleter = Completer<void>();
  }

  @override
  void dispose() {
    //释放资源
    _remarkController.dispose();
    controller.dispose();
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
      floatingActionButton: _buildFloatingActionButton(),
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
                  return _buildPageLoadedList(convert(state.list));
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
              )));
          return _refreshCompleter.future;
        },
      ),
    );
  }

  List<RoutineInspectionUploadList> convert(
      List<RoutineInspectionUploadList> list) {
    return list.expand((item) {
      List<RoutineInspectionUploadList> tempList = [];
      List<String> inspectionTaskIds = item.inspectionTaskId.split(',');
      List<String> contentNames = item.contentName.split(',');
      List<String> inspectionStartTimes = item.inspectionStartTime.split(',');
      List<String> inspectionEndTimes = item.inspectionEndTime.split(',');
      for (int i = 0; i < inspectionTaskIds.length; i++) {
        tempList.add(RoutineInspectionUploadList(
          itemName: item.itemName,
          inspectionTaskId: inspectionTaskIds[i],
          contentName: contentNames[i],
          inspectionStartTime: inspectionStartTimes[i],
          inspectionEndTime: inspectionEndTimes[i],
        ));
      }
      return tempList;
    }).toList();
  }

  Widget _buildPageLoadedList(List<RoutineInspectionUploadList> list) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
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
//                      Container(
//                        padding: const EdgeInsets.all(3),
//                        child: Image.asset(
//                          '',
//                          width: 40,
//                          height: 40,
//                        ),
//                      ),
//                      Gaps.hGap10,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                '${list[index].itemName}：${list[index].contentName}',
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
                      )
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

  Widget _buildFloatingActionButton() {
    return Builder(builder: (context) {
      return FloatingActionButton(
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
        backgroundColor: animation.value,
        onPressed: () {
          if (_bottomSheetController != null) {
            //已经处于打开状态
            _bottomSheetController.close();
            return;
          }
          //fab由蓝变红
          controller.forward();
          setState(() {
            _actionIcon = Icons.close;
          });
          //打开BottomSheet
          _bottomSheetController = showBottomSheet(
            context: context,
            elevation: 20,
            backgroundColor: Colors.white,
            builder: (BuildContext context) {
              //生成流程上报界面
              return BlocBuilder<PageBloc, PageState>(
                bloc: _pageBloc,
                builder: (context, state) {
                  if (state is PageLoaded) {
                    return _buildBottomSheet();
                  } else {
                    return MessageWidget(
                        message: 'BlocBuilder监听到未知的的状态！state=$state');
                  }
                },
              );
            },
          );
          //监听BottomSheet关闭
          _bottomSheetController.closed.then((value) {
            //fab由红变蓝
            controller.reverse();
            setState(() {
              _bottomSheetController = null;
              _actionIcon = Icons.add;
            });
          });
        },
      );
    });
  }

  Widget _buildBottomSheet() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Gaps.vGap20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ImageTitleWidget(
              title: '巡检上报',
              imagePath: 'assets/images/icon_alarm_manage.png',
            ),
          ),
          Gaps.vGap16,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _remarkController,
                    decoration: const InputDecoration(
                      fillColor: Color(0xFFDFDFDF),
                      filled: true,
                      hintText: "请输入备注",
                      hintStyle: TextStyle(
                        color: Colours.secondary_text,
                      ),
                      prefixIcon: Icon(Icons.person),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gaps.vGap10,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _remarkController,
                    decoration: const InputDecoration(
                      fillColor: Color(0xFFDFDFDF),
                      filled: true,
                      hintText: "请输入操作描述",
                      hintStyle: TextStyle(
                        color: Colours.secondary_text,
                      ),
                      prefixIcon: Icon(Icons.event_note),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gaps.vGap10,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                ClipButton(
                  text: '提交',
                  icon: Icons.file_upload,
                  color: Colors.lightBlue,
                  onTap: () {
                    //发送上传事件
                    _uploadBloc.add(Upload(data: ProcessUpload()));
                  },
                ),
              ],
            ),
          ),
          Gaps.vGap20,
        ],
      ),
    );
  }
}
