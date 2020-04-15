import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
import 'package:pollution_source/module/common/page/page_state.dart';
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

class AirDeviceCorrectUploadPage extends StatefulWidget {
  final String json;

  AirDeviceCorrectUploadPage({
    this.json,
  });

  @override
  _AirDeviceCorrectUploadPageState createState() =>
      _AirDeviceCorrectUploadPageState();
}

class _AirDeviceCorrectUploadPageState
    extends State<AirDeviceCorrectUploadPage> {
  PageBloc _pageBloc;

  /// 加载因子信息Bloc
  DetailBloc _detailBloc;

  /// 加载上次校准后测试值
  DetailBloc _lastValueBloc;
  UploadBloc _uploadBloc;
  RoutineInspectionUploadList task;
  TextEditingController _zeroCorrectValController;
  TextEditingController _rangeCorrectValController;

  @override
  void initState() {
    super.initState();
    _zeroCorrectValController = TextEditingController();
    _rangeCorrectValController = TextEditingController();
    task = RoutineInspectionUploadList.fromJson(json.decode(widget.json));
    // 初始化页面Bloc
    _pageBloc = BlocProvider.of<PageBloc>(context);
    // 加载界面(默认有一条记录)
    _pageBloc.add(PageLoad(
        model: AirDeviceCorrectUpload(
      inspectionTaskId: task.inspectionTaskId,
    )));
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    // 加载该设备的监测因子
    _detailBloc.add(DetailLoad(
        params: RoutineInspectionUploadFactorRepository.createParams(
      factorCode: task.factorCode,
      deviceId: task.deviceId,
      monitorId: task.monitorId,
    )));
    _lastValueBloc =
        DetailBloc(detailRepository: AirDeviceLastValueRepository());
    _lastValueBloc.add(DetailLoad(detailId: task.inspectionTaskId));
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
                title: '废气监测设备校准',
                subTitle: '''$enterName
监控点名：$monitorName
设备名称：$deviceName
开始日期：$inspectionStartTime
截至日期：$inspectionEndTime''',
                imagePath:
                    'assets/images/factor_report_upload_header_image.png',
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
              BlocListener<DetailBloc, DetailState>(
                bloc: _lastValueBloc,
                listener: (context, state) {
                  final currentState = _pageBloc.state;
                  if (state is DetailLoaded && currentState is PageLoaded) {
                    // 加载上次校准后测试值成功
                    if (!TextUtil.isEmpty(state.detail.zeroCorrectVal)) {
                      _zeroCorrectValController.text =
                          state.detail.zeroCorrectVal;
                    }
                    if (!TextUtil.isEmpty(state.detail.rangeCorrectVal)) {
                      _rangeCorrectValController.text =
                          state.detail.rangeCorrectVal;
                    }
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

  Widget _buildPageLoadedDetail(AirDeviceCorrectUpload airDeviceCorrectUpload) {
    final GestureTapCallback onSuccessTap = () {
      showDialog(
          context: context, //BuildContext对象
          barrierDismissible: false,
          builder: (BuildContext context) {
            return RoutineInspectionUploadFactorDialog(
              factor: airDeviceCorrectUpload.factor,
              changeCallBack: (RoutineInspectionUploadFactor factor) {
                _pageBloc.add(PageLoad(
                    model: airDeviceCorrectUpload.copyWith(
                        factor: factor)));
              },
            );
          });
    };

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            DetailRowWidget<RoutineInspectionUploadFactor>(
              title: '校准因子',
              content: airDeviceCorrectUpload?.factor?.factorName,
              detailBloc: _detailBloc,
              onLoaded: (RoutineInspectionUploadFactor factor) {
                _pageBloc.add(PageLoad(
                  model: airDeviceCorrectUpload.copyWith(factor: factor),
                ));
              },
              onSuccessTap: onSuccessTap,
              onErrorTap: () {
                // 加载失败后点击重新加载
                _detailBloc.add(DetailLoad(
                    params:
                        RoutineInspectionUploadFactorRepository.createParams(
                  factorCode: task.factorCode,
                  deviceId: task.deviceId,
                  monitorId: task.monitorId,
                )));
              },
            ),
            Gaps.hLine,
            DetailRowWidget<RoutineInspectionUploadFactor>(
              title: '计量单位',
              content: airDeviceCorrectUpload?.factor?.unit,
              detailBloc: _detailBloc,
              onLoaded: (RoutineInspectionUploadFactor factor) {},
              onSuccessTap: onSuccessTap,
              onErrorTap: () {
                // 加载失败后点击重新加载
                _detailBloc.add(DetailLoad(
                    params:
                        RoutineInspectionUploadFactorRepository.createParams(
                  factorCode: task.factorCode,
                  deviceId: task.deviceId,
                  monitorId: task.monitorId,
                )));
              },
            ),
            Gaps.hLine,
            DetailRowWidget<RoutineInspectionUploadFactor>(
              title: '分析仪量程',
              content:
                  '${airDeviceCorrectUpload?.factor?.measureLower} — ${airDeviceCorrectUpload?.factor?.measureUpper}',
              detailBloc: _detailBloc,
              onLoaded: (RoutineInspectionUploadFactor factor) {},
              onSuccessTap: onSuccessTap,
              onErrorTap: () {
                // 加载失败后点击重新加载
                _detailBloc.add(DetailLoad(
                    params:
                        RoutineInspectionUploadFactorRepository.createParams(
                  factorCode: task.factorCode,
                  deviceId: task.deviceId,
                  monitorId: task.monitorId,
                )));
              },
            ),
            Gaps.hLine,
            InfoRowWidget(
                title: '分析仪原理', content: task?.measurePrinciple ?? '无'),
            Gaps.hLine,
            SelectRowWidget(
              title: '校准开始时间',
              content: DateUtil.formatDate(
                  airDeviceCorrectUpload?.correctStartTime,
                  format: 'yyyy-MM-dd HH:mm'),
              onTap: () {
                DatePicker.showDatePicker(context,
                    locale: DateTimePickerLocale.zh_cn,
                    pickerMode: DateTimePickerMode.datetime,
                    onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                  _pageBloc.add(PageLoad(
                      model: airDeviceCorrectUpload.copyWith(
                          correctStartTime: dateTime)));
                });
              },
            ),
            Gaps.hLine,
            SelectRowWidget(
              title: '校准结束时间',
              content: DateUtil.formatDate(
                  airDeviceCorrectUpload?.correctEndTime,
                  format: 'yyyy-MM-dd HH:mm'),
              onTap: () {
                DatePicker.showDatePicker(context,
                    locale: DateTimePickerLocale.zh_cn,
                    pickerMode: DateTimePickerMode.datetime,
                    onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                  _pageBloc.add(PageLoad(
                      model: airDeviceCorrectUpload.copyWith(
                          correctEndTime: dateTime)));
                });
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
              onChanged: (value) {
                _pageBloc.add(PageLoad(
                    model: airDeviceCorrectUpload.copyWith(zeroVal: value)));
              },
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '上次校准后测试值',
              keyboardType: TextInputType.number,
              controller: _zeroCorrectValController,
              onChanged: (value) {
                _pageBloc.add(PageLoad(
                    model:
                        airDeviceCorrectUpload.copyWith(beforeZeroVal: value)));
              },
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '校前测试值',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _pageBloc.add(PageLoad(
                    model: airDeviceCorrectUpload.copyWith(
                        correctZeroVal: value)));
              },
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '零点漂移 %F.S.',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _pageBloc.add(PageLoad(
                    model:
                        airDeviceCorrectUpload.copyWith(zeroPercent: value)));
              },
            ),
            Gaps.hLine,
            RadioRowWidget(
              title: '仪器校准是否正常',
              trueText: '正常',
              falseText: '不正常',
              checked: airDeviceCorrectUpload?.zeroIsNormal ?? true,
              onChanged: (value) {
                _pageBloc.add(PageLoad(
                    model:
                        airDeviceCorrectUpload.copyWith(zeroIsNormal: value)));
              },
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '校准后测试值',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _pageBloc.add(PageLoad(
                    model: airDeviceCorrectUpload.copyWith(
                        zeroCorrectVal: value)));
              },
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
              onChanged: (value) {
                _pageBloc.add(PageLoad(
                    model: airDeviceCorrectUpload.copyWith(rangeVal: value)));
              },
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '上次校准后测试值',
              keyboardType: TextInputType.number,
              controller: _rangeCorrectValController,
              onChanged: (value) {
                _pageBloc.add(PageLoad(
                    model: airDeviceCorrectUpload.copyWith(
                        beforeRangeVal: value)));
              },
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '校前测试值',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _pageBloc.add(PageLoad(
                    model: airDeviceCorrectUpload.copyWith(
                        correctRangeVal: value)));
              },
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '量程漂移 %F.S.',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _pageBloc.add(PageLoad(
                    model:
                        airDeviceCorrectUpload.copyWith(rangePercent: value)));
              },
            ),
            Gaps.hLine,
            RadioRowWidget(
              title: '仪器校准是否正常',
              trueText: '正常',
              falseText: '不正常',
              checked: airDeviceCorrectUpload?.rangeIsNormal ?? true,
              onChanged: (value) {
                _pageBloc.add(PageLoad(
                    model:
                        airDeviceCorrectUpload.copyWith(rangeIsNormal: value)));
              },
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '校准后测试值',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _pageBloc.add(PageLoad(
                    model: airDeviceCorrectUpload.copyWith(
                        rangeCorrectVal: value)));
              },
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
                    _uploadBloc.add(Upload(
                      data: airDeviceCorrectUpload,
                    ));
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
