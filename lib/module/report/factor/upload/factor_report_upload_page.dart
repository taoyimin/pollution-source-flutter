import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/common/dict/data_dict_state.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
import 'package:pollution_source/module/common/page/page_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/module/report/factor/upload/factor_data_dict_repository.dart';
import 'package:pollution_source/module/report/factor/upload/factor_report_upload_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';
import 'package:pollution_source/module/common/dict/data_dict_widget.dart';

class FactorReportUploadPage extends StatefulWidget {
  final String enterId;

  FactorReportUploadPage({this.enterId});

  @override
  _FactorReportUploadPageState createState() => _FactorReportUploadPageState();
}

class _FactorReportUploadPageState extends State<FactorReportUploadPage> {
  PageBloc _pageBloc;
  UploadBloc _uploadBloc;
  DataDictBloc _alarmTypeBloc;
  DataDictBloc _factorCodeBloc;
  TextEditingController _exceptionReasonController;

  /// 默认选中的企业，企业用户上报时，默认选中的企业为自己，无需选择
  Enter defaultEnter;

  @override
  void initState() {
    super.initState();
    // 初始化defaultEnter
    if (!TextUtil.isEmpty(widget.enterId))
      defaultEnter = Enter(enterId: int.parse(widget.enterId));
    //初始化Bloc
    _pageBloc = BlocProvider.of<PageBloc>(context);
    _pageBloc.add(PageLoad(
        model: FactorReportUpload(
            enter: defaultEnter, factorCode: List<DataDict>())));
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
    //初始化异常类型Bloc
    _alarmTypeBloc = DataDictBloc(
        dataDictRepository:
            DataDictRepository(HttpApi.factorReportAlarmTypeList));
    //加载异常类型
    _alarmTypeBloc.add(DataDictLoad());
    //初始化异常因子Bloc
    _factorCodeBloc = DataDictBloc(
        dataDictRepository:
            FactorDataDictRepository(HttpApi.factorReportFactorList));
    _exceptionReasonController = TextEditingController();
  }

  @override
  void dispose() {
    //释放资源
    _exceptionReasonController.dispose();
    if (_alarmTypeBloc?.state is DataDictLoading)
      (_alarmTypeBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_factorCodeBloc?.state is DataDictLoading)
      (_factorCodeBloc?.state as DataDictLoading).cancelToken.cancel();
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
                        model:
                            FactorReportUpload(factorCode: List<DataDict>())));
                    // 将异常因子选择控件的状态重置为初始状态
                    _factorCodeBloc.add(DataDictReset());
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
                      errorMessage: 'BlocBuilder监听到未知的的状态！state=$state');
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
                      Enter enter = await Application.router
                          .navigateTo(context, '${Routes.enterList}?type=1');
                      if (enter != null) {
                        // 设置已经选中的企业，重置已经选中的排口和监控点
                        // 使用构造方法而不用copyWith方法，因为copyWith方法默认忽略值为null的参数
                        _pageBloc.add(
                          PageLoad(
                            model: FactorReportUpload(
                              enter: enter,
                              alarmType: reportUpload?.alarmType,
                              startTime: reportUpload?.startTime,
                              endTime: reportUpload?.endTime,
                              factorCode: List<DataDict>(),
                              attachments: reportUpload?.attachments,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                widget.enterId != null ? Gaps.empty : Gaps.hLine,
//                SelectRowWidget(
//                  title: '排口名称',
//                  content: reportUpload?.discharge?.dischargeName,
//                  onTap: () async {
//                    if (reportUpload?.enter == null) {
//                      Scaffold.of(context).showSnackBar(
//                        SnackBar(
//                          content: const Text('请先选择企业！'),
//                          action: SnackBarAction(
//                              label: '我知道了',
//                              textColor: Colours.primary_color,
//                              onPressed: () {}),
//                        ),
//                      );
//                    } else {
//                      // 打开排口选择界面并等待结果返回
//                      Discharge discharge = await Application.router.navigateTo(
//                          context,
//                          '${Routes.dischargeList}?enterId=${reportUpload?.enter?.enterId}&type=1');
//                      if (discharge != null) {
//                        // 设置已经选中的排口，重置已经选中的监控点，和异常因子
//                        // 使用构造方法而不用copyWith方法，因为copyWith方法默认忽略值为null的参数
//                        _pageBloc.add(
//                          PageLoad(
//                            model: FactorReportUpload(
//                              enter: reportUpload?.enter,
//                              discharge: discharge,
//                              alarmType: reportUpload?.alarmType,
//                              startTime: reportUpload?.startTime,
//                              endTime: reportUpload?.endTime,
//                              factorCode: List<DataDict>(),
//                              attachments: reportUpload?.attachments,
//                            ),
//                          ),
//                        );
//                        // 将异常因子选择控件的状态重置为初始状态
//                        _factorCodeBloc.add(DataDictReset());
//                      }
//                    }
//                  },
//                ),
//                Gaps.hLine,
                SelectRowWidget(
                  title: '监控点名',
                  content: reportUpload?.monitor?.monitorName,
                  onTap: () async {
                    if (reportUpload?.enter == null) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('请先选择排口！'),
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
                          '${Routes.monitorList}?enterId=${reportUpload?.enter?.enterId}&type=1');
                      if (monitor != null) {
                        // 设置选中的监控点，重置已经选中的异常因子
                        _pageBloc.add(
                          PageLoad(
                            model: reportUpload.copyWith(
                              monitor: monitor,
                              factorCode: <DataDict>[],
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
                DataDictWidget(
                  title: '异常类型',
                  content: reportUpload?.alarmType?.name,
                  dataDictBloc: _alarmTypeBloc,
                  onSelected: (DataDict result) {
                    _pageBloc.add(
                      PageLoad(
                        model: reportUpload.copyWith(alarmType: result),
                      ),
                    );
                  },
                ),
                Gaps.hLine,
                DataDictMultiWidget(
                  title: '异常因子',
                  tipText: '请先选择监控点',
                  content: reportUpload?.factorCode
                      ?.map((dataDict) => dataDict.name)
                      ?.join(','),
                  dataDictBloc: _factorCodeBloc,
                  selected: reportUpload?.factorCode,
                  onSelected: (DataDict dataDict) {
                    // 如果集合中已有则删除，如果没有则添加
                    if (reportUpload.factorCode.contains(dataDict))
                      reportUpload.factorCode.remove(dataDict);
                    else
                      reportUpload.factorCode.add(dataDict);
                    _pageBloc.add(
                      PageLoad(
                        model: reportUpload.copyWith(
                            factorCode: reportUpload.factorCode),
                      ),
                    );
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '开始时间',
                  content: DateUtil.formatDate(reportUpload?.startTime,
                      format: 'yyyy-MM-dd HH:mm:ss'),
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      locale: DateTimePickerLocale.zh_cn,
                      pickerMode: DateTimePickerMode.datetime,
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
                      format: 'yyyy-MM-dd HH:mm:ss'),
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      locale: DateTimePickerLocale.zh_cn,
                      pickerMode: DateTimePickerMode.datetime,
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
              ],
            ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
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
                              reportUpload.attachments),
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
                    _uploadBloc.add(Upload(
                        data: reportUpload.copyWith(
                      exceptionReason: _exceptionReasonController.text,
                    )));
                  },
                ),
              ],
            ),
          ),
          Gaps.vGap20,
        ],
      ),
    );
  }
}
