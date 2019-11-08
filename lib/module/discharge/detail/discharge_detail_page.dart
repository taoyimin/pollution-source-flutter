import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
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
                      title: '排口名称',
                      content: '${dischargeDetail.dischargeName}',
                      icon: Icons.linked_camera,
                      flex: 6,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      title: '排口类型',
                      content: '${dischargeDetail.dischargeTypeStr}',
                      icon: Icons.videocam,
                      flex: 5,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '排放规律',
                      content: '${dischargeDetail.dischargeRuleStr}',
                      icon: Icons.insert_comment,
                      flex: 6,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      title: '排口类别',
                      content: '${dischargeDetail.dischargeCategoryStr}',
                      icon: Icons.category,
                      flex: 5,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '排口编号',
                      content: '${dischargeDetail.dischargeNumber}',
                      icon: Icons.format_list_numbered,
                      flex: 6,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      title: '排放类型',
                      content: '${dischargeDetail.outTypeStr}',
                      icon: Icons.nature,
                      flex: 5,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '标志牌安装形式',
                      content: '${dischargeDetail.denoterInstallTypeStr}',
                      icon: Icons.business_center,
                      contentTextAlign: TextAlign.left,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '排口简称',
                      content: '${dischargeDetail.dischargeShortName}',
                      icon: Icons.view_compact,
                      contentTextAlign: TextAlign.left,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '排口位置',
                      content: '${dischargeDetail.dischargeAddress}',
                      icon: Icons.location_on,
                      contentTextAlign: TextAlign.left,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '排口经度',
                      content: '${dischargeDetail.longitude}',
                      icon: Icons.location_on,
                      contentTextAlign: TextAlign.left,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '排口纬度',
                      content: '${dischargeDetail.latitude}',
                      icon: Icons.location_on,
                      contentTextAlign: TextAlign.left,
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
                      onTap: () {},
                    ),
                    Gaps.hGap10,
                    InkWellButton7(
                      meta: Meta(
                          title: '报警管理单',
                          content: '查看该排口的报警管理单',
                          backgroundPath: 'assets/images/button_bg_pink.png',
                          imagePath:
                              'assets/images/image_enter_statistics2.png'),
                      onTap: () {},
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    InkWellButton7(
                      meta: Meta(
                          title: '排口申报单',
                          content: '查看该排口的排口异常申报单',
                          backgroundPath: 'assets/images/button_bg_yellow.png',
                          imagePath:
                              'assets/images/image_enter_statistics3.png'),
                      onTap: () {},
                    ),
                    Gaps.hGap10,
                    InkWellButton7(
                      meta: Meta(
                          title: '因子申报单',
                          content: '查看该排口的因子异常申报单',
                          backgroundPath: 'assets/images/button_bg_red.png',
                          imagePath:
                              'assets/images/image_enter_statistics4.png'),
                      onTap: () {},
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
