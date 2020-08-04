import 'dart:convert';

import 'package:bdmap_location_flutter_plugin/flutter_baidu_location.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'water_device_correct_upload_model.dart';
import 'water_device_correct_upload_repository.dart';

/// 废水监测设备校准上报页面
class WaterDeviceCorrectUploadPage extends StatefulWidget {
  final String taskJson;

  WaterDeviceCorrectUploadPage({this.taskJson});

  @override
  _WaterDeviceCorrectUploadPageState createState() =>
      _WaterDeviceCorrectUploadPageState(
        task: RoutineInspectionUploadList.fromJson(json.decode(taskJson)),
      );
}

class _WaterDeviceCorrectUploadPageState
    extends State<WaterDeviceCorrectUploadPage> {
  /// 运维任务
  final RoutineInspectionUploadList task;

  /// 上报Bloc
  final UploadBloc _uploadBloc = UploadBloc(
    uploadRepository: WaterDeviceCorrectUploadRepository(),
  );

  /// 废水监测设备校准上报类
  final WaterDeviceCorrectUpload _waterDeviceCorrectUpload =
      WaterDeviceCorrectUpload();

  _WaterDeviceCorrectUploadPageState({this.task});

  @override
  void initState() {
    super.initState();
    // 加载界面(默认有一条记录)
    _waterDeviceCorrectUpload.waterDeviceCorrectRecordList.add(
      WaterDeviceCorrectRecord(
        inspectionTaskId: task.inspectionTaskId,
        itemType: task.itemType,
      ),
    );
  }

  @override
  void dispose() {
    /// 释放资源
    _waterDeviceCorrectUpload.waterDeviceCorrectRecordList.forEach(
      (waterDeviceCorrectUpload) {
        waterDeviceCorrectUpload.standardSolution.dispose();
        waterDeviceCorrectUpload.realitySolution.dispose();
        waterDeviceCorrectUpload.currentCheckResult.dispose();
      },
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          UploadHeaderWidget(
            title: '废水监测设备校准',
            subTitle: '''${task.enterName}
监控点名：${task.monitorName}
设备名称：${task.deviceName}
开始日期：${task.inspectionStartTime}
截至日期：${task.inspectionEndTime}''',
            imagePath: 'assets/images/upload_header_image4.png',
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
            LocationWidget(
              locationCallback: (BaiduLocation baiduLocation) {
                setState(() {
                  _waterDeviceCorrectUpload.baiduLocation = baiduLocation;
                });
              },
            ),
            Gaps.hLine,
            Column(
              children: _waterDeviceCorrectUpload.waterDeviceCorrectRecordList
                      ?.asMap()
                      ?.map((i,
                              WaterDeviceCorrectRecord
                                  waterDeviceCorrectRecord) =>
                          MapEntry(i, _buildPageListItem(i)))
                      ?.values
                      ?.toList() ??
                  [],
            ),
            Gaps.vGap10,
            const Text(
              '备注：如经过校准后标样核查仍未通过，请添加记录重复上述流程',
              style: TextStyle(fontSize: 13, color: Colours.secondary_text),
            ),
            Gaps.vGap10,
            Row(
              children: <Widget>[
                ClipButton(
                  text: '添加记录',
                  icon: Icons.add,
                  color: Colors.lightGreen,
                  onTap: () {
                    setState(() {
                      _waterDeviceCorrectUpload.waterDeviceCorrectRecordList
                          .add(
                        WaterDeviceCorrectRecord(
                          inspectionTaskId: task.inspectionTaskId,
                          itemType: task.itemType,
                        ),
                      );
                    });
                  },
                ),
                Gaps.hGap20,
                ClipButton(
                  text: '提交',
                  icon: Icons.file_upload,
                  color: Colors.lightBlue,
                  onTap: () {
                    _uploadBloc.add(Upload(data: _waterDeviceCorrectUpload));
                  },
                ),
              ],
            ),
            Gaps.vGap20,
          ],
        ),
      ),
    );
  }

  Widget _buildPageListItem(int index) {
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
              offstage: _waterDeviceCorrectUpload
                      .waterDeviceCorrectRecordList.length ==
                  1,
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
                                  _waterDeviceCorrectUpload
                                      .waterDeviceCorrectRecordList
                                      .removeAt(index);
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
        InfoRowWidget(
          title: '核查情况',
          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),
        ),
        Gaps.hLine,
        SelectRowWidget(
          title: '核查时间',
          content: DateUtil.formatDate(
              _waterDeviceCorrectUpload
                  .waterDeviceCorrectRecordList[index]?.currentCheckTime,
              format: 'yyyy-MM-dd HH:mm'),
          onTap: () {
            DatePicker.showDatePicker(
              context,
              dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
              locale: DateTimePickerLocale.zh_cn,
              pickerMode: DateTimePickerMode.datetime,
              initialDateTime: _waterDeviceCorrectUpload
                  .waterDeviceCorrectRecordList[index]?.currentCheckTime,
              onClose: () {},
              onConfirm: (dateTime, selectedIndex) {
                setState(() {
                  _waterDeviceCorrectUpload.waterDeviceCorrectRecordList[index]
                      .currentCheckTime = dateTime;
                });
              },
            );
          },
        ),
        Gaps.hLine,
        EditRowWidget(
          title: '标液浓度',
          keyboardType: TextInputType.number,
          controller: _waterDeviceCorrectUpload
              .waterDeviceCorrectRecordList[index].standardSolution,
        ),
        Gaps.hLine,
        EditRowWidget(
          title: '实测浓度',
          keyboardType: TextInputType.number,
          controller: _waterDeviceCorrectUpload
              .waterDeviceCorrectRecordList[index].realitySolution,
        ),
        Gaps.hLine,
        EditRowWidget(
          title: '核查结果',
          controller: _waterDeviceCorrectUpload
              .waterDeviceCorrectRecordList[index].currentCheckResult,
        ),
        Gaps.hLine,
        RadioRowWidget(
          title: '是否合格',
          trueText: '合格',
          falseText: '不合格',
          checked: _waterDeviceCorrectUpload
              .waterDeviceCorrectRecordList[index].currentCheckIsPass,
          onChanged: (value) {
            setState(() {
              _waterDeviceCorrectUpload.waterDeviceCorrectRecordList[index]
                  .currentCheckIsPass = value;
            });
          },
        ),
        Gaps.hLine,
        InfoRowWidget(
          title: '校准情况',
          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),
        ),
        Gaps.hLine,
        SelectRowWidget(
          title: '校准时间',
          content: DateUtil.formatDate(
              _waterDeviceCorrectUpload
                  .waterDeviceCorrectRecordList[index]?.currentCorrectTime,
              format: 'yyyy-MM-dd HH:mm'),
          onTap: () {
            DatePicker.showDatePicker(
              context,
              dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
              locale: DateTimePickerLocale.zh_cn,
              pickerMode: DateTimePickerMode.datetime,
              initialDateTime: _waterDeviceCorrectUpload
                  .waterDeviceCorrectRecordList[index]?.currentCorrectTime,
              onClose: () {},
              onConfirm: (dateTime, selectedIndex) {
                setState(() {
                  _waterDeviceCorrectUpload.waterDeviceCorrectRecordList[index]
                      .currentCorrectTime = dateTime;
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
          checked: _waterDeviceCorrectUpload
              .waterDeviceCorrectRecordList[index].currentCorrectIsPass,
          onChanged: (value) {
            setState(() {
              _waterDeviceCorrectUpload.waterDeviceCorrectRecordList[index]
                  .currentCorrectIsPass = value;
            });
          },
        ),
        Gaps.hLine,
      ],
    );
  }
}
