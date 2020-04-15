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
import 'package:pollution_source/module/inspection/check/water/upload/water_device_check_upload_model.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

class WaterDeviceCheckUploadPage extends StatefulWidget {
  final String json;

  WaterDeviceCheckUploadPage({
    this.json,
  });

  @override
  _WaterDeviceCheckUploadPageState createState() =>
      _WaterDeviceCheckUploadPageState();
}

class _WaterDeviceCheckUploadPageState
    extends State<WaterDeviceCheckUploadPage> {
  PageBloc _pageBloc;
  UploadBloc _uploadBloc;
  RoutineInspectionUploadList task;

  @override
  void initState() {
    super.initState();
    task = RoutineInspectionUploadList.fromJson(json.decode(widget.json));
    // 初始化页面Bloc
    _pageBloc = BlocProvider.of<PageBloc>(context);
    // 加载界面(默认有一条记录)
    _pageBloc.add(PageLoad(model: [
      WaterDeviceCheckUpload(
        inspectionTaskId: task.inspectionTaskId,
        itemType: task.itemType,
      )
    ]));
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
                title: '废水监测设备校验',
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
                    list.add(WaterDeviceCheckUpload(
                        inspectionTaskId: task.inspectionTaskId,
                        itemType: task.itemType));
                    _pageBloc.add(PageLoad(model: list));
                  },
                ),
                Gaps.hGap20,
                ClipButton(
                  text: '提交',
                  icon: Icons.file_upload,
                  color: Colors.lightBlue,
                  onTap: () {
                    _uploadBloc.add(Upload(
                      data: list,
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
                                list.removeAt(index);
                                _pageBloc.add(PageLoad(model: list));
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
            DatePicker.showDatePicker(context,
                locale: DateTimePickerLocale.zh_cn,
                pickerMode: DateTimePickerMode.datetime,
                onClose: () {}, onConfirm: (dateTime, selectedIndex) {
              list[index] = list[index].copyWith(currentCheckTime: dateTime);
              _pageBloc.add(PageLoad(model: list));
            });
          },
        ),
        Gaps.hLine,
        EditRowWidget(
          title: '标液浓度',
          onChanged: (value) {
            list[index] = list[index].copyWith(standardSolution: value);
            _pageBloc.add(PageLoad(model: list));
          },
        ),
        Gaps.hLine,
        EditRowWidget(
          title: '实测浓度',
          onChanged: (value) {
            list[index] = list[index].copyWith(realitySolution: value);
            _pageBloc.add(PageLoad(model: list));
          },
        ),
        Gaps.hLine,
        EditRowWidget(
          title: '核查结果',
          onChanged: (value) {
            list[index] = list[index].copyWith(currentCheckResult: value);
            _pageBloc.add(PageLoad(model: list));
          },
        ),
        Gaps.hLine,
        RadioRowWidget(
          title: '是否合格',
          trueText: '合格',
          falseText: '不合格',
          checked: list[index].currentCheckIsPass,
          onChanged: (value) {
            list[index] = list[index].copyWith(currentCheckIsPass: value);
            _pageBloc.add(PageLoad(model: list));
          },
        ),
        Gaps.hLine,
        SelectRowWidget(
          title: '校准时间',
          content: DateUtil.formatDate(list[index]?.currentCorrectTime,
              format: 'yyyy-MM-dd HH:mm'),
          onTap: () {
            DatePicker.showDatePicker(context,
                locale: DateTimePickerLocale.zh_cn,
                pickerMode: DateTimePickerMode.datetime,
                onClose: () {}, onConfirm: (dateTime, selectedIndex) {
              list[index] = list[index].copyWith(currentCorrectTime: dateTime);
              _pageBloc.add(PageLoad(model: list));
            });
          },
        ),
        Gaps.hLine,
        RadioRowWidget(
          title: '是否通过',
          trueText: '通过',
          falseText: '不通过',
          checked: list[index].currentCorrectIsPass,
          onChanged: (value) {
            list[index] = list[index].copyWith(currentCorrectIsPass: value);
            _pageBloc.add(PageLoad(model: list));
          },
        ),
        Gaps.hLine,
      ],
    );
  }
}
