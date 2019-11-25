import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_bloc.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_page.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'long_stop_report_detail.dart';

class LongStopReportDetailPage extends StatefulWidget {
  final String reportId;

  LongStopReportDetailPage({@required this.reportId}) : assert(reportId != null);

  @override
  _LongStopReportDetailPageState createState() => _LongStopReportDetailPageState();
}

class _LongStopReportDetailPageState extends State<LongStopReportDetailPage> {
  LongStopReportDetailBloc _reportDetailBloc;

  @override
  void initState() {
    super.initState();
    _reportDetailBloc = BlocProvider.of<LongStopReportDetailBloc>(context);
    _reportDetailBloc.add(LongStopReportDetailLoad(reportId: widget.reportId));
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
          BlocBuilder<LongStopReportDetailBloc, LongStopReportDetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              if (state is LongStopReportDetailLoaded) {
                enterName = state.reportDetail.enterName;
                enterAddress = state.reportDetail.enterAddress;
              }
              return DetailHeaderWidget(
                title: '长期停产申报详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/report_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_lightblue.png',
              );
            },
          ),
          BlocBuilder<LongStopReportDetailBloc, LongStopReportDetailState>(
            builder: (context, state) {
              if (state is LongStopReportDetailLoading) {
                return PageLoadingWidget();
              } else if (state is LongStopReportDetailEmpty) {
                return PageEmptyWidget();
              } else if (state is LongStopReportDetailError) {
                return PageErrorWidget(errorMessage: state.errorMessage);
              } else if (state is LongStopReportDetailLoaded) {
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

  Widget _buildPageLoadedDetail(LongStopReportDetail reportDetail) {
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
                      content: '所属区域：${reportDetail.districtName}',
                      icon: Icons.location_on,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '申报时间：${reportDetail.reportTimeStr}',
                      icon: Icons.date_range,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '开始时间：${reportDetail.startTimeStr}',
                      icon: Icons.date_range,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '结束时间：${reportDetail.endTimeStr}',
                      icon: Icons.date_range,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '备注：${reportDetail.remark}',
                      icon: Icons.receipt,
                    ),
                  ],
                ),
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
                  child: Row(
                    children: <Widget>[
                      InkWellButton7(
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
                      Expanded(child: Gaps.empty),
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
