import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/inspection/check/water/upload/water_device_check_upload_model.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'water_device_check_upload_repository.dart';

/// 废水监测设备校验上报页面
class WaterDeviceCheckUploadPage extends StatefulWidget {
  final String taskJson;

  WaterDeviceCheckUploadPage({this.taskJson});

  @override
  _WaterDeviceCheckUploadPageState createState() =>
      _WaterDeviceCheckUploadPageState(
        task: RoutineInspectionUploadList.fromJson(json.decode(taskJson)),
      );
}

class _WaterDeviceCheckUploadPageState
    extends State<WaterDeviceCheckUploadPage> {
  /// 运维任务
  final RoutineInspectionUploadList task;

  /// 上报Bloc
  final UploadBloc _uploadBloc =
      UploadBloc(uploadRepository: WaterDeviceUploadRepository());

  /// 废水监测设备校验类集合
  final List<WaterDeviceCheckUpload> _waterDeviceCheckUploadList = [];

  _WaterDeviceCheckUploadPageState({this.task});

  @override
  void initState() {
    super.initState();
    // 加载界面(默认有一条记录)
    _waterDeviceCheckUploadList.add(WaterDeviceCheckUpload(
      inspectionTaskId: task.inspectionTaskId,
      itemType: task.itemType,
    ));
  }

  @override
  void dispose() {
    /// 释放资源
    _waterDeviceCheckUploadList.forEach((waterDeviceCheckUpload) {
      waterDeviceCheckUpload.standardSolution.dispose();
      waterDeviceCheckUpload.realitySolution.dispose();
      waterDeviceCheckUpload.currentCheckResult.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          UploadHeaderWidget(
            title: '废水监测设备校验',
            subTitle: '''${task.enterName}
监控点名：${task.monitorName}
设备名称：${task.deviceName}
开始日期：${task.inspectionStartTime}
截至日期：${task.inspectionEndTime}''',
            imagePath:
            'assets/images/long_stop_report_upload_header_image.png',
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
            ],
            child: _buildPageLoadedDetail(_waterDeviceCheckUploadList),
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(List<WaterDeviceCheckUpload> list) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: list
                      ?.asMap()
                      ?.map(
                          (i, WaterDeviceCheckUpload waterDeviceCheckUpload) =>
                              MapEntry(i, _buildPageListItem(list, i)))
                      ?.values
                      ?.toList() ??
                  [],
            ),
          ),
          Gaps.vGap10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              '备注：如经过校准后标样核查仍未通过，请添加记录重复上述流程',
              style: TextStyle(fontSize: 13, color: Colours.secondary_text),
            ),
          ),
          Gaps.vGap10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                ClipButton(
                  text: '添加记录',
                  icon: Icons.add,
                  color: Colors.lightGreen,
                  onTap: () {
                    setState(() {
                      list.add(WaterDeviceCheckUpload(
                        inspectionTaskId: task.inspectionTaskId,
                        itemType: task.itemType,
                      ));
                    });
                  },
                ),
                Gaps.hGap20,
                ClipButton(
                  text: '提交',
                  icon: Icons.file_upload,
                  color: Colors.lightBlue,
                  onTap: () {
                    _uploadBloc.add(Upload(data: list));
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

  Widget _buildPageListItem(List<WaterDeviceCheckUpload> list, int index) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              height: 46,
              child: Center(
                child: Text(
                  '第${index + 1}条记录',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Gaps.empty,
            ),
            Offstage(
              offstage: list.length == 1,
              child: Transform.translate(
                offset: Offset(13, 0),
                child: IconButton(
                  icon: Image.asset(
                    'assets/images/icon_delete.png',
                    height: 18,
                  ),
                  padding: EdgeInsets.only(right: 0),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("删除记录"),
                          content: Text("是否确定删除第${index + 1}条记录？"),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("取消"),
                            ),
                            FlatButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                setState(() {
                                  list.removeAt(index);
                                });
                              },
                              child: const Text("确认"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Gaps.hLine,
        SelectRowWidget(
          title: '核查时间',
          content: DateUtil.formatDate(list[index]?.currentCheckTime,
              format: 'yyyy-MM-dd HH:mm'),
          onTap: () {
            DatePicker.showDatePicker(
              context,
              dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
              locale: DateTimePickerLocale.zh_cn,
              pickerMode: DateTimePickerMode.datetime,
              initialDateTime: list[index]?.currentCheckTime,
              onClose: () {},
              onConfirm: (dateTime, selectedIndex) {
                setState(() {
                  list[index].currentCheckTime = dateTime;
                });
              },
            );
          },
        ),
        Gaps.hLine,
        EditRowWidget(
          title: '标液浓度',
          controller: list[index].standardSolution,
        ),
        Gaps.hLine,
        EditRowWidget(
          title: '实测浓度',
          controller: list[index].realitySolution,
        ),
        Gaps.hLine,
        EditRowWidget(
          title: '核查结果',
          controller: list[index].currentCheckResult,
        ),
        Gaps.hLine,
        RadioRowWidget(
          title: '是否合格',
          trueText: '合格',
          falseText: '不合格',
          checked: list[index].currentCheckIsPass,
          onChanged: (value) {
            setState(() {
              list[index].currentCheckIsPass = value;
            });
          },
        ),
        Gaps.hLine,
        SelectRowWidget(
          title: '校准时间',
          content: DateUtil.formatDate(list[index]?.currentCorrectTime,
              format: 'yyyy-MM-dd HH:mm'),
          onTap: () {
            DatePicker.showDatePicker(
              context,
              dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
              locale: DateTimePickerLocale.zh_cn,
              pickerMode: DateTimePickerMode.datetime,
              initialDateTime: list[index]?.currentCorrectTime,
              onClose: () {},
              onConfirm: (dateTime, selectedIndex) {
                setState(() {
                  list[index].currentCorrectTime = dateTime;
                });
              },
            );
          },
        ),
        Gaps.hLine,
        RadioRowWidget(
          title: '是否通过',
          trueText: '通过',
          falseText: '不通过',
          checked: list[index].currentCorrectIsPass,
          onChanged: (value) {
            setState(() {
              list[index].currentCorrectIsPass = value;
            });
          },
        ),
        Gaps.hLine,
      ],
    );
  }
}
