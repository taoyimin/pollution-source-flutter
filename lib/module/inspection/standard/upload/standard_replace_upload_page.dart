import 'package:bdmap_location_flutter_plugin/flutter_baidu_location.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/device/list/device_list_model.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/system_utils.dart';

import 'standard_replace_upload_model.dart';
import 'standard_replace_upload_repository.dart';

/// 标准样品更换上报界面
class StandardReplaceUploadPage extends StatefulWidget {
  StandardReplaceUploadPage();

  @override
  _StandardReplaceUploadPageState createState() =>
      _StandardReplaceUploadPageState();
}

class _StandardReplaceUploadPageState extends State<StandardReplaceUploadPage> {
  /// 全局Key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 上报Bloc
  final UploadBloc _uploadBloc = UploadBloc(
    uploadRepository: StandardReplaceUploadRepository(),
  );

  /// 标准样品更换上报类
  final StandardReplaceUpload _standardReplaceUpload = StandardReplaceUpload();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    /// 释放资源
    _standardReplaceUpload.amount.dispose();
    _standardReplaceUpload.standardSampleName.dispose();
    _standardReplaceUpload.standardSamplePotency.dispose();
    _standardReplaceUpload.mixPerson.dispose();
    _standardReplaceUpload.replacePerson.dispose();
    _standardReplaceUpload.maintainPerson.dispose();
    _standardReplaceUpload.unit.dispose();
    _standardReplaceUpload.supplier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('标准样品更换上报'),
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
                  // 提交成功后重置界面
                  if (state is UploadSuccess) {
                    setState(() {
                      // 重置界面
                      _standardReplaceUpload.enter = null;
                      _standardReplaceUpload.monitor = null;
                      _standardReplaceUpload.device = null;
                      _standardReplaceUpload.amount.text = '';
                      _standardReplaceUpload.standardSampleName.text = '';
                      _standardReplaceUpload.standardSamplePotency.text = '';
                      _standardReplaceUpload.mixTime = null;
                      _standardReplaceUpload.mixPerson.text = '';
                      _standardReplaceUpload.replaceTime = null;
                      _standardReplaceUpload.replacePerson.text = '';
                      _standardReplaceUpload.validityTime = null;
                      _standardReplaceUpload.maintainTime = null;
                      _standardReplaceUpload.maintainPerson.text = '';
                      _standardReplaceUpload.unit.text = '';
                      _standardReplaceUpload.supplier.text = '';
                      _standardReplaceUpload.attachments.clear();
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
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                LocationWidget(
                  locationCallback: (BaiduLocation baiduLocation) {
                    setState(() {
                      _standardReplaceUpload.baiduLocation = baiduLocation;
                    });
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '企业名称',
                  content: _standardReplaceUpload.enter?.enterName,
                  onTap: () async {
                    // 打开企业选择界面并等待结果返回
                    Enter enter = await Application.router.navigateTo(
                        context, '${Routes.enterList}?type=1&state=1');
                    if (enter != null) {
                      setState(() {
                        // 设置已经选中的企业，重置已经选中的监控点和设备
                        _standardReplaceUpload.enter = enter;
                        _standardReplaceUpload.monitor = null;
                        _standardReplaceUpload.device = null;
                      });
                    }
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '监控点名',
                  content: _standardReplaceUpload.monitor?.monitorName,
                  onTap: () async {
                    if (_standardReplaceUpload.enter == null) {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: const Text('请先选择企业！'),
                          action: SnackBarAction(
                              label: '我知道了',
                              textColor: Colours.primary_color,
                              onPressed: () {}),
                        ),
                      );
                    } else {
                      // 打开监控点选择界面并等待返回结果
                      Monitor monitor = await Application.router.navigateTo(
                          context,
                          '${Routes.monitorList}?enterId=${_standardReplaceUpload.enter?.enterId}&type=1');
                      if (monitor != null) {
                        // 设置选中的监控点，重置已经选中的设备
                        setState(() {
                          _standardReplaceUpload.monitor = monitor;
                          _standardReplaceUpload.device = null;
                          if(monitor.monitorType == 'outletType2'){
                            // 如果是废水监控点，则清空计量单位和供应商
                            _standardReplaceUpload.unit.text = '';
                            _standardReplaceUpload.supplier.text = '';
                          }else if(monitor.monitorType == 'outletType2'){
                            // 如果是废气监控点，则清空配置时间和配置人员
                            _standardReplaceUpload.mixTime = null;
                            _standardReplaceUpload.mixPerson.text = '';
                          }
                        });
                      }
                    }
                  },
                ),
                Gaps.hLine,
                Offstage(
                  // 监控点类型不是废水时，隐藏选择设备
                  offstage: _standardReplaceUpload.monitor?.monitorType != 'outletType2',
                  child: SelectRowWidget(
                    title: '设备名称',
                    content: _standardReplaceUpload.device?.deviceName,
                    onTap: () async {
                      if (_standardReplaceUpload.enter == null) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: const Text('请先选择企业！'),
                            action: SnackBarAction(
                                label: '我知道了',
                                textColor: Colours.primary_color,
                                onPressed: () {}),
                          ),
                        );
                      } else if (_standardReplaceUpload.monitor == null) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: const Text('请先选择监控点！'),
                            action: SnackBarAction(
                                label: '我知道了',
                                textColor: Colours.primary_color,
                                onPressed: () {}),
                          ),
                        );
                      } else {
                        // 打开设备选择界面并等待返回结果
                        Device device = await Application.router.navigateTo(
                            context,
                            '${Routes.deviceList}?monitorId=${_standardReplaceUpload.monitor?.monitorId}&type=1');
                        if (device != null) {
                          // 设置选中的设备和规格型号
                          setState(() {
                            _standardReplaceUpload.device = device;
                          });
                        }
                      }
                    },
                  ),
                ),
                _standardReplaceUpload.monitor?.monitorType != 'outletType2' ? Gaps.empty : Gaps.hLine,
                EditRowWidget(
                  title: '标准样品名称',
                  controller: _standardReplaceUpload.standardSampleName,
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: _standardReplaceUpload.monitor?.monitorType ==
                          'outletType3'
                      ? '气体浓度'
                      : '标准样品浓度',
                  controller: _standardReplaceUpload.standardSamplePotency,
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '数量',
                  controller: _standardReplaceUpload.amount,
                ),
                Gaps.hLine,
                Offstage(
                  // 如果监控点类型不是废气，则隐藏计量单位和供应商
                  offstage: _standardReplaceUpload.monitor?.monitorType !=
                      'outletType3',
                  child: Column(
                    children: [
                      EditRowWidget(
                        title: '计量单位',
                        controller: _standardReplaceUpload.unit,
                      ),
                      Gaps.hLine,
                      EditRowWidget(
                        title: '供应商',
                        controller: _standardReplaceUpload.supplier,
                      ),
                      Gaps.hLine,
                    ],
                  ),
                ),
                Offstage(
                  // 如果监控点类型不是废水，则隐藏配置时间和配置人员
                  offstage: _standardReplaceUpload.monitor?.monitorType !=
                      'outletType2',
                  child: Column(
                    children: [
                      SelectRowWidget(
                        title: '配置时间',
                        content: DateUtil.formatDate(
                            _standardReplaceUpload.mixTime,
                            format: DateFormats.y_mo_d_h_m),
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                              locale: DateTimePickerLocale.zh_cn,
                              pickerMode: DateTimePickerMode.datetime,
                              onClose: () {},
                              onConfirm: (dateTime, selectedIndex) {
                            setState(() {
                              _standardReplaceUpload.mixTime = dateTime;
                            });
                          });
                        },
                      ),
                      Gaps.hLine,
                      EditRowWidget(
                        title: '配置人员',
                        controller: _standardReplaceUpload.mixPerson,
                      ),
                      Gaps.hLine,
                    ],
                  ),
                ),
                SelectRowWidget(
                  title: '更换时间',
                  content: DateUtil.formatDate(
                      _standardReplaceUpload.replaceTime,
                      format: DateFormats.y_mo_d_h_m),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                        locale: DateTimePickerLocale.zh_cn,
                        pickerMode: DateTimePickerMode.datetime,
                        onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                      setState(() {
                        _standardReplaceUpload.replaceTime = dateTime;
                      });
                    });
                  },
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '更换人员',
                  controller: _standardReplaceUpload.replacePerson,
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '有效期',
                  content: DateUtil.formatDate(
                      _standardReplaceUpload.validityTime,
                      format: DateFormats.y_mo_d),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        dateFormat: 'yyyy年MM月dd日 EEE',
                        locale: DateTimePickerLocale.zh_cn,
                        pickerMode: DateTimePickerMode.datetime,
                        onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                      setState(() {
                        _standardReplaceUpload.validityTime = dateTime;
                      });
                    });
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '维护保养/核查时间',
                  content: DateUtil.formatDate(
                      _standardReplaceUpload.maintainTime,
                      format: DateFormats.y_mo_d_h_m),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                        locale: DateTimePickerLocale.zh_cn,
                        pickerMode: DateTimePickerMode.datetime,
                        onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                      setState(() {
                        _standardReplaceUpload.maintainTime = dateTime;
                      });
                    });
                  },
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '维护保养/核查人',
                  controller: _standardReplaceUpload.maintainPerson,
                ),
                Gaps.vGap5,
                // 没有附件则隐藏GridView
                Offstage(
                  offstage: _standardReplaceUpload.attachments.length == 0,
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    children: List.generate(
                      _standardReplaceUpload.attachments.length,
                      (index) {
                        Asset asset = _standardReplaceUpload.attachments[index];
                        return AssetThumb(
                          asset: asset,
                          width: 300,
                          height: 300,
                        );
                      },
                    ),
                  ),
                ),
                Gaps.vGap5,
                Row(
                  children: <Widget>[
                    ClipButton(
                      text: '选择图片',
                      icon: Icons.image,
                      color: Colors.green,
                      onTap: () async {
                        _standardReplaceUpload.attachments =
                            await SystemUtils.loadAssets(
                                _standardReplaceUpload.attachments);
                        setState(() {});
                      },
                    ),
                    Gaps.hGap20,
                    ClipButton(
                      text: '提交',
                      icon: Icons.file_upload,
                      color: Colors.lightBlue,
                      onTap: () {
                        _uploadBloc.add(Upload(data: _standardReplaceUpload));
                      },
                    ),
                  ],
                ),
                Gaps.vGap20,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
