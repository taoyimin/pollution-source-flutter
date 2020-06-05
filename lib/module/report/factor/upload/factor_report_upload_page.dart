import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/common/dict/data_dict_state.dart';
import 'package:pollution_source/module/common/dict/factor/factor_data_dict_repository.dart';
import 'package:pollution_source/module/common/dict/system/system_config_repository.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
import 'package:pollution_source/module/common/page/page_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/module/report/factor/upload/factor_report_upload_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/common_utils.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

/// 因子异常上报界面
class FactorReportUploadPage extends StatefulWidget {
  final String enterId;

  FactorReportUploadPage({this.enterId});

  @override
  _FactorReportUploadPageState createState() => _FactorReportUploadPageState();
}

class _FactorReportUploadPageState extends State<FactorReportUploadPage> {
  /// 界面Bloc
  PageBloc _pageBloc;

  /// 上报Bloc
  UploadBloc _uploadBloc;

  /// 异常类型Bloc
  DataDictBloc _alarmTypeBloc = DataDictBloc(
      dataDictRepository: DataDictRepository(HttpApi.factorReportAlarmType));

  /// 异常因子Bloc
  final DataDictBloc _factorCodeBloc = DataDictBloc(
      dataDictRepository:
          FactorDataDictRepository(HttpApi.factorReportFactorList));

  /// 开始时间最多滞后的小时数Bloc
  final DataDictBloc _stopAdvanceTimeBloc = DataDictBloc(
      dataDictRepository:
          SystemConfigRepository(HttpApi.reportStopAdvanceTime));

  /// 因子异常申报异常类型为设备故障时限制时间Bloc
  final DataDictBloc _limitDayBloc = DataDictBloc(
      dataDictRepository: SystemConfigRepository(HttpApi.factorReportLimitDay));

  /// 异常原因编辑器
  final TextEditingController _exceptionReasonController =
      TextEditingController();

  /// 最小开始时间
  DateTime minStartTime =
      DateTime.now().add(Duration(hours: -Constant.defaultStopAdvanceTime));

  /// 默认限制天数
  int limitDay = 5;

  /// 默认选中的企业，企业用户上报时，默认选中的企业为自己，无需选择
  Enter defaultEnter;

  @override
  void initState() {
    super.initState();
    // 初始化defaultEnter
    if (!TextUtil.isEmpty(widget.enterId))
      defaultEnter = Enter(enterId: int.parse(widget.enterId));
    // 初始化Bloc
    _pageBloc = BlocProvider.of<PageBloc>(context);
    _pageBloc.add(PageLoad(
        model: FactorReportUpload(
            enter: defaultEnter, factorCodeList: List<DataDict>())));
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
    // 加载异常类型
    _alarmTypeBloc.add(DataDictLoad());
    // 加载异常申报开始时间最多滞后的小时数
    _stopAdvanceTimeBloc.add(DataDictLoad());
    // 加载因子异常申报异常类型为设备故障时的限制时间
    _limitDayBloc.add(DataDictLoad());
  }

