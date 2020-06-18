import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/warn/detail/warn_detail_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'warn_detail_repository.dart';

/// 实时预警单详情界面
class WarnDetailPage extends StatefulWidget {
  final String warnId;

  WarnDetailPage({@required this.warnId}) : assert(warnId != null);

  @override
  _WarnDetailPageState createState() => _WarnDetailPageState();
}

class _WarnDetailPageState extends State<WarnDetailPage> {
  /// 全局Key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 详情Bloc
  final DetailBloc _detailBloc = DetailBloc(
    detailRepository: WarnDetailRepository(),
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    // 取消正在进行的请求
    if (_detailBloc?.state is DetailLoading)
      (_detailBloc?.state as DetailLoading).cancelToken.cancel();
    super.dispose();
  }

  /// 加载数据
  _loadData() {
    _detailBloc.add(DetailLoad(detailId: widget.warnId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          BlocBuilder<DetailBloc, DetailState>(
            bloc: _detailBloc,
            builder: (context, state) {
              String enterName = '';
              String districtName = '';
              if (state is DetailLoaded) {
                enterName = state.detail.enterName ?? '';
                districtName = state.detail.districtName ?? '';
              }
              return DetailHeaderWidget(
                title: '实时预警单详情',
                subTitle1: '$districtName',
                subTitle2: '$enterName',
                imagePath: 'assets/images/warn_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_yellow.png',
                color: Colours.background_yellow,
              );
            },
          ),
          // 生成body
          BlocBuilder<DetailBloc, DetailState>(
            bloc: _detailBloc,
            builder: (context, state) {
              if (state is DetailLoading) {
                return LoadingSliver();
              } else if (state is DetailError) {
                return ErrorSliver(
                  errorMessage: state.message,
                  onReloadTap: () => _loadData(),
                );
              } else if (state is DetailLoaded) {
                return _buildPageLoadedDetail(state.detail);
              } else {
                return ErrorSliver(
                  errorMessage: 'BlocBuilder监听到未知的的状态!state=$state',
                  onReloadTap: () => _loadData(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(WarnDetail warnDetail) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          // 基本信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '基本信息',
                  imagePath: 'assets/images/icon_baseinfo.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '监控点名：${warnDetail.monitorName}',
                      icon: Icons.linked_camera,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '关注程度：${warnDetail.attentionLevelStr}',
                      icon: Icons.star,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '报警类型：${warnDetail.alarmTypeStr}',
                      icon: Icons.alarm,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '生成时间：${warnDetail.createTimeStr}',
                      icon: Icons.date_range,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '开始时间：${warnDetail.startTimeStr}',
                      icon: Icons.date_range,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '结束时间：${warnDetail.endTimeStr}',
                      icon: Icons.date_range,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '预警标题：${warnDetail.title}',
                      icon: Icons.text_fields,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '预警详情：${warnDetail.text}',
                      icon: Icons.description,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 快速链接
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
                          content: '查看该预警单所属的企业信息',
                          backgroundPath:
                              'assets/images/button_bg_lightblue.png',
                          imagePath:
                              'assets/images/image_enter_statistics1.png',
                          router: '${Routes.enterDetail}/${warnDetail.enterId}',
                        ),
                      ),
                      Gaps.hGap10,
                      InkWellButton7(
                        meta: Meta(
                          title: '在线数据',
                          content: '查看该预警单对应的在线数据',
                          backgroundPath: 'assets/images/button_bg_red.png',
                          imagePath:
                              'assets/images/image_enter_statistics2.png',
                          router:
                              '${Routes.monitorDetail}/${warnDetail.monitorId}',
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
