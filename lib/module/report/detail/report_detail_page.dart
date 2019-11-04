import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'report_detail.dart';

class ReportDetailPage extends StatefulWidget {
  final String reportId;

  ReportDetailPage({@required this.reportId}) : assert(reportId != null);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  ReportDetailBloc _reportDetailBloc;

  @override
  void initState() {
    super.initState();
    _reportDetailBloc = BlocProvider.of<ReportDetailBloc>(context);
    _reportDetailBloc.add(ReportDetailLoad(reportId: widget.reportId));
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
          BlocBuilder<ReportDetailBloc, ReportDetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              if (state is ReportDetailLoaded) {
                enterName = state.reportDetail.enterName;
                enterAddress = state.reportDetail.enterAddress;
              }
              return DetailHeaderWidget(
                title: '异常申报单详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/report_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_pink.png',
              );
            },
          ),
          BlocBuilder<ReportDetailBloc, ReportDetailState>(
            builder: (context, state) {
              if (state is ReportDetailLoading) {
                return PageLoadingWidget();
              } else if (state is ReportDetailEmpty) {
                return PageEmptyWidget();
              } else if (state is ReportDetailError) {
                return PageErrorWidget(errorMessage: state.errorMessage);
              } else if (state is ReportDetailLoaded) {
                return SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      //基本信息
                      Container(
                        width: double.infinity,
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
                                  title: '监控点',
                                  content: '${state.reportDetail.monitorName}',
                                  icon: Icons.linked_camera,
                                  flex: 6,
                                ),
                                Gaps.hGap20,
                                IconBaseInfoWidget(
                                  title: '申报时间',
                                  content: '${state.reportDetail.reportTime}',
                                  icon: Icons.date_range,
                                  flex: 5,
                                ),
                              ],
                            ),
                            Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                IconBaseInfoWidget(
                                  title: '异常类型',
                                  content: '${state.reportDetail.abnormalType}',
                                  icon: Icons.alarm,
                                  flex: 6,
                                ),
                                Gaps.hGap20,
                                IconBaseInfoWidget(
                                  title: '区域',
                                  content: '${state.reportDetail.areaName}',
                                  icon: Icons.location_on,
                                  flex: 5,
                                ),
                              ],
                            ),
                            Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                IconBaseInfoWidget(
                                  title: '异常因子',
                                  content:
                                      '${state.reportDetail.abnormalFactor}',
                                  icon: Icons.label,
                                  contentTextAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                IconBaseInfoWidget(
                                  title: '开始时间',
                                  content: '${state.reportDetail.startTime}',
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
                                  content: '${state.reportDetail.endTime}',
                                  icon: Icons.date_range,
                                  contentTextAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                IconBaseInfoWidget(
                                  title: '申报原因',
                                  content: '${state.reportDetail.reportReason}',
                                  icon: Icons.receipt,
                                  contentTextAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //证明材料
                      Container(
                        width: double.infinity,
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
                            Column(
                              children: () {
                                return state.reportDetail.attachmentList
                                    .map((attachment) {
                                  return AttachmentWidget(
                                      attachment: attachment, onTap: () {});
                                }).toList();
                              }(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SliverFillRemaining();
              }
            },
          ),
        ],
      ),
    );
  }
}
