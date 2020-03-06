import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
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

  AirDeviceCheckUploadPage({
    this.json,
  });

  @override
  _AirDeviceCheckUploadPageState createState() =>
      _AirDeviceCheckUploadPageState();
}

class _AirDeviceCheckUploadPageState extends State<AirDeviceCheckUploadPage> {
  PageBloc _pageBloc;

  /// 加载因子信息Bloc
  DetailBloc _detailBloc;
  UploadBloc _uploadBloc;
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
      airDeviceCheckRecordList: [
        AirDeviceCheckRecord(),
        AirDeviceCheckRecord(),
        AirDeviceCheckRecord(),
        AirDeviceCheckRecord(),
        AirDeviceCheckRecord(),
      ],
    )));
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
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          DetailRowWidget<RoutineInspectionUploadFactor>(
            title: '校验因子',
            content: airDeviceCheckUpload?.factor?.factorName,
            detailBloc: _detailBloc,
            onLoaded: (RoutineInspectionUploadFactor factor) {
              _pageBloc.add(PageLoad(
                model: airDeviceCheckUpload.copyWith(factor: factor),
              ));
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
                              airDeviceCheckUpload,
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
                  airDeviceCheckUpload.airDeviceCheckRecordList
                      .add(AirDeviceCheckRecord());
                  _pageBloc.add(PageLoad(model: airDeviceCheckUpload));
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
                  _pageBloc.add(PageLoad(
                      model:
                          airDeviceCheckUpload.copyWith(paramRemark: value)));
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
                  _pageBloc.add(PageLoad(
                      model:
                          airDeviceCheckUpload.copyWith(changeRemark: value)));
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
                  _pageBloc.add(PageLoad(
                      model:
                          airDeviceCheckUpload.copyWith(checkResult: value)));
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

  Widget _buildPageListItem(int index, List<AirDeviceCheckRecord> list,
      AirDeviceCheckUpload airDeviceCheckUpload) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SelectWidget(
              content: DateUtil.formatDate(list[index]?.currentCheckTime,
                  format: 'MM-dd HH:mm'),
              onTap: () {
                DatePicker.showDatePicker(context,
                    locale: DateTimePickerLocale.zh_cn,
                    pickerMode: DateTimePickerMode.datetime,
                    onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                      list[index] =
                          list[index].copyWith(currentCheckTime: dateTime);
                      _pageBloc.add(PageLoad(
                          model: airDeviceCheckUpload.copyWith(
                              airDeviceCheckRecordList: list)));
                    });
              },
            ),
            EditWidget(
              key: Key('currentCheckResult$index'),
              onChanged: (value) {
                list[index] =
                    list[index].copyWith(currentCheckResult: value);
                _pageBloc.add(PageLoad(
                    model: airDeviceCheckUpload.copyWith(
                        airDeviceCheckRecordList: list)));
              },
            ),
            EditWidget(
              key: Key('currentCheckIsPass$index'),
              onChanged: (value) {
                list[index] =
                    list[index].copyWith(currentCheckIsPass: value);
                _pageBloc.add(PageLoad(
                    model: airDeviceCheckUpload.copyWith(
                        airDeviceCheckRecordList: list)));
              },
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
                              airDeviceCheckUpload.airDeviceCheckRecordList
                                  .removeAt(index);
                              _pageBloc.add(PageLoad(model: airDeviceCheckUpload));
                              //_pageBloc.add(PageLoad(model: airDeviceCheckUpload.copyWith(airDeviceCheckRecordList: list)));
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
