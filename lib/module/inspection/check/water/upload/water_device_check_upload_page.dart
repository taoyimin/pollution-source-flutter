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
  final UploadBloc _uploadBloc = UploadBloc(
    uploadRepository: WaterDeviceUploadRepository(),
  );

  /// 废水监测设备校验上报类
  final WaterDeviceCheckUpload _waterDeviceCheckUpload =
      WaterDeviceCheckUpload();

  _WaterDeviceCheckUploadPageState({this.task});

  @override
  void initState() {
    super.initState();
    _waterDeviceCheckUpload.inspectionTaskId = task.inspectionTaskId;
    _waterDeviceCheckUpload.itemType = task.itemType;
    _waterDeviceCheckUpload.factorName = task.factorName;
    _waterDeviceCheckUpload.factorCode = task.factorCode;
    _waterDeviceCheckUpload.factorUnit =
        TextEditingController(text: task.factorUnit);
  }

  @override
  void dispose() {
    /// 释放资源
    _waterDeviceCheckUpload.measuredDisparity.dispose();
    _waterDeviceCheckUpload.measuredResult.dispose();
    _waterDeviceCheckUpload.factorUnit.dispose();
    _waterDeviceCheckUpload.comparisonMeasuredResultList.forEach(
      (comparisonMeasuredResult) {
        comparisonMeasuredResult.dispose();
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
            title: '废水监测设备校验',
            subTitle: '''${task.enterName}
监控点名：${task.monitorName}
设备名称：${task.deviceName}
开始日期：${task.inspectionStartTime}
截至日期：${task.inspectionEndTime}''',
            imagePath: 'assets/images/upload_header_image3.png',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LocationWidget(
              locationCallback: (BaiduLocation baiduLocation) {
                setState(() {
                  _waterDeviceCheckUpload.baiduLocation = baiduLocation;
                });
              },
            ),
            Gaps.hLine,
            InfoRowWidget(
              title: '校验因子',
              content: _waterDeviceCheckUpload.factorName ?? '无',
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '在线监测仪器测定结果',
              hintText: '请输入测定结果',
              controller: _waterDeviceCheckUpload.measuredResult,
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '测定结果单位',
              hintText: '请输入测定单位',
              controller: _waterDeviceCheckUpload.factorUnit,
            ),
            Gaps.hLine,
            InfoRowWidget(
              title: '比对方法测定结果',
              titleStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.hLine,
            ...(_waterDeviceCheckUpload.comparisonMeasuredResultList
                .map(
                  (TextEditingController comparisonMeasuredResult) =>
                      _buildPageListItem(
                    _waterDeviceCheckUpload.comparisonMeasuredResultList
                        .indexOf(comparisonMeasuredResult),
                  ),
                )
                .expand((widget) => [widget, Gaps.hLine])),
            Gaps.vGap10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '可以填入多条测定结果',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colours.secondary_text,
                  ),
                ),
                Gaps.hGap10,
                InkWell(
                  onTap: () {
                    setState(() {
                      _waterDeviceCheckUpload.comparisonMeasuredResultList
                          .add(TextEditingController());
                    });
                  },
                  child: const Text(
                    '点击新增',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colours.primary_color,
                    ),
                  ),
                )
              ],
            ),
            Gaps.vGap10,
            Gaps.hLine,
            InfoRowWidget(
              title: '比对方法测定结果平均值',
              content: _waterDeviceCheckUpload.comparisonMeasuredAvg,
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '测定误差',
              controller: _waterDeviceCheckUpload.measuredDisparity,
            ),
            Gaps.hLine,
            SelectRowWidget(
              title: '校验时间',
              content: DateUtil.formatDate(
                  _waterDeviceCheckUpload.currentCheckTime,
                  format: 'yyyy-MM-dd HH:mm'),
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                  locale: DateTimePickerLocale.zh_cn,
                  pickerMode: DateTimePickerMode.datetime,
                  initialDateTime: _waterDeviceCheckUpload.currentCheckTime,
                  onClose: () {},
                  onConfirm: (dateTime, selectedIndex) {
                    setState(() {
                      _waterDeviceCheckUpload.currentCheckTime = dateTime;
                    });
                  },
                );
              },
            ),
            Gaps.hLine,
            RadioRowWidget(
              title: '是否合格',
              trueText: '合格',
              falseText: '不合格',
              checked: _waterDeviceCheckUpload.isQualified,
              onChanged: (value) {
                setState(() {
                  _waterDeviceCheckUpload.isQualified = value;
                });
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
                    _uploadBloc.add(Upload(data: _waterDeviceCheckUpload));
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
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: EditRowWidget(
            title: '测定结果${index + 1}',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {});
            },
            controller:
                _waterDeviceCheckUpload.comparisonMeasuredResultList[index],
          ),
        ),
        Gaps.hGap5,
        Offstage(
          offstage:
              _waterDeviceCheckUpload.comparisonMeasuredResultList.length <= 1,
          child: GestureDetector(
            onTap: () {
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
                            _waterDeviceCheckUpload.comparisonMeasuredResultList
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
            child: Image.asset(
              'assets/images/icon_delete.png',
              height: 16,
              width: 16,
            ),
          ),
        ),
      ],
    );
  }
}
