import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/common/dict/data_dict_state.dart';
import 'package:pollution_source/module/common/dict/system/system_config_repository.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/common_utils.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';
import 'package:pollution_source/module/common/dict/data_dict_widget.dart';

import 'discharge_report_upload_repository.dart';

/// 排口异常申报上报界面
class DischargeReportUploadPage extends StatefulWidget {
  final String enterId;

  DischargeReportUploadPage({this.enterId});

  @override
  _DischargeReportUploadPageState createState() =>
      _DischargeReportUploadPageState();
}

class _DischargeReportUploadPageState extends State<DischargeReportUploadPage> {
  /// 上报Bloc
  final UploadBloc _uploadBloc = UploadBloc(
    uploadRepository: DischargeReportUploadRepository(),
  );

  /// 停产类型Bloc
  final DataDictBloc _stopTypeBloc = DataDictBloc(
    dataDictRepository: DataDictRepository(HttpApi.dischargeReportStopType),
  );

  /// 开始时间最多滞后的小时数Bloc
  final DataDictBloc _stopAdvanceTimeBloc = DataDictBloc(
    dataDictRepository: SystemConfigRepository(HttpApi.reportStopAdvanceTime),
  );

  /// 排口异常申报上报类
  final DischargeReportUpload _dischargeReportUpload = DischargeReportUpload();

  @override
  void initState() {
    super.initState();
    // 设置默认企业，企业用户上报时，默认选中的企业为自己，无需选择
    _dischargeReportUpload.enter = TextUtil.isEmpty(widget.enterId)
        ? null
        : Enter(enterId: int.parse(widget.enterId));
    // 加载停产类型
    _stopTypeBloc.add(DataDictLoad());
    // 加载异常申报开始时间最多滞后的小时数
    _stopAdvanceTimeBloc.add(DataDictLoad());
  }

