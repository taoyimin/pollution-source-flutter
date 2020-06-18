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
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/inspection/common/air_device_last_value_repository.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_factor_model.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_factor_repository.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';
import 'package:pollution_source/module/inspection/correct/air/upload/air_device_correct_upload_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'air_device_correct_upload_repository.dart';

/// 废气监测设备校准上报页面
class AirDeviceCorrectUploadPage extends StatefulWidget {
  final String taskJson;

  AirDeviceCorrectUploadPage({this.taskJson});

  @override
  _AirDeviceCorrectUploadPageState createState() =>
      _AirDeviceCorrectUploadPageState(
        task: RoutineInspectionUploadList.fromJson(json.decode(taskJson)),
      );
}

class _AirDeviceCorrectUploadPageState
    extends State<AirDeviceCorrectUploadPage> {
  /// 运维任务
  final RoutineInspectionUploadList task;

  /// 上报Bloc
  final UploadBloc _uploadBloc = UploadBloc(
    uploadRepository: AirDeviceCorrectUploadRepository(),
  );

  /// 加载因子信息Bloc
  final DetailBloc _factorBloc = DetailBloc(
    detailRepository: RoutineInspectionUploadFactorRepository(),
  );

  /// 加载上次校准后测试值Bloc
  final DetailBloc _lastValueBloc = DetailBloc(
    detailRepository: AirDeviceLastValueRepository(),
  );

  /// 废气监测设备校准上报类
  final AirDeviceCorrectUpload _airDeviceCorrectUpload =
      AirDeviceCorrectUpload();

  _AirDeviceCorrectUploadPageState({this.task});

  @override
  void initState() {
    super.initState();
    _airDeviceCorrectUpload.inspectionTaskId = task.inspectionTaskId;
    // 加载该设备的监测因子
    _loadFactor();
    // 加载上次校准后测试值
    _lastValueBloc.add(DetailLoad(detailId: task.inspectionTaskId));
  }

  @override
  void dispose() {
    /// 释放资源
    _airDeviceCorrectUpload.zeroVal.dispose();
    _airDeviceCorrectUpload.beforeZeroVal.dispose();
    _airDeviceCorrectUpload.correctZeroVal.dispose();
    _airDeviceCorrectUpload.zeroPercent.dispose();
    _airDeviceCorrectUpload.zeroCorrectVal.dispose();
    _airDeviceCorrectUpload.rangeVal.dispose();
    _airDeviceCorrectUpload.beforeRangeVal.dispose();
    _airDeviceCorrectUpload.correctRangeVal.dispose();
    _airDeviceCorrectUpload.rangePercent.dispose();
    _airDeviceCorrectUpload.rangeCorrectVal.dispose();
    // 取消正在进行的请求
    if (_factorBloc?.state is DetailLoading)
      (_factorBloc?.state as DetailLoading).cancelToken.cancel();
    // 取消正在进行的请求
    if (_lastValueBloc?.state is DetailLoading)
      (_lastValueBloc?.state as DetailLoading).cancelToken.cancel();
    super.dispose();
  }

  _loadFactor() {
    _factorBloc.add(DetailLoad(
      params: RoutineInspectionUploadFactorRepository.createParams(
        factorCode: task.factorCode,
        deviceId: task.deviceId,
        monitorId: task.monitorId,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          UploadHeaderWidget(
            title: '废气监测设备校准',
            subTitle: '''${task.enterName}
监控点名：${task.monitorName}
设备名称：${task.deviceName}
开始日期：${task.inspectionStartTime}
截至日期：${task.inspectionEndTime}''',
            imagePath: 'assets/images/factor_report_upload_header_image.png',
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
                    Toast.show(state.message);
                    Navigator.pop(context, true);
                  }
                },
              ),
              BlocListener<DetailBloc, DetailState>(
                bloc: _lastValueBloc,
                listener: (context, state) {
                  if (state is DetailLoaded) {
                    // 加载上次校准后测试值成功
                    setState(() {
                      if (!TextUtil.isEmpty(state.detail.zeroCorrectVal)) {
                        _airDeviceCorrectUpload.beforeZeroVal.text =
                            state.detail.zeroCorrectVal;
                      }
                      if (!TextUtil.isEmpty(state.detail.rangeCorrectVal)) {
                        _airDeviceCorrectUpload.beforeRangeVal.text =
                            state.detail.rangeCorrectVal;
                      }
                    });
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
    final GestureTapCallback onSuccessTap = () {
      showDialog(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return RoutineInspectionUploadFactorDialog(
            factor: _airDeviceCorrectUpload.factor,
            changeCallBack: (RoutineInspectionUploadFactor factor) {
              setState(() {
                _airDeviceCorrectUpload.factor = factor;
              });
            },
          );
        },
      );
    };

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            LocationWidget(
              locationCallback: (BaiduLocation baiduLocation) {
                setState(() {
                  _airDeviceCorrectUpload.baiduLocation = baiduLocation;
                });
              },
            ),
            Gaps.hLine,
            DetailRowWidget<RoutineInspectionUploadFactor>(
              title: '校准因子',
              content: _airDeviceCorrectUpload?.factor?.factorName,
              detailBloc: _factorBloc,
              onLoaded: (RoutineInspectionUploadFactor factor) {
                setState(() {
                  _airDeviceCorrectUpload.factor = factor;
                });
              },
              onSuccessTap: onSuccessTap,
              onErrorTap: _loadFactor,
            ),
            Gaps.hLine,
            DetailRowWidget<RoutineInspectionUploadFactor>(
              title: '计量单位',
              content: _airDeviceCorrectUpload?.factor?.unit,
              detailBloc: _factorBloc,
              onLoaded: (RoutineInspectionUploadFactor factor) {},
              successFontColor: Colours.primary_color,
              onSuccessTap: onSuccessTap,
              onErrorTap: _loadFactor,
            ),
            Gaps.hLine,
            DetailRowWidget<RoutineInspectionUploadFactor>(
              title: '分析仪量程',
              content:
                  '${_airDeviceCorrectUpload?.factor?.measureLower} — ${_airDeviceCorrectUpload?.factor?.measureUpper}',
              detailBloc: _factorBloc,
              onLoaded: (RoutineInspectionUploadFactor factor) {},
              successFontColor: Colours.primary_color,
              onSuccessTap: onSuccessTap,
              onErrorTap: _loadFactor,
            ),
            Gaps.hLine,
            InfoRowWidget(
                title: '分析仪原理', content: task?.measurePrinciple ?? '无'),
            Gaps.hLine,
            SelectRowWidget(
              title: '校准开始时间',
              content: DateUtil.formatDate(
                  _airDeviceCorrectUpload?.correctStartTime,
                  format: 'yyyy-MM-dd HH:mm'),
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                  locale: DateTimePickerLocale.zh_cn,
                  pickerMode: DateTimePickerMode.datetime,
                  initialDateTime: _airDeviceCorrectUpload?.correctStartTime,
                  maxDateTime: _airDeviceCorrectUpload?.correctEndTime,
                  onClose: () {},
                  onConfirm: (dateTime, selectedIndex) {
                    setState(() {
                      _airDeviceCorrectUpload.correctStartTime = dateTime;
                    });
                  },
                );
              },
            ),
            Gaps.hLine,
            SelectRowWidget(
              title: '校准结束时间',
              content: DateUtil.formatDate(
                  _airDeviceCorrectUpload?.correctEndTime,
                  format: 'yyyy-MM-dd HH:mm'),
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                  locale: DateTimePickerLocale.zh_cn,
                  pickerMode: DateTimePickerMode.datetime,
                  initialDateTime: _airDeviceCorrectUpload?.correctEndTime,
                  minDateTime: _airDeviceCorrectUpload?.correctStartTime,
                  onClose: () {},
                  onConfirm: (dateTime, selectedIndex) {
                    setState(() {
                      _airDeviceCorrectUpload.correctEndTime = dateTime;
                    });
                  },
                );
              },
            ),
            Gaps.hLine,
            Row(
              children: <Widget>[
                Container(
                  height: 46,
                  child: Center(
                    child: const Text(
                      '零点漂移校准',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '零气浓度值',
              keyboardType: TextInputType.number,
              controller: _airDeviceCorrectUpload.zeroVal,
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '上次校准后测试值',
              keyboardType: TextInputType.number,
              controller: _airDeviceCorrectUpload.beforeZeroVal,
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '校前测试值',
              keyboardType: TextInputType.number,
              controller: _airDeviceCorrectUpload.correctZeroVal,
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '零点漂移 %F.S.',
              keyboardType: TextInputType.number,
              controller: _airDeviceCorrectUpload.zeroPercent,
            ),
            Gaps.hLine,
            RadioRowWidget(
              title: '仪器校准是否正常',
              trueText: '正常',
              falseText: '不正常',
              checked: _airDeviceCorrectUpload?.zeroIsNormal ?? true,
              onChanged: (value) {
                setState(() {
                  _airDeviceCorrectUpload.zeroIsNormal = value;
                });
              },
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '校准后测试值',
              keyboardType: TextInputType.number,
              controller: _airDeviceCorrectUpload.zeroCorrectVal,
            ),
            Gaps.hLine,
            Row(
              children: <Widget>[
                Container(
                  height: 46,
                  child: Center(
                    child: const Text(
                      '量程漂移校准',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '标气浓度值',
              keyboardType: TextInputType.number,
              controller: _airDeviceCorrectUpload.rangeVal,
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '上次校准后测试值',
              keyboardType: TextInputType.number,
              controller: _airDeviceCorrectUpload.beforeRangeVal,
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '校前测试值',
              keyboardType: TextInputType.number,
              controller: _airDeviceCorrectUpload.correctRangeVal,
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '量程漂移 %F.S.',
              keyboardType: TextInputType.number,
              controller: _airDeviceCorrectUpload.rangePercent,
            ),
            Gaps.hLine,
            RadioRowWidget(
              title: '仪器校准是否正常',
              trueText: '正常',
              falseText: '不正常',
              checked: _airDeviceCorrectUpload?.rangeIsNormal ?? true,
              onChanged: (value) {
                setState(() {
                  _airDeviceCorrectUpload.rangeIsNormal = value;
                });
              },
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '校准后测试值',
              keyboardType: TextInputType.number,
              controller: _airDeviceCorrectUpload.rangeCorrectVal,
            ),
            Gaps.hLine,
            Gaps.vGap20,
            Row(
              children: <Widget>[
                ClipButton(
                  text: '提交',
                  icon: Icons.file_upload,
                  color: Colors.lightBlue,
                  onTap: () {
                    _uploadBloc.add(Upload(data: _airDeviceCorrectUpload));
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
}

/// [RoutineInspectionUploadFactorDialog]点击修改按钮的回调函数
typedef ChangeCallBack = void Function(RoutineInspectionUploadFactor value);

class RoutineInspectionUploadFactorDialog extends StatefulWidget {
  final RoutineInspectionUploadFactor factor;
  final ChangeCallBack changeCallBack;

  RoutineInspectionUploadFactorDialog(
      {@required this.factor, this.changeCallBack});

  @override
  _RoutineInspectionUploadFactorDialogState createState() =>
      _RoutineInspectionUploadFactorDialogState();
}

class _RoutineInspectionUploadFactorDialogState
    extends State<RoutineInspectionUploadFactorDialog> {
  TextEditingController unitController;
  TextEditingController measureUpperController;
  TextEditingController measureLowerController;

  @override
  void initState() {
    super.initState();
    unitController = TextEditingController.fromValue(
      TextEditingValue(text: widget.factor.unit.toString()),
    );
    measureUpperController = TextEditingController.fromValue(
      TextEditingValue(text: widget.factor.measureUpper.toString()),
    );
    measureLowerController = TextEditingController.fromValue(
      TextEditingValue(text: widget.factor.measureLower.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.3,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SelectRowWidget(
                  title: '校准因子',
                  content: '颗粒物',
                  onTap: () {},
                ),
                Gaps.vGap6,
                Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Text('计量单位    '),
                      Gaps.hGap20,
                      Flexible(
                        child: TextField(
                          controller: unitController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            fillColor: Color(0xFFDFDFDF),
                            filled: true,
                            hintText: "请输入计量单位",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colours.secondary_text,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.vGap16,
                Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Text('分析仪量程'),
                      Gaps.hGap20,
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: measureLowerController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            fillColor: Color(0xFFDFDFDF),
                            filled: true,
                            hintText: "下限",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colours.secondary_text,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '—',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: measureUpperController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            fillColor: Color(0xFFDFDFDF),
                            filled: true,
                            hintText: "上限",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colours.secondary_text,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.vGap20,
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: InkWellButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        children: <Widget>[
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              boxShadow: [UIUtils.getBoxShadow()],
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(
                              child: Text(
                                '取  消',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.hGap20,
                    Expanded(
                      flex: 1,
                      child: InkWellButton(
                        onTap: () {
                          if (widget.changeCallBack != null) {
                            (widget.changeCallBack)(widget.factor.copyWith(
                              unit: unitController.text,
                              measureUpper: measureUpperController.text,
                              measureLower: measureLowerController.text,
                            ));
                            Navigator.pop(context);
                          }
                        },
                        children: <Widget>[
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              boxShadow: [UIUtils.getBoxShadow()],
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(
                              child: Text(
                                '修  改',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gaps.vGap6,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
