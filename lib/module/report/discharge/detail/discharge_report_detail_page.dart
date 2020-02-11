import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/report/discharge/detail/discharge_report_detail_model.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/widget/custom_header.dart';

class DischargeReportDetailPage extends StatefulWidget {
  final String reportId;

  DischargeReportDetailPage({@required this.reportId})
      : assert(reportId != null);

  @override
  _DischargeReportDetailPageState createState() =>
      _DischargeReportDetailPageState();
}

class _DischargeReportDetailPageState extends State<DischargeReportDetailPage> {
  DetailBloc _detailBloc;

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    _detailBloc.add(DetailLoad(detailId: widget.reportId));
  }

  @override
  void dispose() {
    //取消正在进行的请求
    final currentState = _detailBloc?.state;
    if (currentState is DetailLoading) currentState.cancelToken?.cancel();
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
          BlocBuilder<DetailBloc, DetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              if (state is DetailLoaded) {
                enterName = state.detail.enterName;
                enterAddress = state.detail.enterAddress;
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
          BlocBuilder<DetailBloc, DetailState>(
            builder: (context, state) {
              if (state is DetailLoading) {
                return LoadingSliver();
              } else if (state is DetailError) {
                return ErrorSliver(errorMessage: state.message);
              } else if (state is DetailLoaded) {
                return _buildPageLoadedDetail(state.detail);
              } else {
                return ErrorSliver(errorMessage: 'BlocBuilder监听到未知的的状态！state=$state');
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
                      content:
                      '排口名称：${reportDetail.dischargeName ?? ''}',
                      icon: Icons.nature,
                      flex: 9,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      content:
                      '申报时间：${reportDetail.reportTimeStr ?? ''}',
                      icon: Icons.date_range,
                      flex: 10,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '监控点名：${reportDetail.monitorName ?? ''}',
                      icon: Icons.linked_camera,
                      flex: 9,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      content: '所属区域：${reportDetail.districtName ?? ''}',
                      icon: Icons.location_on,
                      flex: 10,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '开始时间：${reportDetail.startTimeStr ?? ''}',
                      icon: Icons.date_range,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '结束时间：${reportDetail.endTimeStr ?? ''}',
                      icon: Icons.date_range,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '异常类型：${reportDetail.stopTypeStr ?? ''}',
                      icon: Icons.alarm,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '停产原因：${reportDetail.stopReason ?? ''}',
                      icon: Icons.receipt,
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
                          Application.router.navigateTo(context,
                              '${Routes.enterDetail}/${reportDetail.enterId}');
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
                                Application.router.navigateTo(context,
                                    '${Routes.dischargeDetail}/${reportDetail.dischargeId}');
                              },
                            ),
                            Gaps.vGap10,
                            InkWellButton7(
                              meta: Meta(
                                  title: '在线数据',
                                  content: '查看该申报单对应的在线数据',
                                  backgroundPath:
                                  'assets/images/button_bg_red.png',
                                  imagePath:
                                  'assets/images/image_enter_statistics2.png'),
                              onTap: () {
                                Application.router.navigateTo(context,
                                    '${Routes.monitorDetail}/${reportDetail.monitorId}');
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