  @override
  void dispose() {
    /// 释放资源
    _dischargeReportUpload.stopReason.dispose();
    if (_stopTypeBloc?.state is DataDictLoading)
      (_stopAdvanceTimeBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_stopAdvanceTimeBloc?.state is DataDictLoading)
      (_stopAdvanceTimeBloc?.state as DataDictLoading).cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          UploadHeaderWidget(
            title: '排口异常申报上报',
            subTitle: '''1、异常申报一天，起止时间写同一天；
2、异常申报两天（如2号、3号），开始写2号，结束写3号；
3、在尊重事实的情况下，尽量将预计结束时间设置大的范围； 
4、异常解决之后，可以根据实际情况申请更改实际结束时间；
5、申报证明材料加盖企业公章。''',
            imagePath: 'assets/images/discharge_report_upload_header_image.png',
            backgroundColor: Colors.lightBlueAccent,
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
                      if (widget.enterId == null)
                        _dischargeReportUpload.enter = null;
                      _dischargeReportUpload.monitor = null;
                      _dischargeReportUpload.stopType = null;
                      _dischargeReportUpload.isShutdown = true;
                      _dischargeReportUpload.startTime = null;
                      _dischargeReportUpload.endTime = null;
                      _dischargeReportUpload.stopReason.text = '';
                      _dischargeReportUpload.attachments.clear();
                    });
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
                      _dischargeReportUpload.minStartTime = DateTime.now().add(
                          Duration(hours: -int.parse(dataDictList[0].code)));
                    }
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
                Offstage(
                  offstage: widget.enterId != null,
                  child: SelectRowWidget(
                    title: '企业名称',
                    content: _dischargeReportUpload.enter?.enterName,
                    onTap: () async {
                      // 打开企业选择界面并等待结果返回
                      Enter enter = await Application.router.navigateTo(
                          context, '${Routes.enterList}?type=1&state=1');
                      if (enter != null) {
                        setState(() {
                          // 设置已经选中的企业，重置已经选中的监控点
                          _dischargeReportUpload.enter = enter;
                          _dischargeReportUpload.monitor = null;
                        });
                      }
                    },
                  ),
                ),
                widget.enterId != null ? Gaps.empty : Gaps.hLine,
                SelectRowWidget(
                  title: '监控点名',
                  content: _dischargeReportUpload.monitor?.monitorName,
                  onTap: () async {
                    if (_dischargeReportUpload.enter == null) {
                      Scaffold.of(context).showSnackBar(
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
                          '${Routes.monitorList}?enterId=${_dischargeReportUpload.enter?.enterId}&type=1');
                      if (monitor != null) {
                        // 设置选中的监控点
                        setState(() {
                          _dischargeReportUpload.monitor = monitor;
                        });
                      }
                    }
                  },
                ),
                Gaps.hLine,
                DataDictPopupMenuWidget(
                  title: '异常类型',
                  content: _dischargeReportUpload.stopType?.name,
                  dataDictBloc: _stopTypeBloc,
                  onSelected: (DataDict result) {
                    setState(() {
                      _dischargeReportUpload.stopType = result;
                    });
                  },
                ),
                Gaps.hLine,
                // 如果异常类型选择了停产，则显示是否关停设备选项
                Offstage(
                  offstage:
                      (_dischargeReportUpload.stopType?.code ?? '') != '1',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RadioRowWidget(
                        title: '是否关停设备',
                        trueText: '关停',
                        falseText: '不关停',
                        checked: _dischargeReportUpload.isShutdown,
                        onChanged: (value) {
                          setState(() {
                            _dischargeReportUpload.isShutdown = value;
                          });
                        },
                      ),
                      Gaps.hLine,
                    ],
                  ),
                ),
                SelectRowWidget(
                  title: '开始时间',
                  content: DateUtil.formatDate(_dischargeReportUpload.startTime,
                      format: DateFormats.y_mo_d_h_m),
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                      locale: DateTimePickerLocale.zh_cn,
                      pickerMode: DateTimePickerMode.datetime,
                      initialDateTime: _dischargeReportUpload.startTime,
                      minDateTime: _dischargeReportUpload.minStartTime,
                      maxDateTime: _dischargeReportUpload.endTime,
                      onClose: () {},
                      onConfirm: (dateTime, selectedIndex) {
                        setState(() {
                          _dischargeReportUpload.startTime = dateTime;
                        });
                      },
                    );
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '结束时间',
                  content: DateUtil.formatDate(_dischargeReportUpload.endTime,
                      format: DateFormats.y_mo_d_h_m),
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                      locale: DateTimePickerLocale.zh_cn,
                      pickerMode: DateTimePickerMode.datetime,
                      initialDateTime: _dischargeReportUpload.endTime,
                      minDateTime: CommonUtils.getMaxDateTime(
                          _dischargeReportUpload.startTime,
                          _dischargeReportUpload.minStartTime),
                      onClose: () {},
                      onConfirm: (dateTime, selectedIndex) {
                        setState(() {
                          _dischargeReportUpload.endTime = dateTime;
                        });
                      },
                    );
                  },
                ),
                Gaps.hLine,
                TextAreaWidget(
                  title: '异常描述',
                  hintText: '请使用一句话简单概括异常的原因',
                  controller: _dischargeReportUpload.stopReason,
                ),
                Gaps.vGap5,
                // 没有附件则隐藏GridView
                Offstage(
                  offstage: _dischargeReportUpload.attachments.length == 0,
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    children: List.generate(
                      _dischargeReportUpload.attachments.length,
                      (index) {
                        Asset asset = _dischargeReportUpload.attachments[index];
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
                        _dischargeReportUpload.attachments =
                            await SystemUtils.loadAssets(
                                _dischargeReportUpload.attachments);
                        setState(() {});
                      },
                    ),
                    Gaps.hGap20,
                    ClipButton(
                      text: '提交',
                      icon: Icons.file_upload,
                      color: Colors.lightBlue,
                      onTap: () {
                        _uploadBloc.add(Upload(data: _dischargeReportUpload));
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
