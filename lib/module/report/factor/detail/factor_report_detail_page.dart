import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/report/factor/detail/factor_report_detail_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'factor_report_detail_repository.dart';

/// 因子异常申报详情界面
class FactorReportDetailPage extends StatefulWidget {
  final String reportId;

  FactorReportDetailPage({@required this.reportId}) : assert(reportId != null);

  @override
  _FactorReportDetailPageState createState() => _FactorReportDetailPageState();
}

class _FactorReportDetailPageState extends State<FactorReportDetailPage> {
  /// 详情Bloc
  final DetailBloc _detailBloc = DetailBloc(
    detailRepository: FactorReportDetailRepository(),
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
    _detailBloc.add(DetailLoad(detailId: widget.reportId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          BlocBuilder<DetailBloc, DetailState>(
            bloc: _detailBloc,
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              String districtName = '';
              if (state is DetailLoaded) {
                enterName = state.detail.enterName;
                enterAddress = state.detail.enterAddress;
                districtName = state.detail.districtName;
              }
              return DetailHeaderWidget(
                title: '因子异常申报详情',
                subTitle1: '$districtName',
                subTitle2: '$enterName',
                subTitle3: '$enterAddress',
                imagePath: 'assets/images/report_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_pink.png',
                color: Colours.background_pink,
              );
            },
          ),
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
                  errorMessage: 'BlocBuilder监听到未知的的状态！state=$state',
                  onReloadTap: () => _loadData(),
                );
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
                  imagePath: 'assets/images/icon_baseinfo.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '监控点名：${reportDetail.monitorName}',
                      icon: Icons.linked_camera,
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
                      content: '报警类型：${reportDetail.alarmTypeStr}',
                      icon: Icons.alarm,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '异常因子：${reportDetail.factorCodeStr}',
                      icon: Icons.error_outline,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '异常原因：${reportDetail.exceptionReason}',
                      icon: Icons.event_note,
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
                  imagePath: 'assets/images/icon_attachment.png',
                ),
                Gaps.vGap10,
                reportDetail.attachments.length == 0
                    ? const Text(
                        '没有上传证明材料',
                        style: TextStyle(fontSize: 13),
                      )
                    : Column(
                        children: () {
                          return reportDetail.attachments.map((attachment) {
                            return AttachmentWidget(
                                attachment: attachment, onTap: () {});
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
                  height: 160,
                  child: Row(
                    children: <Widget>[
                      InkWellButton8(
                        meta: Meta(
                          title: '企业信息',
                          content: '查看该申报单所属的企业信息',
                          backgroundPath:
                              'assets/images/button_bg_lightblue.png',
                          imagePath:
                              'assets/images/image_enter_statistics1.png',
                          router:
                              '${Routes.enterDetail}/${reportDetail.enterId}',
                        ),
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
                                backgroundPath:
                                    'assets/images/button_bg_yellow.png',
                                imagePath:
                                    'assets/images/image_enter_statistics3.png',
                                router:
                                    '${Routes.dischargeDetail}/${reportDetail.dischargeId}',
                              ),
                            ),
                            Gaps.vGap10,
                            InkWellButton7(
                              meta: Meta(
                                title: '在线数据',
                                content: '查看该申报单对应的在线数据',
                                backgroundPath:
                                    'assets/images/button_bg_red.png',
                                imagePath:
                                    'assets/images/image_enter_statistics2.png',
                                router:
                                    '${Routes.monitorDetail}/${reportDetail.monitorId}',
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
          ),
        ],
      ),
    );
  }
}
