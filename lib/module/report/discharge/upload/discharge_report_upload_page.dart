import 'package:common_utils/common_utils.dart';
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
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
import 'package:pollution_source/module/common/page/page_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/common_utils.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';
import 'package:pollution_source/module/common/dict/data_dict_widget.dart';

/// 排口异常上报界面
class DischargeReportUploadPage extends StatefulWidget {
  final String enterId;

  DischargeReportUploadPage({this.enterId});

  @override
  _DischargeReportUploadPageState createState() =>
      _DischargeReportUploadPageState();
}

class _DischargeReportUploadPageState extends State<DischargeReportUploadPage> {
  PageBloc _pageBloc;
  UploadBloc _uploadBloc;
  DataDictBloc _stopTypeBloc;
  DataDictBloc _stopAdvanceTimeBloc;
  TextEditingController _stopReasonController;
  DateTime minStartTime =
      DateTime.now().add(Duration(hours: -Constant.defaultStopAdvanceTime));

  /// 默认选中的企业，企业用户上报时，默认选中的企业为自己，无需选择
  Enter defaultEnter;

  @override
  void initState() {
    super.initState();
    // 初始化defaultEnter
    if (!TextUtil.isEmpty(widget.enterId))
      defaultEnter = Enter(enterId: int.parse(widget.enterId));
    // 初始化页面Bloc
    _pageBloc = BlocProvider.of<PageBloc>(context);
    // 加载界面
    _pageBloc.add(PageLoad(model: DischargeReportUpload(enter: defaultEnter)));
    // 初始化上报Bloc
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
    // 初始化停产类型Bloc
    _stopTypeBloc = DataDictBloc(
        dataDictRepository:
            DataDictRepository(HttpApi.dischargeReportStopType));
    // 加载停产类型
    _stopTypeBloc.add(DataDictLoad());
    _stopAdvanceTimeBloc = DataDictBloc(
        dataDictRepository:
            SystemConfigRepository(HttpApi.reportStopAdvanceTime));
    // 加载异常申报开始时间最多滞后的小时数
    _stopAdvanceTimeBloc.add(DataDictLoad());
    _stopReasonController = TextEditingController();
  }

  @override
  void dispose() {
    //释放资源
    _stopReasonController.dispose();
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
                listener: uploadListener,
              ),
              BlocListener<UploadBloc, UploadState>(
                listener: (context, state) {
                  //提交成功后重置界面
                  if (state is UploadSuccess) {
                    _stopReasonController.text = '';
                    _pageBloc.add(PageLoad(model: DischargeReportUpload()));
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

  Widget _buildPageLoadedDetail(context, DischargeReportUpload reportUpload) {
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
                      // 打开企业选择界面并等待结果返回
                      Enter enter = await Application.router
                          .navigateTo(context, '${Routes.enterList}?type=1');
                      if (enter != null) {
                        // 设置已经选中的企业，重置已经选中的监控点
                        // 使用构造方法而不用copyWith方法，因为copyWith方法默认忽略值为null的参数
                        _pageBloc.add(
                          PageLoad(
                            model: DischargeReportUpload(
                              enter: enter,
                              stopType: reportUpload?.stopType,
                              startTime: reportUpload?.startTime,
                              endTime: reportUpload?.endTime,
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
                              onPressed: () {}),
                        ),
                      );
                    } else {
                      // 打开监控点选择界面并等待返回结果
                      Monitor monitor = await Application.router.navigateTo(
                          context,
                          '${Routes.monitorList}?enterId=${reportUpload?.enter?.enterId}&type=1');
                      if (monitor != null) {
                        // 设置选中的监控点
                        _pageBloc.add(
                          PageLoad(
                            model: reportUpload.copyWith(
                              monitor: monitor,
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
                Gaps.hLine,
                DataDictWidget(
                  title: '异常类型',
                  content: reportUpload?.stopType?.name,
                  dataDictBloc: _stopTypeBloc,
                  onSelected: (DataDict result) {
                    _pageBloc.add(
                      PageLoad(
                        model: reportUpload.copyWith(stopType: result),
                      ),
                    );
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
                  title: '异常描述',
                  hintText: '请使用一句话简单概括异常的原因',
                  controller: _stopReasonController,
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
                              //enterId: widget.enterId,
                              stopReason: _stopReasonController.text,
                            )));
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
