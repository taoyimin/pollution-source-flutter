import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/inspection/param/water/device/water_device_list_model.dart';
import 'package:pollution_source/module/inspection/param/water/upload/water_device_param_upload_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';
import 'package:pollution_source/widget/git_dialog.dart';

import 'water_device_param_list_repository.dart';
import 'water_device_param_upload_repository.dart';

/// 上报仪器参数设置界面
class WaterDeviceParamUploadPage extends StatefulWidget {
  WaterDeviceParamUploadPage();

  @override
  _WaterDeviceParamUploadPageState createState() =>
      _WaterDeviceParamUploadPageState();
}

class _WaterDeviceParamUploadPageState
    extends State<WaterDeviceParamUploadPage> {
  /// 全局Key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 加载待巡检参数Bloc
  final ListBloc _listBloc = ListBloc(
    listRepository: WaterDeviceParamListRepository(),
  );

  /// 上报仪器参数设置Bloc
  final UploadBloc _uploadBloc = UploadBloc(
    uploadRepository: WaterDeviceParamUploadRepository(),
  );

  /// 废水监测设备参数巡检上报类
  final WaterDeviceParamUpload _waterDeviceParamUpload =
      WaterDeviceParamUpload();

  _WaterDeviceParamUploadPageState();

  @override
  void initState() {
    super.initState();
    // 加载待巡检参数
    _loadData();
  }

  @override
  void dispose() {
    // 释放资源
    super.dispose();
    _waterDeviceParamUpload.waterDeviceParamTypeList
        .forEach((WaterDeviceParamType waterDeviceParamType) {
      waterDeviceParamType.waterDeviceParamNameList
          .forEach((WaterDeviceParamName waterDeviceParamName) {
        waterDeviceParamName.originalVal.dispose();
        waterDeviceParamName.updateVal.dispose();
        waterDeviceParamName.modifyReason.dispose();
      });
    });
    // 取消正在进行的请求
    if (_listBloc?.state is ListLoading)
      (_listBloc?.state as ListLoading).cancelToken.cancel();
  }

  /// 加载数据
  _loadData() {
    _listBloc.add(ListLoad(isRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          UploadHeaderWidget(
            title: '上报仪器参数设置',
            subTitle: '',
            imageAlignment: Alignment.center,
            imagePath:
                'assets/images/routine_inspection_detail_header_image1.png',
            backgroundColor: Colours.primary_color,
          ),
          MultiBlocListener(
            listeners: [
              BlocListener<UploadBloc, UploadState>(
                bloc: _uploadBloc,
                listener: (context, state) {
                  if (state is Uploading) {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => GifDialog(
                        onCancelTap: () {
                          state.cancelToken?.cancel('取消上传');
                        },
                      ),
                    );
                  } else if (state is UploadSuccess) {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text('${state.message}'),
                        action: SnackBarAction(
                            label: '我知道了',
                            textColor: Colours.primary_color,
                            onPressed: () {}),
                      ),
                    );
                    Application.router.pop(context);
                  } else if (state is UploadFail) {
                    if (state.message.endsWith('（不会填写可以填入 / 代替）')) {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text('${state.message}'),
                          action: SnackBarAction(
                            label: '自动填入',
                            textColor: Colours.primary_color,
                            onPressed: () {
                              _waterDeviceParamUpload.waterDeviceParamTypeList
                                  .forEach(
                                (waterDeviceParamType) {
                                  waterDeviceParamType.waterDeviceParamNameList
                                      .forEach(
                                    (waterDeviceParamName) {
                                      if (WaterDeviceParamUploadRepository
                                          .isRequiredParam(waterDeviceParamType,
                                              _waterDeviceParamUpload.device)) {
                                        // 如果是必要参数，则自动填入/
                                        if (TextUtil.isEmpty(
                                            waterDeviceParamName
                                                .originalVal.text))
                                          waterDeviceParamName
                                              .originalVal.text = '/';
                                        if (TextUtil.isEmpty(
                                            waterDeviceParamName
                                                .updateVal.text))
                                          waterDeviceParamName.updateVal.text =
                                              '/';
                                        if (TextUtil.isEmpty(
                                            waterDeviceParamName
                                                .modifyReason.text))
                                          waterDeviceParamName
                                              .modifyReason.text = '/';
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text('${state.message}'),
                          action: SnackBarAction(
                              label: '我知道了',
                              textColor: Colours.primary_color,
                              onPressed: () {}),
                        ),
                      );
                    }
                    Application.router.pop(context);
                  }
                },
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
              BlocListener<ListBloc, ListState>(
                bloc: _listBloc,
                listener: (context, state) {
                  if (state is ListLoaded) {
                    _waterDeviceParamUpload.waterDeviceParamTypeList =
                        state.list;
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
                  _waterDeviceParamUpload.baiduLocation = baiduLocation;
                });
              },
            ),
            Gaps.hLine,
            SelectRowWidget(
              title: '企业名称',
              content: _waterDeviceParamUpload.enter?.enterName,
              onTap: () async {
                // 打开企业选择界面并等待结果返回
                Enter enter = await Application.router
                    .navigateTo(context, '${Routes.enterList}?type=1&state=1');
                if (enter != null) {
                  setState(() {
                    // 设置已经选中的企业，重置已经选中的监控点和设备
                    _waterDeviceParamUpload.enter = enter;
                    _waterDeviceParamUpload.monitor = null;
                    _waterDeviceParamUpload.device = null;
                  });
                }
              },
            ),
            Gaps.hLine,
            SelectRowWidget(
              title: '监控点名',
              content: _waterDeviceParamUpload.monitor?.monitorName,
              onTap: () async {
                if (_waterDeviceParamUpload.enter == null) {
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
                  Monitor monitor = await Application.router.navigateTo(context,
                      '${Routes.monitorList}?enterId=${_waterDeviceParamUpload.enter?.enterId}&type=2&monitorType=outletType2');
                  if (monitor != null) {
                    // 设置选中的监控点，重置已经选中的设备
                    setState(() {
                      _waterDeviceParamUpload.monitor = monitor;
                      _waterDeviceParamUpload.device = null;
                    });
                  }
                }
              },
            ),
            Gaps.hLine,
            SelectRowWidget(
              title: '设备名称',
              content: _waterDeviceParamUpload.device?.deviceName,
              onTap: () async {
                if (_waterDeviceParamUpload.enter == null) {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: const Text('请先选择企业！'),
                      action: SnackBarAction(
                          label: '我知道了',
                          textColor: Colours.primary_color,
                          onPressed: () {}),
                    ),
                  );
                } else if (_waterDeviceParamUpload.monitor == null) {
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
                  WaterDevice device = await Application.router.navigateTo(context,
                      '${Routes.waterDeviceList}?monitorId=${_waterDeviceParamUpload.monitor?.monitorId}&type=1');
                  if (device != null) {
                    // 设置选中的设备和测量原理与分析方法
                    setState(() {
                      _waterDeviceParamUpload.measurePrincipleStr =
                          device.measurePrincipleStr;
                      _waterDeviceParamUpload.analysisMethodStr =
                          device.analysisMethodStr;
                      _waterDeviceParamUpload.device = device;
                    });
                  }
                }
              },
            ),
            Gaps.hLine,
            InfoRowWidget(
              title: '测量原理',
              content:
                  TextUtil.isEmpty(_waterDeviceParamUpload.measurePrincipleStr)
                      ? '无'
                      : _waterDeviceParamUpload.measurePrincipleStr,
            ),
            Gaps.hLine,
            InfoRowWidget(
              title: '分析方法',
              content:
                  TextUtil.isEmpty(_waterDeviceParamUpload.analysisMethodStr)
                      ? '无'
                      : _waterDeviceParamUpload.analysisMethodStr,
            ),
            Gaps.hLine,
            BlocBuilder<ListBloc, ListState>(
              bloc: _listBloc,
              builder: (context, state) {
                if (state is ListInitial || state is ListLoading) {
                  return Container(height: 300, child: LoadingWidget());
                } else if (state is ListEmpty) {
                  return Container(
                    height: 300,
                    child: EmptyWidget(
                      message: '没有查询到设备的参数巡检项目',
                    ),
                  );
                } else if (state is ListError) {
                  return ColumnErrorWidget(
                    errorMessage: state.message,
                    onReloadTap: () => _loadData(),
                  );
                } else if (state is ListLoaded) {
                  return Column(
                    children: <Widget>[
                      ...(_waterDeviceParamUpload.waterDeviceParamTypeList
                          .map((waterDeviceParamType) =>
                              _buildPageParamType(waterDeviceParamType))
                          .toList()),
                      Gaps.vGap10,
                      Row(
                        children: <Widget>[
                          ClipButton(
                            text: '提交',
                            icon: Icons.file_upload,
                            color: Colors.lightBlue,
                            onTap: () {
                              _uploadBloc
                                  .add(Upload(data: _waterDeviceParamUpload));
                            },
                          ),
                        ],
                      ),
                      Gaps.vGap20,
                    ],
                  );
                } else {
                  return ColumnErrorWidget(
                    errorMessage: 'BlocBuilder监听到未知的的状态！state=$state',
                    onReloadTap: () => _loadData(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageParamType(WaterDeviceParamType waterDeviceParamType) {
    List<WaterDeviceParamType> list =
        _waterDeviceParamUpload.waterDeviceParamTypeList;
    int index = list.indexOf(waterDeviceParamType);
    if (WaterDeviceParamUploadRepository.isRequiredParam(
        waterDeviceParamType, _waterDeviceParamUpload.device)) {
      // 如果是必要参数，则显示该项目
      if (waterDeviceParamType.parameterTypeId == 902) {
        // 参数类型是试剂
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                EditWidget(
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: waterDeviceParamType.parameterType,
                  hintText: '请输入试剂名称',
                  flex: 1,
                ),
                Offstage(
                  // 如果参数类型为试剂的记录条数小于等于1，则隐藏删除按钮
                  offstage: list
                          .where((waterDeviceParamType) =>
                              waterDeviceParamType.parameterTypeId == 902)
                          .length <=
                      1,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("删除记录"),
                            content: Text("是否确定删除该项试剂？"),
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
            ..._buildParamTypeContent(waterDeviceParamType),
            ...() {
              if (waterDeviceParamType.parameterTypeId == 902 &&
                  (index + 1 >= list.length ||
                      list[index + 1].parameterTypeId != 902)) {
                // 如果已经是最后一条试剂记录，则显示添加试剂按钮
                return [
                  Gaps.vGap10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        '可以上报多项试剂',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colours.secondary_text,
                        ),
                      ),
                      Gaps.hGap10,
                      InkWell(
                        onTap: () {
                          setState(() {
                            list.insert(
                              index + 1,
                              WaterDeviceParamType(
                                parameterType: TextEditingController(),
                                parameterTypeId: list[index].parameterTypeId,
                                waterDeviceParamNameList: list[index]
                                    .waterDeviceParamNameList
                                    .map(
                                      (waterDeviceParamName) =>
                                          WaterDeviceParamName(
                                        parameterName:
                                            waterDeviceParamName.parameterName,
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
//                  _waterDeviceCheckUpload.comparisonMeasuredResultList
//                      .add(TextEditingController());
                          });
                        },
                        child: const Text(
                          '点击添加',
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
                ];
              } else {
                return [];
              }
            }()
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRowWidget(
              title: '${waterDeviceParamType.parameterType}',
              titleStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.hLine,
            ..._buildParamTypeContent(waterDeviceParamType),
          ],
        );
      }
    } else {
      // 如果是非必要参数，则隐藏该项目并清空输入值
//      waterDeviceParamType.waterDeviceParamNameList
//          .forEach((waterDeviceParamName) {
//        waterDeviceParamName.originalVal.clear();
//        waterDeviceParamName.updateVal.clear();
//        waterDeviceParamName.modifyReason.clear();
//      });
      return Gaps.empty;
    }
  }

  List<Widget> _buildParamTypeContent(
      WaterDeviceParamType waterDeviceParamType) {
    return waterDeviceParamType.waterDeviceParamNameList
            ?.asMap()
            ?.map(
              (i, WaterDeviceParamName waterDeviceParamName) => MapEntry(
                i,
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Text(waterDeviceParamName.parameterName),
                        ),
                        EditWidget(
                          keyboardType: TextInputType.number,
                          controller: waterDeviceParamName.originalVal,
                          hintText: '原始值',
                          flex: 2,
                        ),
                        EditWidget(
                          keyboardType: TextInputType.number,
                          controller: waterDeviceParamName.updateVal,
                          hintText: '修改值',
                          flex: 2,
                        ),
                        EditWidget(
                          keyboardType: TextInputType.number,
                          controller: waterDeviceParamName.modifyReason,
                          hintText: '修改原因',
                          flex: 2,
                        ),
                      ],
                    ),
                    Gaps.hLine,
                  ],
                ),
              ),
            )
            ?.values
            ?.toList() ??
        [];
  }
}
