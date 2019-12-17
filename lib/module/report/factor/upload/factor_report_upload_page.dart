import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
import 'package:pollution_source/module/common/page/page_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/module/report/factor/upload/factor_report_upload_model.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

class FactorReportUploadPage extends StatefulWidget {
  final String enterId;

  FactorReportUploadPage({@required this.enterId}) : assert(enterId != null);

  @override
  _FactorReportUploadPageState createState() => _FactorReportUploadPageState();
}

class _FactorReportUploadPageState extends State<FactorReportUploadPage> {
  PageBloc _pageBloc;
  UploadBloc _uploadBloc;
  TextEditingController _exceptionReasonController;

  @override
  void initState() {
    super.initState();
    _pageBloc = BlocProvider.of<PageBloc>(context);
    //首次加载
    _pageBloc.add(PageLoad(model: FactorReportUpload()));
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
    _exceptionReasonController = TextEditingController();
  }

  @override
  void dispose() {
    _exceptionReasonController.dispose();
    super.dispose();
  }

  //用来显示SnackBar
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    _pageBloc.add(PageLoad(model: FactorReportUpload()));
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

  Widget _buildPageLoadedDetail(FactorReportUpload reportUpload) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                EditRowWidget(
                  title: '排口名称',
                  hintText: '请选择排口',
                  readOnly: true,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      // 设置内容
                      text: '${reportUpload?.discharge?.dischargeName ?? ''}',
                    ),
                  ),
                  onTap: () async {
                    Discharge discharge = await Application.router.navigateTo(
                        context, '${Routes.dischargeList}?enterId=${widget.enterId}&type=1');
                    _pageBloc.add(
                      PageLoad(
                        model: reportUpload.copyWith(discharge: discharge),
                      ),
                    );
                  },
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '监控点名',
                  hintText: '请选择监控点',
                  readOnly: true,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      // 设置内容
                      text: '${reportUpload?.monitor?.monitorName ?? ''}',
                    ),
                  ),
                  onTap: () async {
                    Monitor monitor = await Application.router.navigateTo(
                        context, '${Routes.monitorList}?enterId=${widget.enterId}&type=1');
                    _pageBloc.add(
                      PageLoad(
                        model: reportUpload.copyWith(monitor: monitor),
                      ),
                    );
                  },
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '异常类型',
                  hintText: '请选择异常类型',
                  readOnly: true,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text:
                          '${reportUpload?.alarmType != null ? FactorReportUpload.alarmTypeList[reportUpload.alarmType] : ''}',
                    ),
                  ),
                  popupMenuButton: PopupMenuButton<AlarmType>(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.transparent,
                      ),
                      onSelected: (AlarmType result) {
                        _pageBloc.add(
                          PageLoad(
                            model:
                                reportUpload.copyWith(alarmType: result.index),
                          ),
                        );
                      },
                      itemBuilder: (BuildContext context) =>
                          AlarmType.values.map((value) {
                            return PopupMenuItem<AlarmType>(
                              value: value,
                              child: Text(
                                  '${FactorReportUpload.alarmTypeList[value.index]}'),
                            );
                          }).toList()),
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '开始时间',
                  hintText: '请选择开始时间',
                  readOnly: true,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      // 设置内容
                      text:
                          '${DateUtil.formatDate(reportUpload?.startTime, format: 'yyyy-MM-dd HH:mm:ss')}',
                    ),
                  ),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        locale: DateTimePickerLocale.zh_cn,
                        pickerMode: DateTimePickerMode.datetime,
                        onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                      _pageBloc.add(
                        PageLoad(
                          model: reportUpload.copyWith(startTime: dateTime),
                        ),
                      );
                    });
                  },
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '结束时间',
                  hintText: '请选择结束时间',
                  readOnly: true,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      // 设置内容
                      text:
                          '${DateUtil.formatDate(reportUpload?.endTime, format: 'yyyy-MM-dd HH:mm:ss')}',
                    ),
                  ),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        locale: DateTimePickerLocale.zh_cn,
                        pickerMode: DateTimePickerMode.datetime,
                        onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                      _pageBloc.add(
                        PageLoad(
                          model: reportUpload.copyWith(endTime: dateTime),
                        ),
                      );
                    });
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
                          attachments:
                              await Utils.loadAssets(reportUpload.attachments),
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
                      factorCode: '110',
                      enterId: widget.enterId,
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
