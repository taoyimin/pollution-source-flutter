import 'dart:convert';

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
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';
import 'package:pollution_source/module/inspection/param/water/upload/water_device_param_upload_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

class WaterDeviceParamUploadPage extends StatefulWidget {
  final String json;

  WaterDeviceParamUploadPage({
    this.json,
  });

  @override
  _WaterDeviceParamUploadPageState createState() =>
      _WaterDeviceParamUploadPageState();
}

class _WaterDeviceParamUploadPageState
    extends State<WaterDeviceParamUploadPage> {
  PageBloc _pageBloc;

  /// 加载待巡检参数Bloc
  ListBloc _listBloc;
  UploadBloc _uploadBloc;
  RoutineInspectionUploadList task;

  @override
  void initState() {
    super.initState();
    task = RoutineInspectionUploadList.fromJson(json.decode(widget.json));
    // 初始化页面Bloc
    _pageBloc = BlocProvider.of<PageBloc>(context);
    // 加载界面
    _pageBloc.add(PageLoad(
        model: WaterDeviceParamUpload(
      inspectionTaskId: task.inspectionTaskId,
    )));
    _listBloc = BlocProvider.of<ListBloc>(context);
    // 加载待巡检参数
    _listBloc.add(ListLoad(isRefresh: true));
    // 初始化上报Bloc
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
  }

  @override
  void dispose() {
    // 释放资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          BlocBuilder<PageBloc, PageState>(
            builder: (context, state) {
              String enterName = '';
              String monitorName = '';
              String deviceName = '';
              String inspectionStartTime = '';
              String inspectionEndTime = '';
              if (state is PageLoaded) {
                enterName = task?.enterName ?? '';
                monitorName = task?.monitorName ?? '';
                deviceName = task?.deviceName ?? '';
                inspectionStartTime = task?.inspectionStartTime ?? '';
                inspectionEndTime = task?.inspectionEndTime ?? '';
              }
              return UploadHeaderWidget(
                title: '废水监测设备参数巡检',
                subTitle: '''$enterName
监控点名：$monitorName
设备名称：$deviceName
开始日期：$inspectionStartTime
截至日期：$inspectionEndTime''',
                imagePath:
                    'assets/images/long_stop_report_upload_header_image.png',
                backgroundColor: Colours.primary_color,
              );
            },
          ),
          MultiBlocListener(
            listeners: [
              BlocListener<UploadBloc, UploadState>(
                listener: uploadListener,
              ),
              BlocListener<UploadBloc, UploadState>(
                listener: (context, state) {
                  if (state is UploadSuccess) {
                    Toast.show('${state.message}');
                    Navigator.pop(context, true);
                  }
                },
              ),
              BlocListener<ListBloc, ListState>(
                listener: (context, state) {
                  final currentState = _pageBloc.state;
                  if (state is ListLoaded && currentState is PageLoaded) {
                    _pageBloc.add(PageLoad(
                        model: currentState.model
                            .copyWith(waterDeviceParamTypeList: state.list)));
                  }
                },
              ),
            ],
            child: BlocBuilder<PageBloc, PageState>(
              builder: (context, state) {
                if (state is PageLoaded) {
                  return _buildPageLoadedDetail(state.model);
                } else {
                  return ErrorSliver(
                      errorMessage: 'BlocBuilder监听到未知的的状态！state=$state');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(WaterDeviceParamUpload waterDeviceParamUpload) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          InfoRowWidget(title: '测量原理', content: task?.measurePrinciple ?? '无'),
          Gaps.hLine,
          InfoRowWidget(title: '分析方法', content: task?.analysisMethod ?? '无'),
          Gaps.hLine,
          BlocBuilder<ListBloc, ListState>(
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
                return Container(
                  height: 300,
                  child: ErrorMessageWidget(errorMessage: state.message),
                );
              } else if (state is ListLoaded) {
                return Column(
                  children: waterDeviceParamUpload?.waterDeviceParamTypeList
                          ?.asMap()
                          ?.map(
                              (i, WaterDeviceParamType waterDeviceParamType) =>
                                  MapEntry(
                                      i,
                                      _buildPageParamType(
                                        i,
                                        waterDeviceParamUpload
                                            .waterDeviceParamTypeList,
                                        waterDeviceParamUpload,
                                      )))
                          ?.values
                          ?.toList() ??
                      [],
                );
              } else {
                return Container(height: 300, child: ErrorMessageWidget(
                    errorMessage: 'BlocBuilder监听到未知的的状态！state=$state'),);
              }
            },
          ),
          Gaps.vGap10,
          Row(
            children: <Widget>[
              ClipButton(
                text: '提交',
                icon: Icons.file_upload,
                color: Colors.lightBlue,
                onTap: () {
                  _uploadBloc.add(Upload(
                    data: waterDeviceParamUpload,
                  ));
                },
              ),
            ],
          ),
          Gaps.vGap20,
        ],
      ),
    ));
  }

  Widget _buildPageParamType(int index, List<WaterDeviceParamType> list,
      WaterDeviceParamUpload waterDeviceParamUpload) {
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
                            EditRowWidget2(
                              hintText: '原始值',
                              flex: 2,
                              onChanged: (value) {
                                list[index].waterDeviceParamNameList[i] =
                                    list[index]
                                        .waterDeviceParamNameList[i]
                                        .copyWith(originalVal: value);
                                _pageBloc.add(PageLoad(
                                    model: waterDeviceParamUpload.copyWith(
                                        waterDeviceParamTypeList: list)));
                              },
                            ),
                            EditRowWidget2(
                              hintText: '修改值',
                              flex: 2,
                              onChanged: (value) {
                                list[index].waterDeviceParamNameList[i] =
                                    list[index]
                                        .waterDeviceParamNameList[i]
                                        .copyWith(updateVal: value);
                                _pageBloc.add(PageLoad(
                                    model: waterDeviceParamUpload.copyWith(
                                        waterDeviceParamTypeList: list)));
                              },
                            ),
                            EditRowWidget2(
                              hintText: '修改原因',
                              flex: 2,
                              onChanged: (value) {
                                list[index].waterDeviceParamNameList[i] =
                                    list[index]
                                        .waterDeviceParamNameList[i]
                                        .copyWith(modifyReason: value);
                                _pageBloc.add(PageLoad(
                                    model: waterDeviceParamUpload.copyWith(
                                        waterDeviceParamTypeList: list)));
                              },
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
