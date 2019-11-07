import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'factor_report_detail.dart';

class FactorReportDetailPage extends StatefulWidget {
  final String reportId;

  FactorReportDetailPage({@required this.reportId}) : assert(reportId != null);

  @override
  _FactorReportDetailPageState createState() => _FactorReportDetailPageState();
}

class _FactorReportDetailPageState extends State<FactorReportDetailPage> {
  FactorReportDetailBloc _reportDetailBloc;

  @override
  void initState() {
    super.initState();
    _reportDetailBloc = BlocProvider.of<FactorReportDetailBloc>(context);
    _reportDetailBloc.add(FactorReportDetailLoad(reportId: widget.reportId));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          BlocBuilder<FactorReportDetailBloc, FactorReportDetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              if (state is FactorReportDetailLoaded) {
                enterName = state.reportDetail.enterName;
                enterAddress = state.reportDetail.enterAddress;
              }
              return DetailHeaderWidget(
                title: '排口异常申报详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/report_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_pink.png',
              );
            },
          ),
          BlocBuilder<FactorReportDetailBloc, FactorReportDetailState>(
            builder: (context, state) {
              if (state is FactorReportDetailLoading) {
                return PageLoadingWidget();
              } else if (state is FactorReportDetailEmpty) {
                return PageEmptyWidget();
              } else if (state is FactorReportDetailError) {
                return PageErrorWidget(errorMessage: state.errorMessage);
              } else if (state is FactorReportDetailLoaded) {
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

  Widget _buildPageLoadedDetail(FactorReportDetail reportDetail) {
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
                  imagePath: 'assets/images/icon_enter_baseinfo.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '排口名称',
                      content: '${reportDetail.dischargeName}',
                      icon: Icons.nature,
                      flex: 9,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      title: '申报时间',
                      content: '${reportDetail.reportTimeStr}',
                      icon: Icons.date_range,
                      flex: 10,
                      contentMarginTop: 2,
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
                      contentMarginTop: 2,
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
                      contentMarginTop: 2,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '报警类型',
                      content: '${reportDetail.alarmTypeStr}',
                      icon: Icons.alarm,
                      contentTextAlign: TextAlign.left,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '异常原因',
                      content: '${reportDetail.exceptionReason}',
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
                  imagePath: 'assets/images/icon_enter_baseinfo.png',
                ),
                Gaps.vGap10,
                reportDetail.attachmentList.length == 0
                    ? const Text(
                        '没有上传证明材料',
                        style: TextStyle(fontSize: 13),
                      )
                    : Column(
                        children: () {
                          return reportDetail.attachmentList.map((attachment) {
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
  }
}
