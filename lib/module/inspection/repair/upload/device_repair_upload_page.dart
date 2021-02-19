import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
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

import 'device_repair_upload_model.dart';
import 'device_repair_upload_repository.dart';

/// 设备检修上报界面
class DeviceRepairUploadPage extends StatefulWidget {
  DeviceRepairUploadPage();

  @override
  _DeviceRepairUploadPageState createState() => _DeviceRepairUploadPageState();
}

class _DeviceRepairUploadPageState extends State<DeviceRepairUploadPage> {
  /// 全局Key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 上报Bloc
  final UploadBloc _uploadBloc = UploadBloc(
    uploadRepository: DeviceRepairUploadRepository(),
  );

  /// 设备检修上报类
  final DeviceRepairUpload _deviceRepairUpload = DeviceRepairUpload();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    /// 释放资源
    _deviceRepairUpload.faultEquipmentName.dispose();
    _deviceRepairUpload.faultRemark.dispose();
    _deviceRepairUpload.replacePart.dispose();
    _deviceRepairUpload.overhaulRemark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('设备检修上报'),
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
                      _deviceRepairUpload.enter = null;
                      _deviceRepairUpload.monitor = null;
                      _deviceRepairUpload.device = null;
                      _deviceRepairUpload.faultEquipmentName.text = '';
                      _deviceRepairUpload.faultTime = null;
                      _deviceRepairUpload.workTime = null;
                      _deviceRepairUpload.faultRemark.text = '';
                      _deviceRepairUpload.replacePart.text = '';
                      _deviceRepairUpload.overhaulRemark.text = '';
                      _deviceRepairUpload.attachments.clear();
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
                      _deviceRepairUpload.baiduLocation = baiduLocation;
                    });
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '企业名称',
                  content: _deviceRepairUpload.enter?.enterName,
                  onTap: () async {
                    // 打开企业选择界面并等待结果返回
                    Enter enter = await Application.router.navigateTo(
                        context, '${Routes.enterList}?type=1&state=1');
                    if (enter != null) {
                      setState(() {
                        // 设置已经选中的企业，重置已经选中的监控点和设备
                        _deviceRepairUpload.enter = enter;
                        _deviceRepairUpload.monitor = null;
                        _deviceRepairUpload.device = null;
                        _deviceRepairUpload.faultEquipmentName.text = '';
                      });
                    }
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '监控点名',
                  content: _deviceRepairUpload.monitor?.monitorName,
                  onTap: () async {
                    if (_deviceRepairUpload.enter == null) {
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
                          '${Routes.monitorList}?enterId=${_deviceRepairUpload.enter?.enterId}&type=1');
                      if (monitor != null) {
                        // 设置选中的监控点，重置已经选中的设备
                        setState(() {
                          _deviceRepairUpload.monitor = monitor;
                          _deviceRepairUpload.device = null;
                          _deviceRepairUpload.faultEquipmentName.text = '';
                        });
                      }
                    }
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '设备名称',
                  content: _deviceRepairUpload.device?.deviceName,
                  onTap: () async {
                    if (_deviceRepairUpload.enter == null) {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: const Text('请先选择企业！'),
                          action: SnackBarAction(
                              label: '我知道了',
                              textColor: Colours.primary_color,
                              onPressed: () {}),
                        ),
                      );
                    } else if (_deviceRepairUpload.monitor == null) {
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
                          '${Routes.deviceList}?monitorId=${_deviceRepairUpload.monitor?.monitorId}&type=1');
                      if (device != null) {
                        // 设置选中的设备和规格型号
                        setState(() {
                          _deviceRepairUpload.device = device;
                          _deviceRepairUpload.faultEquipmentName.text =
                              device.deviceName;
                        });
                      }
                    }
                  },
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '故障设备名称',
                  controller: _deviceRepairUpload.faultEquipmentName,
                ),
                Gaps.hLine,
                InfoRowWidget(
                  title: '设备编码',
                  content: _deviceRepairUpload.device?.deviceNo ?? '无',
                ),
                Gaps.hLine,
                InfoRowWidget(
                  title: '生产厂商',
                  content: _deviceRepairUpload.device?.markerName ?? '无',
                ),
                Gaps.hLine,
                InfoRowWidget(
                  title: '客服热线',
                  content: _deviceRepairUpload.device?.markerHotLine ?? '无',
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '故障发生时间',
                  content: DateUtil.formatDate(_deviceRepairUpload.faultTime,
                      format: DateFormats.y_mo_d_h_m),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                        locale: DateTimePickerLocale.zh_cn,
                        pickerMode: DateTimePickerMode.datetime,
                        onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                      setState(() {
                        _deviceRepairUpload.faultTime = dateTime;
                      });
                    });
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '恢复正常时间',
                  content: DateUtil.formatDate(_deviceRepairUpload.workTime,
                      format: DateFormats.y_mo_d_h_m),
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                      locale: DateTimePickerLocale.zh_cn,
                      pickerMode: DateTimePickerMode.datetime,
                      onClose: () {},
                      onConfirm: (dateTime, selectedIndex) {
                        setState(() {
                          _deviceRepairUpload.workTime = dateTime;
                        });
                      },
                    );
                  },
                ),
                Gaps.hLine,
                TextAreaWidget(
                  title: '故障情况描述',
                  controller: _deviceRepairUpload.faultRemark,
                ),
                Gaps.hLine,
                TextAreaWidget(
                  title: '更换部件',
                  controller: _deviceRepairUpload.replacePart,
                ),
                Gaps.hLine,
                TextAreaWidget(
                  title: '检修情况总结',
                  controller: _deviceRepairUpload.overhaulRemark,
                ),
                Gaps.vGap5,
                // 没有附件则隐藏GridView
                Offstage(
                  offstage: _deviceRepairUpload.attachments.length == 0,
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    children: List.generate(
                      _deviceRepairUpload.attachments.length,
                      (index) {
                        Asset asset = _deviceRepairUpload.attachments[index];
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
                        _deviceRepairUpload.attachments =
                            await SystemUtils.loadAssets(
                                _deviceRepairUpload.attachments);
                        setState(() {});
                      },
                    ),
                    Gaps.hGap20,
                    ClipButton(
                      text: '提交',
                      icon: Icons.file_upload,
                      color: Colors.lightBlue,
                      onTap: () {
                        _uploadBloc.add(Upload(data: _deviceRepairUpload));
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
