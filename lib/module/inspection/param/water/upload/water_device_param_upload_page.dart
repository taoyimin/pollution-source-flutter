import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';
import 'package:pollution_source/module/inspection/common/water_device_param_list_repository.dart';
import 'package:pollution_source/module/inspection/param/water/upload/water_device_param_upload_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'water_device_param_upload_repository.dart';

/// 废水监测设备参数巡检上报界面
class WaterDeviceParamUploadPage extends StatefulWidget {
  final String taskJson;

  WaterDeviceParamUploadPage({this.taskJson});

  @override
  _WaterDeviceParamUploadPageState createState() =>
      _WaterDeviceParamUploadPageState(
          task: RoutineInspectionUploadList.fromJson(json.decode(taskJson)));
}

class _WaterDeviceParamUploadPageState
    extends State<WaterDeviceParamUploadPage> {
  /// 巡检任务
  final RoutineInspectionUploadList task;

  /// 加载待巡检参数Bloc
  final ListBloc _listBloc = ListBloc(
    listRepository: WaterDeviceParamListRepository(),
  );

  /// 废水监测设备参数巡检上报Bloc
  final UploadBloc _uploadBloc = UploadBloc(
    uploadRepository: WaterDeviceParamUploadRepository(),
  );

  /// 废水监测设备参数巡检上报类
  final WaterDeviceParamUpload _waterDeviceParamUpload =
      WaterDeviceParamUpload();

  _WaterDeviceParamUploadPageState({this.task});

  @override
  void initState() {
    super.initState();
    _waterDeviceParamUpload.inspectionTaskId = task.inspectionTaskId;
    // 加载待巡检参数
    _loadData();
  }

  @override
  void dispose() {
    // 释放资源
    super.dispose();
    _waterDeviceParamUpload.waterDeviceParamTypeList
        .forEach((WaterDeviceParamType waterDeviceParamType) {
      waterDeviceParamType.waterDeviceParamNameList
          .forEach((WaterDeviceParamName waterDeviceParamName) {
        waterDeviceParamName.originalVal.dispose();
        waterDeviceParamName.updateVal.dispose();
        waterDeviceParamName.modifyReason.dispose();
      });
    });
    // 取消正在进行的请求
    if (_listBloc?.state is ListLoading)
      (_listBloc?.state as ListLoading).cancelToken.cancel();
  }

  /// 加载数据
  _loadData() {
    _listBloc.add(ListLoad(isRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          UploadHeaderWidget(
            title: '废水监测设备参数巡检',
            subTitle: '''${task.enterName}
监控点名：${task.monitorName}
设备名称：${task.deviceName}
开始日期：${task.inspectionStartTime}
截至日期：${task.inspectionEndTime}''',
            imagePath: 'assets/images/discharge_report_upload_header_image.png',
            backgroundColor: Colours.primary_color,
          ),
          MultiBlocListener(
            listeners: [
              BlocListener<UploadBloc, UploadState>(
                bloc: _uploadBloc,
                listener: uploadListener,
              ),
              BlocListener<UploadBloc, UploadState>(
                bloc: _uploadBloc,
                listener: (context, state) {
                  if (state is UploadSuccess) {
                    Toast.show('${state.message}');
                    Navigator.pop(context, true);
                  }
                },
              ),
              BlocListener<ListBloc, ListState>(
                bloc: _listBloc,
                listener: (context, state) {
                  if (state is ListLoaded) {
                    _waterDeviceParamUpload.waterDeviceParamTypeList =
                        state.list;
                  }
                },
              ),
            ],
            child: _buildPageLoadedDetail(),
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          InfoRowWidget(title: '测量原理', content: task.measurePrinciple ?? '无'),
          Gaps.hLine,
          InfoRowWidget(title: '分析方法', content: task.analysisMethod ?? '无'),
          Gaps.hLine,
          BlocBuilder<ListBloc, ListState>(
            bloc: _listBloc,
            builder: (context, state) {
              if (state is ListInitial || state is ListLoading) {
                return Container(height: 300, child: LoadingWidget());
              } else if (state is ListEmpty) {
                return Container(
                  height: 300,
                  child: EmptyWidget(
                    message: '没有查询到设备的参数巡检项目',
                  ),
                );
              } else if (state is ListError) {
                return ColumnErrorWidget(
                  errorMessage: state.message,
                  onReloadTap: () => _loadData(),
                );
              } else if (state is ListLoaded) {
                return Column(
                  children: <Widget>[
                    ...(_waterDeviceParamUpload.waterDeviceParamTypeList
                            ?.asMap()
                            ?.map((i,
                                    WaterDeviceParamType
                                        waterDeviceParamType) =>
                                MapEntry(i, _buildPageParamType(i)))
                            ?.values
                            ?.toList() ??
                        []),
                    Gaps.vGap10,
                    Row(
                      children: <Widget>[
                        ClipButton(
                          text: '提交',
                          icon: Icons.file_upload,
                          color: Colors.lightBlue,
                          onTap: () {
                            _uploadBloc
                                .add(Upload(data: _waterDeviceParamUpload));
                          },
                        ),
                      ],
                    ),
                    Gaps.vGap20,
                  ],
                );
              } else {
                return ColumnErrorWidget(
                  errorMessage: 'BlocBuilder监听到未知的的状态！state=$state',
                  onReloadTap: () => _loadData(),
                );
              }
            },
          ),
        ],
      ),
    ));
  }

  Widget _buildPageParamType(int index) {
    List<WaterDeviceParamType> list =
        _waterDeviceParamUpload.waterDeviceParamTypeList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              height: 46,
              child: Center(
                child: Text(
                  '${list[index].parameterType}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        Gaps.hLine,
        ...list[index]
                .waterDeviceParamNameList
                ?.asMap()
                ?.map(
                  (i, WaterDeviceParamName waterDeviceParamName) => MapEntry(
                    i,
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Text(waterDeviceParamName.parameterName),
                            ),
                            EditWidget(
                              controller: waterDeviceParamName.originalVal,
                              hintText: '原始值',
                              flex: 2,
                            ),
                            EditWidget(
                              controller: waterDeviceParamName.updateVal,
                              hintText: '修改值',
                              flex: 2,
                            ),
                            EditWidget(
                              controller: waterDeviceParamName.modifyReason,
                              hintText: '修改原因',
                              flex: 2,
                            ),
                          ],
                        ),
                        Gaps.hLine,
                      ],
                    ),
                  ),
                )
                ?.values
                ?.toList() ??
            [],
      ],
    );
  }
}