  @override
  void dispose() {
    /// 释放资源
    _exceptionReasonController.dispose();
    if (_alarmTypeBloc?.state is DataDictLoading)
      (_alarmTypeBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_factorCodeBloc?.state is DataDictLoading)
      (_factorCodeBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_stopAdvanceTimeBloc?.state is DataDictLoading)
      (_stopAdvanceTimeBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_limitDayBloc?.state is DataDictLoading)
      (_limitDayBloc?.state as DataDictLoading).cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          UploadHeaderWidget(
            title: '因子异常申报上报',
            subTitle: '''1、异常申报一天，起止时间写同一天；
2、异常申报两天（如2号、3号），开始写2号，结束写3号；
3、在尊重事实的情况下，尽量将预计结束时间设置大的范围； 
4、异常解决之后，可以根据实际情况申请更改实际结束时间；
5、申报证明材料加盖企业公章。''',
            imagePath: 'assets/images/factor_report_upload_header_image.png',
            backgroundColor: Colors.deepOrangeAccent,
          ),
          MultiBlocListener(
            listeners: [
              BlocListener<UploadBloc, UploadState>(
                listener: uploadListener,
              ),
              BlocListener<UploadBloc, UploadState>(
                listener: (context, state) {
                  if (state is UploadSuccess) {
                    //提交成功后重置界面
                    _exceptionReasonController.text = '';
                    _pageBloc.add(PageLoad(
                      model: FactorReportUpload(
                        alarmTypeList: List<DataDict>(),
                        factorCodeList: List<DataDict>(),
                      ),
                    ));
                    // 将异常类型选择控件的状态重置为初始状态
                    _alarmTypeBloc.add(DataDictReset());
                    // 将异常因子选择控件的状态重置为初始状态
                    _factorCodeBloc.add(DataDictReset());
                  }
                },
              ),
              BlocListener<DataDictBloc, DataDictState>(
                bloc: _stopAdvanceTimeBloc,
                listener: (context, state) {
                  if (state is DataDictLoaded) {
                    List<DataDict> dataDictList =
                        (_stopAdvanceTimeBloc?.state as DataDictLoaded)
                            .dataDictList;
                    if (dataDictList.length != 0) {
                      // 设置最小开始时间
                      minStartTime = DateTime.now().add(
                          Duration(hours: -int.parse(dataDictList[0].code)));
                    }
                  }
                },
              ),
              BlocListener<DataDictBloc, DataDictState>(
                bloc: _limitDayBloc,
                listener: (context, state) {
                  if (state is DataDictLoaded) {
                    List<DataDict> dataDictList =
                        (_limitDayBloc?.state as DataDictLoaded).dataDictList;
                    if (dataDictList.length != 0) {
                      // 设置限制时间
                      limitDay = int.parse(dataDictList[0].code);
                    }
                  }
                },
              ),
            ],
            child: BlocBuilder<PageBloc, PageState>(
              builder: (context, state) {
                if (state is PageLoaded) {
                  return _buildPageLoadedDetail(context, state.model);
                } else {
                  return ErrorSliver(
                    errorMessage: 'BlocBuilder监听到未知的的状态！state=$state',
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(context, FactorReportUpload reportUpload) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                Offstage(
                  offstage: widget.enterId != null,
                  child: SelectRowWidget(
                    title: '企业名称',
                    content: reportUpload?.enter?.enterName,
                    onTap: () async {
                      // 打开排口选择界面并等待结果返回
                      Enter enter = await Application.router.navigateTo(
                          context, '${Routes.enterList}?type=1&state=1');
                      if (enter != null) {
                        // 设置已经选中的企业，重置已经选中的排口和监控点
                        // 使用构造方法而不用copyWith方法，因为copyWith方法默认忽略值为null的参数
                        _pageBloc.add(
                          PageLoad(
                            model: FactorReportUpload(
                              enter: enter,
                              alarmTypeList: reportUpload?.alarmTypeList,
                              startTime: reportUpload?.startTime,
                              endTime: reportUpload?.endTime,
                              factorCodeList: List<DataDict>(),
                              attachments: reportUpload?.attachments,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                widget.enterId != null ? Gaps.empty : Gaps.hLine,
                SelectRowWidget(
                  title: '监控点名',
                  content: reportUpload?.monitor?.monitorName,
                  onTap: () async {
                    if (reportUpload?.enter == null) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('请先选择企业！'),
                          action: SnackBarAction(
                            label: '我知道了',
                            textColor: Colours.primary_color,
                            onPressed: () {},
                          ),
                        ),
                      );
                    } else {
                      // 打开监控点选择界面并等待返回结果
                      Monitor monitor = await Application.router.navigateTo(
                          context,
                          '${Routes.monitorList}?enterId=${reportUpload?.enter?.enterId}&type=1');
                      if (monitor != null) {
                        // 设置选中的监控点，重置已经选中的异常因子
                        _pageBloc.add(
                          PageLoad(
                            model: reportUpload.copyWith(
                              monitor: monitor,
                              factorCodeList: <DataDict>[],
                            ),
                          ),
                        );
                        // 选择完监控点后根据监控点类型加载异常因子
                        // 运维系统用monitorId查，污染源系统用monitorType查
                        _factorCodeBloc.add(DataDictLoad(params: {
                          'monitorType': monitor.monitorType,
                          'monitorId': monitor.monitorId
                        }));
                      }
                    }
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '异常类型',
                  content: reportUpload?.alarmTypeList
                      ?.map((dataDict) => dataDict.name)
                      ?.join(','),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      elevation: 20,
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) {
                        return BlocBuilder<DataDictBloc, DataDictState>(
                          bloc: _alarmTypeBloc,
                          builder: (context, state) {
                            if (state is DataDictLoaded) {
                              return _buildBottomSheet(
                                dataDictList: state.dataDictList,
                                onItemTap: (dataDict) {
                                  if (dataDict.code == 'fault') {
                                    // 点击了设备故障
                                    if (!dataDict.checked) {
                                      // 当前操作是选中
                                      if (state.dataDictList.where((dataDict) {
                                            return dataDict.checked;
                                          }).length >
                                          0) {
                                        Toast.show(
                                            '当选中其他异常类型时，不能再选中${dataDict.name}');
                                        return;
                                      }
                                    }
                                  } else {
                                    // 点击了除设备故障之外的异常类型
                                    if (!dataDict.checked) {
                                      // 当前操作是选中
                                      DataDict faultDataDict = state
                                          .dataDictList
                                          .firstWhere((dataDict) {
                                        return dataDict.checked &&
                                            dataDict.code == 'fault';
                                      }, orElse: () {
                                        return null;
                                      });
                                      if (faultDataDict != null) {
                                        Toast.show(
                                            '当选中${faultDataDict.name}时，不能再选中其他异常类型');
                                        return;
                                      }
                                    }
                                  }
                                  state.dataDictList[state.dataDictList
                                          .indexOf(dataDict)] =
                                      dataDict.copyWith(
                                          checked: !dataDict.checked);
                                  _alarmTypeBloc.add(DataDictUpdate(
                                      dataDictList: state.dataDictList,
                                      timeStamp: DateTime.now()
                                          .millisecondsSinceEpoch));
                                  _pageBloc.add(
                                    PageLoad(
                                      model: reportUpload.copyWith(
                                          alarmTypeList: state.dataDictList
                                              .where((dataDict) {
                                        return dataDict.checked;
                                      }).toList()),
                                    ),
                                  );
                                },
                                onResetTap: () {
                                  _alarmTypeBloc.add(DataDictUpdate(
                                    dataDictList:
                                        state.dataDictList.map((dataDict) {
                                      return dataDict.copyWith(checked: false);
                                    }).toList(),
                                    timeStamp:
                                        DateTime.now().millisecondsSinceEpoch,
                                  ));
                                  _pageBloc.add(
                                    PageLoad(
                                      model: reportUpload
                                          .copyWith(alarmTypeList: []),
                                    ),
                                  );
                                },
                              );
                            } else if (state is DataDictLoading) {
                              return _buildLoadingBottomSheet();
                            } else if (state is DataDictError) {
                              return _buildErrorBottomSheet(
                                message: state.message,
                                tip: '异常类型加载失败，请重试！',
                                onReLoadTap: () {
                                  // 重新加载
                                  _alarmTypeBloc.add(DataDictLoad());
                                },
                              );
                            } else {
                              return MessageWidget(
                                  message: 'BlocBuilder监听到未知的的状态！state=$state');
                            }
                          },
                        );
                      },
                    );
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '异常因子',
                  content: reportUpload?.factorCodeList
                      ?.map((dataDict) => dataDict.name)
                      ?.join(','),
                  onTap: () {
                    if (reportUpload?.monitor == null) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('请先选择监控点！'),
                          action: SnackBarAction(
                            label: '我知道了',
                            textColor: Colours.primary_color,
                            onPressed: () {},
                          ),
                        ),
                      );
                    } else {
                      //打开BottomSheet
                      showModalBottomSheet(
                        context: context,
                        elevation: 20,
                        backgroundColor: Colors.white,
                        builder: (BuildContext context) {
                          return BlocBuilder<DataDictBloc, DataDictState>(
                            bloc: _factorCodeBloc,
                            builder: (context, state) {
                              if (state is DataDictLoaded) {
                                return _buildBottomSheet(
                                  dataDictList: state.dataDictList,
                                  onItemTap: (dataDict) {
                                    state.dataDictList[state.dataDictList
                                            .indexOf(dataDict)] =
                                        dataDict.copyWith(
                                            checked: !dataDict.checked);
                                    _factorCodeBloc.add(DataDictUpdate(
                                        dataDictList: state.dataDictList,
                                        timeStamp: DateTime.now()
                                            .millisecondsSinceEpoch));
                                    _pageBloc.add(
                                      PageLoad(
                                        model: reportUpload.copyWith(
                                            factorCodeList: state.dataDictList
                                                .where((dataDict) {
                                          return dataDict.checked;
                                        }).toList()),
                                      ),
                                    );
                                  },
                                  onResetTap: () {
                                    _factorCodeBloc.add(DataDictUpdate(
                                      dataDictList:
                                          state.dataDictList.map((dataDict) {
                                        return dataDict.copyWith(
                                            checked: false);
                                      }).toList(),
                                      timeStamp:
                                          DateTime.now().millisecondsSinceEpoch,
                                    ));
                                    _pageBloc.add(
                                      PageLoad(
                                        model: reportUpload
                                            .copyWith(factorCodeList: []),
                                      ),
                                    );
                                  },
                                );
                              } else if (state is DataDictLoading) {
                                return _buildLoadingBottomSheet();
                              } else if (state is DataDictError) {
                                return _buildErrorBottomSheet(
                                  message: state.message,
                                  tip: '异常因子加载失败，请重试！',
                                  onReLoadTap: () {
                                    // 运维系统用monitorId查，污染源系统用monitorType查
                                    _factorCodeBloc.add(DataDictLoad(params: {
                                      'monitorType':
                                          reportUpload.monitor.monitorType,
                                      'monitorId':
                                          reportUpload.monitor.monitorId
                                    }));
                                  },
                                );
                              } else {
                                return MessageWidget(
                                    message:
                                        'BlocBuilder监听到未知的的状态！state=$state');
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '开始时间',
                  content: DateUtil.formatDate(reportUpload?.startTime,
                      format: 'yyyy-MM-dd HH:mm'),
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                      locale: DateTimePickerLocale.zh_cn,
                      pickerMode: DateTimePickerMode.datetime,
                      initialDateTime: reportUpload?.startTime,
                      minDateTime: minStartTime,
                      maxDateTime: reportUpload?.endTime,
                      onClose: () {},
                      onConfirm: (dateTime, selectedIndex) {
                        _pageBloc.add(
                          PageLoad(
                            model: reportUpload.copyWith(startTime: dateTime),
                          ),
                        );
                      },
                    );
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '结束时间',
                  content: DateUtil.formatDate(reportUpload?.endTime,
                      format: 'yyyy-MM-dd HH:mm'),
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                      locale: DateTimePickerLocale.zh_cn,
                      pickerMode: DateTimePickerMode.datetime,
                      initialDateTime: reportUpload?.endTime,
                      minDateTime: CommonUtils.getMaxDateTime(
                          reportUpload?.startTime, minStartTime),
                      onClose: () {},
                      onConfirm: (dateTime, selectedIndex) {
                        _pageBloc.add(
                          PageLoad(
                            model: reportUpload.copyWith(endTime: dateTime),
                          ),
                        );
                      },
                    );
                  },
                ),
                Gaps.hLine,
                TextAreaWidget(
                  title: '申报异常原因',
                  hintText: '请使用一句话简单概括发生异常的原因',
                  controller: _exceptionReasonController,
                ),
                Gaps.vGap5,
                // 没有附件则隐藏GridView
                Offstage(
                  offstage: reportUpload?.attachments == null ||
                      reportUpload.attachments.length == 0,
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    children: List.generate(
                      reportUpload?.attachments == null
                          ? 0
                          : reportUpload.attachments.length,
                      (index) {
                        Asset asset = reportUpload.attachments[index];
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
                        _pageBloc.add(
                          PageLoad(
                            model: reportUpload.copyWith(
                              attachments: await SystemUtils.loadAssets(
                                reportUpload.attachments,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Gaps.hGap20,
                    ClipButton(
                      text: '提交',
                      icon: Icons.file_upload,
                      color: Colors.lightBlue,
                      onTap: () {
                        _uploadBloc.add(
                          Upload(
                            data: reportUpload.copyWith(
                              limitDay: limitDay,
                              exceptionReason: _exceptionReasonController.text,
                            ),
                          ),
                        );
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

  Widget _buildBottomSheet({
    FactorReportUpload reportUpload,
    List<DataDict> dataDictList,
    BottomSheetItemTap onItemTap,
    GestureTapCallback onResetTap,
  }) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Gaps.hGap10,
              GestureDetector(
                onTap: onResetTap,
                child: const Text(
                  '重置',
                  style: TextStyle(
                    color: Colours.secondary_text,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(child: Gaps.empty),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '确定',
                  style: TextStyle(
                    color: Colours.primary_color,
                    fontSize: 16,
                  ),
                ),
              ),
              Gaps.hGap10,
            ],
          ),
          Gaps.vGap16,
          Wrap(
            runSpacing: 8,
            spacing: 8,
            children: dataDictList.map((dataDict) {
              return InkWell(
                onTap: () {
                  onItemTap(dataDict);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: dataDict.checked
                          ? Colours.primary_color
                          : Colours.divider_color,
                    ),
                    color: dataDict.checked
                        ? Colours.primary_color.withOpacity(0.3)
                        : Colours.divider_color,
                  ),
                  child: Text(
                    dataDict.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: dataDict.checked
                          ? Colours.primary_color
                          : Colours.secondary_text,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBottomSheet() {
    return Container(
      height: 260,
      color: Colors.white,
      child: Center(
        child: SizedBox(
          height: 200.0,
          width: 300.0,
          child: Card(
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50.0,
                  height: 50.0,
                  child: SpinKitFadingCube(
                    color: Theme.of(context).primaryColor,
                    size: 25.0,
                  ),
                ),
                Container(
                  child: Text('加载中'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBottomSheet({
    String message,
    String tip = '加载失败，请重试！',
    GestureTapCallback onReLoadTap,
  }) {
    return Container(
      height: 260,
      padding: EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            'assets/images/image_load_error.png',
            height: 100,
          ),
          Text(
            '$tip',
            style: const TextStyle(fontSize: 14),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("错误信息"),
                          content: SingleChildScrollView(
                            child: Text('$message'),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: '$message'));
                                Toast.show('复制到剪贴板成功！');
                                Navigator.of(context).pop();
                              },
                              child: const Text("复制"),
                            ),
                            FlatButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              child: const Text("确认"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 36,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: Colors.red,
                      ),
                      color: Colors.red.withOpacity(0.3),
                    ),
                    child: const Center(
                      child: Text(
                        '错误详情',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Gaps.hGap16,
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: onReLoadTap,
                  child: Container(
                    height: 36,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: Colors.green,
                      ),
                      color: Colors.green.withOpacity(0.3),
                    ),
                    child: const Center(
                      child: Text(
                        '重新加载',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

typedef BottomSheetItemTap = void Function(DataDict value);
