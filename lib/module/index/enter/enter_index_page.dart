import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/collection/collection_bloc.dart';
import 'package:pollution_source/module/common/collection/collection_event.dart';
import 'package:pollution_source/module/common/collection/monitor/monitor_statistics_repository.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/widget/space_header.dart';

class EnterIndexPage extends StatefulWidget {
  final String enterId;

  EnterIndexPage({@required this.enterId}) : assert(enterId != null);

  @override
  _EnterIndexPageState createState() => _EnterIndexPageState();
}

class _EnterIndexPageState extends State<EnterIndexPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  DetailBloc _detailBloc;
  Completer<void> _refreshCompleter;

  /// 监控点统计Bloc
  final CollectionBloc monitorStatisticsBloc =
      CollectionBloc(collectionRepository: MonitorStatisticsRepository());
  final EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    _refreshCompleter = Completer<void>();
  }

  @override
  void dispose() {
    // 释放资源
    _refreshController.dispose();
    super.dispose();
  }

  /// 获取监控点统计接口请求参数
  Map<String, dynamic> _getRequestParam() {
    return MonitorStatisticsRepository.createParams(
      userType: '2',
      enterId: widget.enterId,
      outType: '',
      attentionLevel: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: EasyRefresh.custom(
        controller: _refreshController,
        header: SpaceHeader(),
        firstRefresh: true,
        firstRefreshWidget: Gaps.empty,
        slivers: <Widget>[
          BlocConsumer<DetailBloc, DetailState>(
            listener: (context, state) {
              if (state is DetailLoading) return;
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            },
            buildWhen: (previous, current) {
              if (current is DetailLoading)
                return false;
              else
                return true;
            },
            builder: (context, state) {
              if (state is DetailLoading) {
                return LoadingSliver();
              } else if (state is DetailError) {
                return ErrorSliver(
                  errorMessage: state.message,
                  onReloadTap: () => _refreshController.callRefresh(),
                );
              } else if (state is DetailLoaded) {
                return _buildPageLoadedDetail(state.detail);
              } else {
                return ErrorSliver(
                  errorMessage: 'BlocBuilder监听到未知的的状态!state=$state',
                  onReloadTap: () => _refreshController.callRefresh(),
                );
              }
            },
          ),
        ],
        onRefresh: () async {
          _detailBloc.add(DetailLoad(detailId: widget.enterId));
          // 加载监控点统计信息
          monitorStatisticsBloc.add(CollectionLoad(params: _getRequestParam()));
          return _refreshCompleter.future;
        },
      ),
    );
  }

  Widget _buildPageLoadedDetail(EnterDetail enterDetail) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            color: Colours.primary_color,
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: 20,
                  bottom: 10,
                  child: Image.asset(
                    'assets/images/enter_index_image_header.png',
                    height: 105,
                  ),
                ),
                Positioned(
                  top: 35,
                  left: 20,
                  bottom: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: 190,
                        child: Text(
                          '${enterDetail.enterName}',
                          style: const TextStyle(
                              fontSize: 17, color: Colors.white),
                        ),
                      ),
                      Container(
                        width: 180,
                        child: Text(
                          '${enterDetail.enterAddress}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //基本信息
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10
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
                      content: '关注程度：${enterDetail.attentionLevelStr}',
                      icon: Icons.star,
                      flex: 4,
                    ),
                    Gaps.hGap10,
                    IconBaseInfoWidget(
                      content: '所属区域：${enterDetail.districtName}',
                      icon: Icons.location_on,
                      flex: 5,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '行业类别：${enterDetail.industryTypeStr}',
                      icon: Icons.work,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '信用代码：${enterDetail.creditCode}',
                      icon: Icons.mail,
                    ),
                  ],
                ),
              ],
            ),
          ),
          //联系人 没有联系人则隐藏
          Offstage(
            offstage: TextUtil.isEmpty(enterDetail.enterTel) &&
                TextUtil.isEmpty(enterDetail.contactPersonTel) &&
                TextUtil.isEmpty(enterDetail.legalPersonTel),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ImageTitleWidget(
                    title: '企业联系人',
                    imagePath: 'assets/images/icon_enter_contacts.png',
                  ),
                  Offstage(
                    offstage: TextUtil.isEmpty(enterDetail.enterTel),
                    child: ContactsWidget(
                      contactsName: '企业电话',
                      contactsTel: '${enterDetail.enterTel}',
                      imagePath: 'assets/images/enter_enter_tel_header.png',
                    ),
                  ),
                  Offstage(
                    offstage: TextUtil.isEmpty(enterDetail.contactPersonTel),
                    child: ContactsWidget(
                      contactsName: '${enterDetail.contactPerson}(联系人)',
                      contactsTel: '${enterDetail.contactPersonTel}',
                      imagePath: 'assets/images/enter_contacts_tel_header.png',
                    ),
                  ),
                  Offstage(
                    offstage: TextUtil.isEmpty(enterDetail.legalPersonTel),
                    child: ContactsWidget(
                      contactsName: '${enterDetail.legalPerson}(法人)',
                      contactsTel: '${enterDetail.legalPersonTel}',
                      imagePath: 'assets/images/enter_legal_tel_header.png',
                    ),
                  ),
                ],
              ),
            ),
          ),
          //报警管理单
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '报警管理单',
                  imagePath: 'assets/images/icon_alarm_manage.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    InkWellButton5(
                      meta: Meta(
                        color: Color(0xFF45C4FF),
                        title: '待处理',
                        content: '${enterDetail.orderDealCount ?? ''}',
                        imagePath: 'assets/images/icon_alarm_manage_all.png',
                        router:
                            '${Routes.orderList}?enterId=${widget.enterId}&alarmState=20',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton5(
                      meta: Meta(
                        color: Color(0xFFFD6C6B),
                        title: '超期待办',
                        content: '${enterDetail.orderOverdueCount ?? ''}',
                        imagePath:
                            'assets/images/icon_alarm_manage_return.png',
                        router:
                            '${Routes.orderList}?enterId=${widget.enterId}&alarmState=20&alarmLevel=3',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton5(
                      meta: Meta(
                        color: Color(0xFF45C4FF),
                        title: '已办结',
                        content: '${enterDetail.orderCompleteCount ?? ''}',
                        imagePath:
                        'assets/images/icon_alarm_manage_complete.png',
                        router:
                        '${Routes.orderList}?enterId=${widget.enterId}&alarmState=50',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '异常申报(生效中)',
                  imagePath: 'assets/images/icon_outlet_report.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    InkWellButton3(
                      meta: Meta(
                        title: '长期停产申报',
                        content: '${enterDetail.longStopReportTotalCount}',
                        imagePath: 'assets/images/button_image2.png',
                        backgroundPath: 'assets/images/button_bg_lightblue.png',
                        router:
                            '${Routes.longStopReportList}?enterId=${enterDetail.enterId}&valid=0',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton3(
                      meta: Meta(
                        title: '排口异常申报',
                        content: '${enterDetail.dischargeReportTotalCount}',
                        imagePath: 'assets/images/button_image1.png',
                        backgroundPath: 'assets/images/button_bg_green.png',
                        router:
                            '${Routes.dischargeReportList}?enterId=${enterDetail.enterId}&valid=0',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton3(
                      meta: Meta(
                        title: '因子异常申报',
                        content: '${enterDetail.factorReportTotalCount}',
                        imagePath: 'assets/images/button_image4.png',
                        backgroundPath: 'assets/images/button_bg_pink.png',
                        router:
                            '${Routes.factorReportList}?enterId=${enterDetail.enterId}&valid=0',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //监控点信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: MonitorStatisticsCard(
              title: '监控点概况',
              collectionBloc: monitorStatisticsBloc,
              onReloadTap: () {
                monitorStatisticsBloc
                    .add(CollectionLoad(params: _getRequestParam()));
              },
            ),
          ),
          //排污许可证信息
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '排污许可证信息',
                  imagePath: 'assets/images/icon_discharge_permit.png',
                ),
                Gaps.vGap10,
                InkWellButton6(
                  meta: Meta(
                    title: '许可证编号',
                    content: '${enterDetail.licenseNumber}',
                    color: Colours.background_red,
                    imagePath: 'assets/images/discharge_permit.png',
                    backgroundPath: 'assets/images/button_bg_red.png',
                    router:
                        '${Routes.licenseList}?enterId=${enterDetail.enterId}',
                  ),
                ),
              ],
            ),
          ),
          //其他信息
          /*Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '其他信息统计',
                  imagePath: 'assets/images/icon_enter_other_info.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    //监察执法
                    InkWellButton3(
                      meta: Meta(
                        title: "建设项目",
                        content: '${enterDetail.buildProjectCount}',
                        backgroundPath: "assets/images/button_bg_lightblue.png",
                        imagePath: "assets/images/button_image2.png",
                      ),
                      onTap: () {},
                    ),
                    Gaps.hGap10,
                    //项目审批
                    InkWellButton3(
                      meta: Meta(
                        title: "现场执法",
                        content: '${enterDetail.sceneLawCount}',
                        backgroundPath: "assets/images/button_bg_red.png",
                        imagePath: "assets/images/button_image1.png",
                      ),
                      onTap: () {},
                    ),
                    Gaps.hGap10,
                    //信访投诉
                    InkWellButton3(
                      meta: Meta(
                        title: '环境信访',
                        content: '${enterDetail.environmentVisitCount}',
                        backgroundPath: "assets/images/button_bg_yellow.png",
                        imagePath: "assets/images/button_image3.png",
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }
}
