import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_bloc.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_page.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_bloc.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_page.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_bloc.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_page.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'discharge_report_detail.dart';

class DischargeReportDetailPage extends StatefulWidget {
  final String reportId;

  DischargeReportDetailPage({@required this.reportId})
      : assert(reportId != null);

  @override
  _DischargeReportDetailPageState createState() =>
      _DischargeReportDetailPageState();
}

class _DischargeReportDetailPageState extends State<DischargeReportDetailPage> {
  DischargeReportDetailBloc _reportDetailBloc;

  @override
  void initState() {
    super.initState();
    _reportDetailBloc = BlocProvider.of<DischargeReportDetailBloc>(context);
    _reportDetailBloc.add(DischargeReportDetailLoad(reportId: widget.reportId));
  }

  @override
  void dispose() {
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
          BlocBuilder<DischargeReportDetailBloc, DischargeReportDetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              if (state is DischargeReportDetailLoaded) {
                enterName = state.reportDetail.enterName;
                enterAddress = state.reportDetail.enterAddress;
              }
              return DetailHeaderWidget(
                title: '排口异常申报详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/report_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_green.png',
              );
            },
          ),
          BlocBuilder<DischargeReportDetailBloc, DischargeReportDetailState>(
            builder: (context, state) {
              if (state is DischargeReportDetailLoading) {
                return PageLoadingWidget();
              } else if (state is DischargeReportDetailEmpty) {
                return PageEmptyWidget();
              } else if (state is DischargeReportDetailError) {
                return PageErrorWidget(errorMessage: state.errorMessage);
              } else if (state is DischargeReportDetailLoaded) {
                return _buildPageLoadedDetail(state.reportDetail);
              } else {
                return PageErrorWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(DischargeReportDetail reportDetail){
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          //基本信息
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '基本信息',
                  imagePath:
                  'assets/images/icon_enter_baseinfo.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '排口名称',
                      content:
                      '${reportDetail.dischargeName}',
                      icon: Icons.nature,
                      flex: 9,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      title: '申报时间',
                      content:
                      '${reportDetail.reportTimeStr}',
                      icon: Icons.date_range,
                      flex: 10,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '监控点名',
                      content: '${reportDetail.monitorName}',
                      icon: Icons.linked_camera,
                      flex: 9,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      title: '所属区域',
                      content: '${reportDetail.districtName}',
                      icon: Icons.location_on,
                      flex: 10,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '开始时间',
                      content: '${reportDetail.startTimeStr}',
                      icon: Icons.date_range,
                      contentTextAlign: TextAlign.left,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '结束时间',
                      content: '${reportDetail.endTimeStr}',
                      icon: Icons.date_range,
                      contentTextAlign: TextAlign.left,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '异常类型',
                      content: '${reportDetail.stopTypeStr}',
                      icon: Icons.alarm,
                      contentTextAlign: TextAlign.left,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '停产原因',
                      content: '${reportDetail.stopReason}',
                      icon: Icons.receipt,
                      contentTextAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          ),
          //证明材料
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '证明材料',
                  imagePath:
                  'assets/images/icon_enter_baseinfo.png',
                ),
                Gaps.vGap10,
                reportDetail.attachments.length == 0
                    ? const Text(
                  '没有上传证明材料',
                  style: TextStyle(fontSize: 13),
                )
                    : Column(
                  children: () {
                    return reportDetail.attachments
                        .map((attachment) {
                      return AttachmentWidget(
                          attachment: attachment,
                          onTap: () {});
                    }).toList();
                  }(),
                )
              ],
            ),
          ),
          //快速链接
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '快速链接',
                  imagePath: 'assets/images/icon_fast_link.png',
                ),
                Gaps.vGap10,
                Container(
                  height: 152,
                  child: Row(
                    children: <Widget>[
                      InkWellButton8(
                        meta: Meta(
                            title: '企业信息',
                            content: '查看该申报单所属的企业信息',
                            backgroundPath:
                            'assets/images/button_bg_lightblue.png',
                            imagePath:
                            'assets/images/image_enter_statistics1.png'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BlocProvider(
                                  builder: (context) => EnterDetailBloc(),
                                  child: EnterDetailPage(
                                    enterId: reportDetail.enterId,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      Gaps.hGap10,
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            InkWellButton7(
                              meta: Meta(
                                  title: '排口信息',
                                  content: '查看该申报单所属的排口信息',
                                  backgroundPath: 'assets/images/button_bg_yellow.png',
                                  imagePath:
                                  'assets/images/image_enter_statistics3.png'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return BlocProvider(
                                        builder: (context) => DischargeDetailBloc(),
                                        child: DischargeDetailPage(
                                          dischargeId: reportDetail.dischargeId,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            Gaps.vGap10,
                            InkWellButton7(
                              meta: Meta(
                                  title: '监控点信息',
                                  content: '查看该申报单所属的监控点信息',
                                  backgroundPath:
                                  'assets/images/button_bg_red.png',
                                  imagePath:
                                  'assets/images/image_enter_statistics2.png'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return BlocProvider(
                                        builder: (context) => MonitorDetailBloc(),
                                        child: MonitorDetailPage(
                                          monitorId: reportDetail.monitorId,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
