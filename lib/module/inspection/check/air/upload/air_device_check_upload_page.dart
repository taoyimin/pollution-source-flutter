import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
import 'package:pollution_source/module/common/page/page_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/inspection/check/air/upload/air_device_check_upload_model.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

class AirDeviceCheckUploadPage extends StatefulWidget {
  final String json;

  AirDeviceCheckUploadPage({
    this.json,
  });

  @override
  _AirDeviceCheckUploadPageState createState() =>
      _AirDeviceCheckUploadPageState();
}

class _AirDeviceCheckUploadPageState extends State<AirDeviceCheckUploadPage> {
  PageBloc _pageBloc;
  UploadBloc _uploadBloc;
  TextEditingController _remarkController;
  RoutineInspectionUploadList task;

  @override
  void initState() {
    super.initState();
    task = RoutineInspectionUploadList.fromJson(json.decode(widget.json));
    // 初始化页面Bloc
    _pageBloc = BlocProvider.of<PageBloc>(context);
    // 加载界面(默认有一条记录)
    _pageBloc.add(PageLoad(
        model: AirDeviceCheckUpload(
      inspectionTaskId: task.inspectionTaskId,
      itemType: task.itemType,
      factorCode: task.factorCode,
      airDeviceCheckRecordList: [
        AirDeviceCheckRecord(),
        AirDeviceCheckRecord(),
        AirDeviceCheckRecord(),
        AirDeviceCheckRecord(),
        AirDeviceCheckRecord(),
      ],
    )));
    // 初始化上报Bloc
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
    _remarkController = TextEditingController();
  }

  @override
  void dispose() {
    // 释放资源
    _remarkController.dispose();
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
                title: '废水监测设备校验上报',
                subTitle: '''企业名称：$enterName
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
                    Toast.show(state.message);
                    Navigator.pop(context, true);
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

  Widget _buildPageLoadedDetail(AirDeviceCheckUpload airDeviceCheckUpload) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Text('监测时间'),
                Text('监测时间1'),
                Text('监测时间2'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: airDeviceCheckUpload?.airDeviceCheckRecordList
                      ?.asMap()
                      ?.map((i, AirDeviceCheckRecord airDeviceCheckRecord) =>
                          MapEntry(
                              i,
                              _buildPageListItem(
                                  airDeviceCheckUpload
                                      ?.airDeviceCheckRecordList,
                                  i)))
                      ?.values
                      ?.toList() ??
                  [],
            ),
          ),
          Gaps.vGap10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              '备注：至少上传五条监测记录',
              style: TextStyle(fontSize: 13, color: Colours.secondary_text),
            ),
          ),
          Gaps.vGap10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
//                ClipButton(
//                  text: '添加记录',
//                  icon: Icons.add,
//                  color: Colors.lightGreen,
//                  onTap: () {
//                    list.add(AirDeviceCheckUpload(
//                        inspectionTaskId: task.inspectionTaskId,
//                        itemType: task.itemType));
//                    _pageBloc.add(PageLoad(model: list));
//                  },
//                ),
//                Gaps.hGap20,
                ClipButton(
                  text: '提交',
                  icon: Icons.file_upload,
                  color: Colors.lightBlue,
                  onTap: () {
                    _uploadBloc.add(Upload(
                      data: airDeviceCheckUpload,
                    ));
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

  Widget _buildPageListItem(List<AirDeviceCheckRecord> list, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        EditRowWidget(
          title: '哈哈哈',
          onChanged: (value) {
          },
        ),
        Gaps.hLine,
      ],
    );
  }
}
