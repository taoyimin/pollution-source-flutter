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

import 'consumable_replace_upload_model.dart';
import 'consumable_replace_upload_repository.dart';

/// 易耗品更换上报界面
class ConsumableReplaceUploadPage extends StatefulWidget {
  ConsumableReplaceUploadPage();

  @override
  _ConsumableReplaceUploadPageState createState() =>
      _ConsumableReplaceUploadPageState();
}

class _ConsumableReplaceUploadPageState
    extends State<ConsumableReplaceUploadPage> {
  /// 全局Key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 上报Bloc
  final UploadBloc _uploadBloc = UploadBloc(
    uploadRepository: ConsumableReplaceUploadRepository(),
  );

  /// 易耗品更换上报类
  final ConsumableReplaceUpload _consumableReplaceUpload =
      ConsumableReplaceUpload();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    /// 释放资源
    _consumableReplaceUpload.consumableName.dispose();
    _consumableReplaceUpload.specificationType.dispose();
    _consumableReplaceUpload.amount.dispose();
    _consumableReplaceUpload.unit.dispose();
    _consumableReplaceUpload.maintainPerson.dispose();
    _consumableReplaceUpload.replaceRemark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('易耗品更换上报'),
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
                      _consumableReplaceUpload.enter = null;
                      _consumableReplaceUpload.monitor = null;
                      _consumableReplaceUpload.device = null;
                      _consumableReplaceUpload.consumableName.text = '';
                      _consumableReplaceUpload.specificationType.text = '';
                      _consumableReplaceUpload.validityTime = null;
                      _consumableReplaceUpload.replaceTime = null;
                      _consumableReplaceUpload.amount.text = '';
                      _consumableReplaceUpload.unit.text = '';
                      _consumableReplaceUpload.maintainPerson.text = '';
                      _consumableReplaceUpload.maintainTime = null;
                      _consumableReplaceUpload.replaceRemark.text = '';
                      _consumableReplaceUpload.attachments.clear();
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
                      _consumableReplaceUpload.baiduLocation = baiduLocation;
                    });
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '企业名称',
                  content: _consumableReplaceUpload.enter?.enterName,
                  onTap: () async {
                    // 打开企业选择界面并等待结果返回
                    Enter enter = await Application.router.navigateTo(
                        context, '${Routes.enterList}?type=1&state=1');
                    if (enter != null) {
                      setState(() {
                        // 设置已经选中的企业，重置已经选中的监控点和设备
                        _consumableReplaceUpload.enter = enter;
                        _consumableReplaceUpload.monitor = null;
                        _consumableReplaceUpload.device = null;
                        _consumableReplaceUpload.specificationType.text = '';
                      });
                    }
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '监控点名',
                  content: _consumableReplaceUpload.monitor?.monitorName,
                  onTap: () async {
                    if (_consumableReplaceUpload.enter == null) {
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
                          '${Routes.monitorList}?enterId=${_consumableReplaceUpload.enter?.enterId}&type=1');
                      if (monitor != null) {
                        // 设置选中的监控点，重置已经选中的设备
                        setState(() {
                          _consumableReplaceUpload.monitor = monitor;
                          _consumableReplaceUpload.device = null;
                          _consumableReplaceUpload.specificationType.text = '';
                        });
                      }
                    }
                  },
                ),
                Gaps.hLine,
                Offstage(
                  offstage: _consumableReplaceUpload.monitor?.monitorType != 'outletType2',
                  child: SelectRowWidget(
                    title: '设备名称',
                    content: _consumableReplaceUpload.device?.deviceName,
                    onTap: () async {
                      if (_consumableReplaceUpload.enter == null) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: const Text('请先选择企业！'),
                            action: SnackBarAction(
                                label: '我知道了',
                                textColor: Colours.primary_color,
                                onPressed: () {}),
                          ),
                        );
                      } else if (_consumableReplaceUpload.monitor == null) {
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
                            '${Routes.deviceList}?monitorId=${_consumableReplaceUpload.monitor?.monitorId}&type=1');
                        if (device != null) {
                          // 设置选中的设备和规格型号
                          setState(() {
                            _consumableReplaceUpload.device = device;
                            _consumableReplaceUpload.specificationType.text =
                                device.deviceNo;
                          });
                        }
                      }
                    },
                  ),
                ),
                _consumableReplaceUpload.monitor?.monitorType != 'outletType2' ? Gaps.empty : Gaps.hLine,
                EditRowWidget(
                  title: '规格型号',
                  controller: _consumableReplaceUpload.specificationType,
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '易耗品名称',
                  controller: _consumableReplaceUpload.consumableName,
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '有效期',
                  content: DateUtil.formatDate(
                      _consumableReplaceUpload.validityTime,
                      format: DateFormats.y_mo_d),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        dateFormat: 'yyyy年MM月dd日 EEE',
                        locale: DateTimePickerLocale.zh_cn,
                        pickerMode: DateTimePickerMode.datetime,
                        onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                      setState(() {
                        _consumableReplaceUpload.validityTime = dateTime;
                      });
                    });
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '更换日期',
                  content: DateUtil.formatDate(
                      _consumableReplaceUpload.replaceTime,
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
                          _consumableReplaceUpload.replaceTime = dateTime;
                        });
                      },
                    );
                  },
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '数量',
                  keyboardType: TextInputType.number,
                  controller: _consumableReplaceUpload.amount,
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '计量单位',
                  controller: _consumableReplaceUpload.unit,
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '维护保养/核查人',
                  controller: _consumableReplaceUpload.maintainPerson,
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '维护保养/核查时间',
                  content: DateUtil.formatDate(
                      _consumableReplaceUpload.maintainTime,
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
                          _consumableReplaceUpload.maintainTime = dateTime;
                        });
                      },
                    );
                  },
                ),
                Gaps.hLine,
                TextAreaWidget(
                  title: '更换原因说明',
                  controller: _consumableReplaceUpload.replaceRemark,
                ),
                Gaps.vGap5,
                // 没有附件则隐藏GridView
                Offstage(
                  offstage: _consumableReplaceUpload.attachments.length == 0,
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    children: List.generate(
                      _consumableReplaceUpload.attachments.length,
                      (index) {
                        Asset asset =
                            _consumableReplaceUpload.attachments[index];
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
                        _consumableReplaceUpload.attachments =
                            await SystemUtils.loadAssets(
                                _consumableReplaceUpload.attachments);
                        setState(() {});
                      },
                    ),
                    Gaps.hGap20,
                    ClipButton(
                      text: '提交',
                      icon: Icons.file_upload,
                      color: Colors.lightBlue,
                      onTap: () {
                        _uploadBloc.add(Upload(data: _consumableReplaceUpload));
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
