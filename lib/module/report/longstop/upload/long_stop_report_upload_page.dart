import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/config/system_config_bloc.dart';
import 'package:pollution_source/module/common/config/system_config_event.dart';
import 'package:pollution_source/module/common/config/system_config_repository.dart';
import 'package:pollution_source/module/common/config/system_config_state.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
import 'package:pollution_source/module/common/page/page_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/report/longstop/upload/long_stop_report_upload_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

class LongStopReportUploadPage extends StatefulWidget {
  final String enterId;

  LongStopReportUploadPage({this.enterId});

  @override
  _LongStopReportUploadPageState createState() =>
      _LongStopReportUploadPageState();
}

class _LongStopReportUploadPageState extends State<LongStopReportUploadPage> {
  PageBloc _pageBloc;
  UploadBloc _uploadBloc;
  SystemConfigBloc _stopAdvanceTimeBloc;
  TextEditingController _remarkController;
  DateTime minStartTime = DateTime.now().add(Duration(hours: -48));

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
    _pageBloc.add(PageLoad(model: LongStopReportUpload(enter: defaultEnter)));
    // 初始化上报Bloc
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
    _stopAdvanceTimeBloc = SystemConfigBloc(
        systemConfigRepository:
        SystemConfigRepository(HttpApi.reportStopAdvanceTime));
    // 加载异常申报开始时间最多滞后的小时数
    _stopAdvanceTimeBloc.add(SystemConfigLoad());
    _remarkController = TextEditingController();
  }

  @override
  void dispose() {
    // 释放资源
    _remarkController.dispose();
    if (_stopAdvanceTimeBloc?.state is SystemConfigLoading)
      (_stopAdvanceTimeBloc?.state as SystemConfigLoading).cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          UploadHeaderWidget(
            title: '企业长期停产申报上报',
            subTitle: '''1、停产申报一天，起止时间写同一天；
2、停产申报两天（如2号、3号），开始写2号，结束写3号；
3、在尊重事实的情况下，尽量将预计结束时间设置大的范围；''',
            imagePath: 'assets/images/long_stop_report_upload_header_image.png',
            backgroundColor: Colours.primary_color,
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
                    _remarkController.text = '';
                    _pageBloc.add(PageLoad(model: LongStopReportUpload()));
                  }
                },
              ),
              BlocListener<SystemConfigBloc, SystemConfigState>(
                bloc: _stopAdvanceTimeBloc,
                listener: (context, state) {
                  if (state is SystemConfigLoaded) {
                    // 设置最小开始时间
                    minStartTime = DateTime.now().add(Duration(
                        hours: -int.parse(
                            (_stopAdvanceTimeBloc?.state as SystemConfigLoaded)
                                .systemConfig
                                .value)));
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

  Widget _buildPageLoadedDetail(LongStopReportUpload reportUpload) {
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
                        // 设置已经选中的企业
                        _pageBloc.add(
                          PageLoad(
                            model: reportUpload.copyWith(enter: enter),
                          ),
                        );
                      }
                    },
                  ),
                ),
                widget.enterId != null ? Gaps.empty : Gaps.hLine,
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
                      minDateTime: UIUtils.getMaxDateTime(
                          reportUpload?.startTime, minStartTime).add(Duration(days: 90)),
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
                  title: '备注',
                  hintText: '请输入备注',
                  controller: _remarkController,
                ),
              ],
            ),
          ),
          Gaps.vGap10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                ClipButton(
                  text: '提交',
                  icon: Icons.file_upload,
                  color: Colors.lightBlue,
                  onTap: () {
                    _uploadBloc.add(Upload(
                      data: reportUpload.copyWith(
                        remark: _remarkController.text,
                      ),
                    ));
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
