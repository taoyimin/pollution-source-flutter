import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_bloc.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_page.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_bloc.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_model.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_page.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_bloc.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_page.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_bloc.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_page.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_bloc.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_page.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/log_utils.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';
import 'package:pollution_source/widget/my_text_field.dart';

import 'discharge_report_upload.dart';

class DischargeReportUploadPage extends StatefulWidget {
  final String enterId;

  DischargeReportUploadPage({@required this.enterId}) : assert(enterId != null);

  @override
  _DischargeReportUploadPageState createState() =>
      _DischargeReportUploadPageState();
}

class _DischargeReportUploadPageState extends State<DischargeReportUploadPage> {
  DischargeReportUploadBloc _reportUploadBloc;
  TextEditingController _stopReasonController;

  @override
  void initState() {
    super.initState();
    _reportUploadBloc = BlocProvider.of<DischargeReportUploadBloc>(context);
    //_reportUploadBloc.add(DischargeReportUploadLoad(enterId: widget.enterId));
    _stopReasonController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _stopReasonController.dispose();
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
            title: '排口异常申报上报',
            subTitle: '''1、异常申报一天，起止时间写同一天；
2、异常申报两天（如2号、3号），开始写2号，结束写3号；
3、在尊重事实的情况下，尽量将预计结束时间设置大的范围； 
4、异常解决之后，可以根据实际情况申请更改实际结束时间；
5、申报证明材料加盖企业公章。''',
            imagePath: 'assets/images/discharge_report_upload_header_image.png',
            backgroundColor: Colors.lightBlueAccent,
          ),
          BlocBuilder<DischargeReportUploadBloc, DischargeReportUploadState>(
            // ignore: missing_return
            builder: (context, state) {
              if (state is DischargeReportUploadLoaded) {
                return _buildPageLoadedDetail(state.reportUpload);
              } else if (state is DischargeReportUploadSuccess) {
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

  Widget _buildPageLoadedDetail(DischargeReportUpload reportUpload) {
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
                    Discharge discharge = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return BlocProvider(
                            builder: (context) => DischargeListBloc(),
                            child: DischargeListPage(
                              enterId: widget.enterId,
                              type: 1,
                            ),
                          );
                        },
                      ),
                    );
                    _reportUploadBloc.add(
                      DischargeReportUploadLoad(
                        reportUpload:
                            reportUpload.copyWith(discharge: discharge),
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
                    Monitor monitor = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return BlocProvider(
                            builder: (context) => MonitorListBloc(),
                            child: MonitorListPage(
                              enterId: widget.enterId,
                              type: 1,
                            ),
                          );
                        },
                      ),
                    );
                    _reportUploadBloc.add(
                      DischargeReportUploadLoad(
                        reportUpload: reportUpload.copyWith(monitor: monitor),
                      ),
                    );
                  },
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '停产类型',
                  hintText: '请选择停产类型',
                  readOnly: true,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text:
                      '${reportUpload?.stopType != null ? DischargeReportUpload.stopTypeList[reportUpload.stopType] : ''}',
                    ),
                  ),
                  popupMenuButton: PopupMenuButton<StopType>(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.transparent,
                      ),
                      onSelected: (StopType result) {
                        _reportUploadBloc.add(
                          DischargeReportUploadLoad(
                            reportUpload:
                            reportUpload.copyWith(stopType: result.index),
                          ),
                        );
                      },
                      itemBuilder: (BuildContext context) =>
                          StopType.values.map((value) {
                            return PopupMenuItem<StopType>(
                              value: value,
                              child: Text(
                                  '${DischargeReportUpload.stopTypeList[value.index]}'),
                            );
                          }).toList()),
                ),
                Gaps.hLine,
                EditRowWidget(
                  title: '申报时间',
                  hintText: '请选择申报时间',
                  readOnly: true,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      // 设置内容
                      text:
                          '${DateUtil.formatDate(reportUpload?.reportTime, format: 'yyyy-MM-dd')}',
                    ),
                  ),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        locale: DateTimePickerLocale.zh_cn,
                        onClose: () {}, onConfirm: (dateTime, selectedIndex) {
                      _reportUploadBloc.add(
                        DischargeReportUploadLoad(
                          reportUpload:
                              reportUpload.copyWith(reportTime: dateTime),
                        ),
                      );
                    });
                  },
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
                      _reportUploadBloc.add(
                        DischargeReportUploadLoad(
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
                        DischargeReportUploadLoad(
                          reportUpload:
                              reportUpload.copyWith(endTime: dateTime),
                        ),
                      );
                    });
                  },
                ),
                Gaps.hLine,
                TextAreaWidget(
                  title: '停产描述',
                  hintText: '请使用一句话简单概括停产的原因',
                  controller: _stopReasonController,
                ),
              ],
            ),
          ),
          Gaps.vGap5,
          Offstage(
            offstage: reportUpload.attachments == null ||
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
                reportUpload.attachments == null
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
                  onTap: () {
                    loadAssets(reportUpload);
                  },
                ),
                Gaps.hGap20,
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

  Future<void> loadAssets(DischargeReportUpload reportUpload) async {
    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        enableCamera: true,
        maxImages: 10,
        selectedAssets: reportUpload.attachments ?? List<Asset>(),
        materialOptions: MaterialOptions(
          actionBarTitle: "选取图片",
          allViewTitle: "全部图片",
          actionBarColor: '#03A9F4',
          actionBarTitleColor: "#FFFFFF",
          lightStatusBar: false,
          statusBarColor: '#0288D1',
          startInAllView: false,
          useDetailsView: true,
          selectCircleStrokeColor: "#FFFFFF",
          selectionLimitReachedText: "已达到可选图片最大数",
        ),
      );
    } on NoImagesSelectedException {
      Log.i('没有图片被选择,resultList.length=${resultList?.length}');
      return;
    } on Exception catch (e) {
      Toast.show('选择图片错误！错误信息：$e');
    }
    _reportUploadBloc.add(
      DischargeReportUploadLoad(
        reportUpload:
            reportUpload.copyWith(attachments: resultList ?? List<Asset>()),
      ),
    );
  }
}
