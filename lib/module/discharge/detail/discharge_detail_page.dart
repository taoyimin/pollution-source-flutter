import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_bloc.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_page.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_bloc.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_page.dart';
import 'package:pollution_source/module/report/discharge/list/discharge_report_list_bloc.dart';
import 'package:pollution_source/module/report/discharge/list/discharge_report_list_page.dart';
import 'package:pollution_source/module/report/factor/list/factor_report_list_bloc.dart';
import 'package:pollution_source/module/report/factor/list/factor_report_list_page.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'discharge_detail.dart';

class DischargeDetailPage extends StatefulWidget {
  final String dischargeId;

  DischargeDetailPage({@required this.dischargeId}) : assert(dischargeId != null);

  @override
  _DischargeDetailPageState createState() => _DischargeDetailPageState();
}

class _DischargeDetailPageState extends State<DischargeDetailPage> {
  DischargeDetailBloc _dischargeDetailBloc;

  @override
  void initState() {
    super.initState();
    _dischargeDetailBloc = BlocProvider.of<DischargeDetailBloc>(context);
    _dischargeDetailBloc.add(DischargeDetailLoad(dischargeId: widget.dischargeId));
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
          BlocBuilder<DischargeDetailBloc, DischargeDetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              if (state is DischargeDetailLoaded) {
                enterName = state.dischargeDetail.enterName;
                enterAddress = state.dischargeDetail.enterAddress;
              }
              return DetailHeaderWidget(
                title: '排口详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/discharge_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_yellow.png',
              );
            },
          ),
          BlocBuilder<DischargeDetailBloc, DischargeDetailState>(
            builder: (context, state) {
              if (state is DischargeDetailLoading) {
                return PageLoadingWidget();
              } else if (state is DischargeDetailEmpty) {
                return PageEmptyWidget();
              } else if (state is DischargeDetailError) {
                return PageErrorWidget(errorMessage: state.errorMessage);
              } else if (state is DischargeDetailLoaded) {
                return _buildPageLoadedDetail(state.dischargeDetail);
              } else {
                return PageErrorWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(DischargeDetail dischargeDetail) {
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
                      content: '排口名称：${dischargeDetail.dischargeName}',
                      icon: Icons.linked_camera,
                      flex: 6,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      content: '排口类型：${dischargeDetail.dischargeTypeStr}',
                      icon: Icons.videocam,
                      flex: 5,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '排放规律：${dischargeDetail.dischargeRuleStr}',
                      icon: Icons.insert_comment,
                      flex: 6,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      content: '排口类别：${dischargeDetail.dischargeCategoryStr}',
                      icon: Icons.category,
                      flex: 5,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '排口编号：${dischargeDetail.dischargeNumber}',
                      icon: Icons.format_list_numbered,
                      flex: 6,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      content: '排放类型：${dischargeDetail.outTypeStr}',
                      icon: Icons.nature,
                      flex: 5,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '标志牌安装形式：${dischargeDetail.denoterInstallTypeStr}',
                      icon: Icons.business_center,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '排口简称：${dischargeDetail.dischargeShortName}',
                      icon: Icons.view_compact,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '排口位置：${dischargeDetail.dischargeAddress}',
                      icon: Icons.location_on,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '排口经度：${dischargeDetail.longitude}',
                      icon: Icons.location_on,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '排口纬度：${dischargeDetail.latitude}',
                      icon: Icons.location_on,
                    ),
                  ],
                ),
              ],
            ),
          ),
          //异常申报信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '异常申报信息',
                  imagePath: 'assets/images/icon_outlet_report.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    InkWellButton7(
                      titleFontSize: 13,
                      contentFontSize: 19,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => DischargeReportListBloc(),
                                child: DischargeReportListPage(
                                  dischargeId: dischargeDetail.dischargeId,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      meta: Meta(
                        title: '排口异常申报总数',
                        content: '${dischargeDetail.dischargeReportTotalCount}',
                        imagePath: 'assets/images/button_image1.png',
                        backgroundPath: 'assets/images/button_bg_green.png',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton7(
                      titleFontSize: 13,
                      contentFontSize: 19,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => FactorReportListBloc(),
                                child: FactorReportListPage(
                                  dischargeId: dischargeDetail.dischargeId,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      meta: Meta(
                        title: '因子异常申报总数',
                        content: '${dischargeDetail.factorReportTotalCount}',
                        imagePath: 'assets/images/button_image4.png',
                        backgroundPath: 'assets/images/button_bg_pink.png',
                      ),
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
                Row(
                  children: <Widget>[
                    InkWellButton7(
                      meta: Meta(
                          title: '企业信息',
                          content: '查看排口所属的企业信息',
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
                                  enterId: dischargeDetail.enterId,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    Gaps.hGap10,
                    InkWellButton7(
                      meta: Meta(
                          title: '监控点列表',
                          content: '查看该排口的监控点列表',
                          backgroundPath: 'assets/images/button_bg_red.png',
                          imagePath:
                              'assets/images/image_enter_statistics2.png'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => MonitorListBloc(),
                                child: MonitorListPage(
                                  dischargeId: dischargeDetail.dischargeId,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
