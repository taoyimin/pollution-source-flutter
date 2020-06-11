import 'dart:convert';

import 'package:bdmap_location_flutter_plugin/flutter_baidu_location.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/inspection/check/air/upload/air_device_check_upload_model.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_factor_model.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_factor_repository.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

class AirDeviceCheckUploadPage extends StatefulWidget {
  final String json;

  AirDeviceCheckUploadPage({this.json});

  @override
  _AirDeviceCheckUploadPageState createState() =>
      _AirDeviceCheckUploadPageState();
}

class _AirDeviceCheckUploadPageState extends State<AirDeviceCheckUploadPage> {
  /// 加载因子信息Bloc
  DetailBloc _detailBloc;

  /// 上报Bloc
  UploadBloc _uploadBloc;

  /// 运维任务
  RoutineInspectionUploadList task;

  final AirDeviceCheckUpload _airDeviceCheckUpload = AirDeviceCheckUpload();

  @override
  void initState() {
    super.initState();
    // 初始化运维任务
    task = RoutineInspectionUploadList.fromJson(json.decode(widget.json));
    // 初始化界面
    _airDeviceCheckUpload.inspectionTaskId = task.inspectionTaskId;
    _airDeviceCheckUpload.itemType = task.itemType;
    // 默认五条校准记录
    _airDeviceCheckUpload.airDeviceCheckRecordList = [
      AirDeviceCheckRecord(),
      AirDeviceCheckRecord(),
      AirDeviceCheckRecord(),
      AirDeviceCheckRecord(),
      AirDeviceCheckRecord(),
    ];
    // 初始化监测因子Bloc
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    // 加载该设备的监测因子
    _detailBloc.add(DetailLoad(
        params: RoutineInspectionUploadFactorRepository.createParams(
      factorCode: task.factorCode,
      deviceId: task.deviceId,
      monitorId: task.monitorId,
    )));
    // 初始化上报Bloc
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
  }

  @override
  void dispose() {
    // 释放资源
    _airDeviceCheckUpload.airDeviceCheckRecordList
        .forEach((airDeviceCheckRecord) {
      airDeviceCheckRecord.currentCheckIsPass.dispose();
      airDeviceCheckRecord.currentCheckResult.dispose();
    });
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
                title: '废气监测设备校验',
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
                    Toast.show(state.message);
                    Navigator.pop(context, true);
                  }
                },
              ),
            ],
            child: _buildPageLoadedDetail(_airDeviceCheckUpload),
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(AirDeviceCheckUpload airDeviceCheckUpload) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          LocationWidget(
            locationCallback: (BaiduLocation baiduLocation) {
              setState(() {
                airDeviceCheckUpload.baiduLocation = baiduLocation;
              });
            },
          ),
          Gaps.hLine,
          DetailRowWidget<RoutineInspectionUploadFactor>(
            title: '校验因子',
            content: airDeviceCheckUpload?.factor?.factorName,
            detailBloc: _detailBloc,
            onLoaded: (RoutineInspectionUploadFactor factor) {
              setState(() {
                airDeviceCheckUpload.factor = factor;
              });
            },
            onErrorTap: () {
              _detailBloc.add(DetailLoad(
                  params: RoutineInspectionUploadFactorRepository.createParams(
                factorCode: task.factorCode,
                deviceId: task.deviceId,
                monitorId: task.monitorId,
              )));
            },
          ),
          Gaps.hLine,
          DetailRowWidget<RoutineInspectionUploadFactor>(
            title: '测量单位',
            content: airDeviceCheckUpload?.factor?.unit,
            detailBloc: _detailBloc,
            onLoaded: (RoutineInspectionUploadFactor factor) {},
            onErrorTap: () {
              _detailBloc.add(DetailLoad(
                  params: RoutineInspectionUploadFactorRepository.createParams(
                factorCode: task.factorCode,
                deviceId: task.deviceId,
                monitorId: task.monitorId,
              )));
            },
          ),
          Gaps.hLine,
          Container(
            height: 46,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '监测时间',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '参比方法测量值',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'CEMS测量值',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gaps.hLine,
          Column(
            children: airDeviceCheckUpload?.airDeviceCheckRecordList
                    ?.asMap()
                    ?.map((i, AirDeviceCheckRecord airDeviceCheckRecord) =>
                        MapEntry(
                            i,
                            _buildPageListItem(
                              i,
                              airDeviceCheckUpload.airDeviceCheckRecordList,
                            )))
                    ?.values
                    ?.toList() ??
                [],
          ),
          Container(
            height: 46,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '平均测量值',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '${airDeviceCheckUpload?.compareAvgVal}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '${airDeviceCheckUpload?.cemsAvgVal}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gaps.hLine,
          Gaps.vGap10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '备注：至少上传五条记录',
                style: TextStyle(
                  fontSize: 13,
                  color: Colours.secondary_text,
                ),
              ),
              Gaps.hGap10,
              InkWell(
                onTap: () {
                  setState(() {
                    airDeviceCheckUpload.airDeviceCheckRecordList
                        .add(AirDeviceCheckRecord());
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Gaps.hLine,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text('如校验合格前对系统进行过处理、调整、参数修改，请说明:'),
              ),
              TextAreaWidget(
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    airDeviceCheckUpload.paramRemark = value;
                  });
                },
              ),
              Gaps.hLine,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text('如校验后，颗粒物测量仪、流速仪的原校正系统改动，请说明:'),
              ),
              TextAreaWidget(
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    airDeviceCheckUpload.changeRemark = value;
                  });
                },
              ),
              Gaps.hLine,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text('总体校验是否合格:'),
              ),
              TextAreaWidget(
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    airDeviceCheckUpload.checkResult = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
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
          Gaps.vGap20,
        ],
      ),
    ));
  }

  Widget _buildPageListItem(int index, List<AirDeviceCheckRecord> list) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SelectWidget(
              content: DateUtil.formatDate(list[index]?.currentCheckTime,
                  format: 'MM-dd HH:mm'),
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
            EditWidget(
              controller: list[index].currentCheckResult,
            ),
            EditWidget(
              controller: list[index].currentCheckIsPass,
            ),
            Offstage(
              offstage: list.length <= 5,
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
                child: Image.asset(
                  'assets/images/icon_delete.png',
                  height: 16,
                  width: 16,
                ),
              ),
            ),
          ],
        ),
        Gaps.hLine,
      ],
    );
  }
}
