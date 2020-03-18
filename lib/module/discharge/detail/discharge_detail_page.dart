import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/widget/custom_header.dart';

class DischargeDetailPage extends StatefulWidget {
  final String dischargeId;

  DischargeDetailPage({@required this.dischargeId})
      : assert(dischargeId != null);

  @override
  _DischargeDetailPageState createState() => _DischargeDetailPageState();
}

class _DischargeDetailPageState extends State<DischargeDetailPage> {
  DetailBloc _detailBloc;

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    _detailBloc.add(DetailLoad(detailId: widget.dischargeId));
  }

  @override
  void dispose() {
    //取消正在进行的请求
    final currentState = _detailBloc?.state;
    if (currentState is DetailLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                title: '排口详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/discharge_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_yellow.png',
                color: Colours.background_yellow,
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
                return ErrorSliver(errorMessage: 'BlocBuilder监听到未知的的状态');
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
                      content: '排口名称：${dischargeDetail.dischargeName ?? ''}',
                      icon: Icons.linked_camera,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content:
                          '排口类型：${dischargeDetail.dischargeCategoryStr ?? ''}',
                      icon: Icons.category,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content:
                      '标志牌安装形式：${dischargeDetail.denoterInstallTypeStr ?? ''}',
                      icon: Icons.business_center,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '排放规律：${dischargeDetail.dischargeRuleStr ?? ''}',
                      icon: Icons.insert_comment,
                      flex: 6,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      content: '监测类型：${dischargeDetail.dischargeTypeStr ?? ''}',
                      icon: Icons.videocam,
                      flex: 5,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '排口编号：${dischargeDetail.dischargeNumber ?? ''}',
                      icon: Icons.table_chart,
                      flex: 6,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      content: '排放类型：${dischargeDetail.outTypeStr ?? ''}',
                      icon: Icons.nature,
                      flex: 5,
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
                        Application.router.navigateTo(context,
                            '${Routes.dischargeReportList}?dischargeId=${dischargeDetail.dischargeId}');
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
                        Application.router.navigateTo(context,
                            '${Routes.factorReportList}?dischargeId=${dischargeDetail.dischargeId}');
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
                        Application.router.navigateTo(context,
                            '${Routes.enterDetail}/${dischargeDetail.enterId}');
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
                        Application.router.navigateTo(context,
                            '${Routes.monitorList}?dischargeId=${dischargeDetail.dischargeId}');
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
