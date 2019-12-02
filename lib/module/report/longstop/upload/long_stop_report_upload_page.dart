import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'long_stop_report_upload.dart';

class LongStopReportUploadPage extends StatefulWidget {
  final String enterId;

  LongStopReportUploadPage({@required this.enterId}) : assert(enterId != null);

  @override
  _LongStopReportUploadPageState createState() =>
      _LongStopReportUploadPageState();
}

class _LongStopReportUploadPageState extends State<LongStopReportUploadPage> {
  LongStopReportUploadBloc _reportUploadBloc;
  TextEditingController _remarkController;

  @override
  void initState() {
    super.initState();
    _reportUploadBloc = BlocProvider.of<LongStopReportUploadBloc>(context);
    _remarkController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _remarkController.dispose();
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
            title: '企业长期停产申报上报',
            subTitle: '''1、停产申报一天，起止时间写同一天；
2、停产申报两天（如2号、3号），开始写2号，结束写3号；
3、在尊重事实的情况下，尽量将预计结束时间设置大的范围；''',
            imagePath: 'assets/images/long_stop_report_upload_header_image.png',
            backgroundColor: Colours.primary_color,
          ),
          BlocBuilder<LongStopReportUploadBloc, LongStopReportUploadState>(
            // ignore: missing_return
            builder: (context, state) {
              if (state is LongStopReportUploadLoaded) {
                return _buildPageLoadedDetail(state.reportUpload);
              } else if (state is LongStopReportUploadSuccess) {
                Toast.show('上报成功');
                Navigator.pop(context);
                //return _buildPageLoadedDetail(state.reportUpload);
              } else {
                return PageErrorWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
              }
            },
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
                      _reportUploadBloc.add(
                        LongStopReportUploadLoad(
                          reportUpload:
                              reportUpload.copyWith(startTime: dateTime),
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
                      _reportUploadBloc.add(
                        LongStopReportUploadLoad(
                          reportUpload:
                              reportUpload.copyWith(endTime: dateTime),
                        ),
                      );
                    });
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
                    Toast.show('点击了提交按钮');
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
