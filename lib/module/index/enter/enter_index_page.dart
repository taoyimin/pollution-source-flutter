import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:pollution_source/util/ui_utils.dart';
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

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    _refreshCompleter = Completer<void>();
    SystemUtils.checkUpdate(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: EasyRefresh.custom(
        header: SpaceHeader(),
        firstRefresh: true,
        firstRefreshWidget: Gaps.empty,
        slivers: <Widget>[
          BlocListener<DetailBloc, DetailState>(
            listener: (context, state) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            },
            //生成body
            child: BlocBuilder<DetailBloc, DetailState>(
              condition: (previousState, state) {
                //刷新时，不重构Widget，因为header已经有加载动画了
                if (state is DetailLoading)
                  return false;
                else
                  return true;
              },
              builder: (context, state) {
                if (state is DetailLoading) {
                  return LoadingSliver();
                } else if (state is DetailError) {
                  return ErrorSliver(errorMessage: state.message);
                } else if (state is DetailLoaded) {
                  return _buildPageLoadedDetail(state.detail);
                } else {
                  return ErrorSliver(
                      errorMessage: 'BlocBuilder监听到未知的的状态!state=$state');
                }
              },
            ),
          ),
        ],
        onRefresh: () async {
          _detailBloc.add(DetailLoad(detailId: widget.enterId));
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
                  top: 45,
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
                      Gaps.vGap10,
                      Container(
                        width: 180,
                        child: Text(
                          '${enterDetail.enterAddress}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
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
                      onTap: () {
                        Application.router.navigateTo(context,
                            '${Routes.orderList}?enterId=${widget.enterId}&state=2');
                      },
                      meta: Meta(
                        color: Color(0xFF45C4FF),
                        title: '待处理',
                        content: '${enterDetail.orderDealCount??''}',
                        imagePath: 'assets/images/icon_alarm_manage_all.png',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton5(
                      onTap: () {
                        Application.router.navigateTo(context,
                            '${Routes.orderList}?enterId=${widget.enterId}&state=2&alarmLevel=3');
                      },
                      meta: Meta(
                        color: Color(0xFFFFB709),
                        title: '超期待办',
                        content: '${enterDetail.orderOverdueCount??''}',
                        imagePath: 'assets/images/icon_alarm_manage_complete.png',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton5(
                      onTap: () {
                        Application.router.navigateTo(context,
                            '${Routes.orderList}?enterId=${widget.enterId}&state=4');
                      },
                      meta: Meta(
                        color: Color(0xFFFD6C6B),
                        title: '已退回',
                        content: '${enterDetail.orderReturnCount??''}',
                        imagePath:
                        'assets/images/icon_alarm_manage_return.png',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
//          Padding(
//            padding: const EdgeInsets.symmetric(
//              horizontal: 20,
//              vertical: 10,
//            ),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                ImageTitleWidget(
//                  title: '报警管理单',
//                  imagePath: 'assets/images/icon_alarm_manage.png',
//                ),
//                Gaps.vGap10,
//                Row(
//                  children: <Widget>[
//                    InkWellButton5(
//                      ratio: 1.2,
//                      onTap: () {
//                        Application.router.navigateTo(
//                            context, '${Routes.orderList}?enterId=${widget.enterId}&state=5');
//                      },
//                      meta: Meta(
//                        color: Color(0xFF45C4FF),
//                        title: '已办结',
//                        content: '${enterDetail.orderCompleteCount}',
//                        imagePath:
//                            'assets/images/icon_alarm_manage_complete.png',
//                      ),
//                    ),
//                    Gaps.hGap10,
//                    InkWellButton5(
//                      ratio: 1.2,
//                      onTap: () {
//                        Application.router.navigateTo(
//                            context, '${Routes.orderList}?enterId=${widget.enterId}');
//                      },
//                      meta: Meta(
//                        color: Color(0xFFFFB709),
//                        title: '全部',
//                        content: '${enterDetail.orderTotalCount}',
//                        imagePath: 'assets/images/icon_alarm_manage_all.png',
//                      ),
//                    ),
//                  ],
//                ),
//              ],
//            ),
//          ),
          //异常申报信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '异常申报(有效数)',
                  imagePath: 'assets/images/icon_outlet_report.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    InkWellButton3(
                      onTap: () {
                        Application.router.navigateTo(context,
                            '${Routes.longStopReportList}?enterId=${enterDetail.enterId}&valid=0');
                      },
                      meta: Meta(
                        title: '长期停产申报',
                        content: '${enterDetail.longStopReportTotalCount}',
                        imagePath: 'assets/images/button_image2.png',
                        backgroundPath: 'assets/images/button_bg_lightblue.png',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton3(
                      onTap: () {
                        Application.router.navigateTo(context,
                            '${Routes.dischargeReportList}?enterId=${enterDetail.enterId}&valid=0');
                      },
                      meta: Meta(
                        title: '排口异常申报',
                        content: '${enterDetail.dischargeReportTotalCount}',
                        imagePath: 'assets/images/button_image1.png',
                        backgroundPath: 'assets/images/button_bg_green.png',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton3(
                      onTap: () {
                        Application.router.navigateTo(context,
                            '${Routes.factorReportList}?enterId=${enterDetail.enterId}&valid=0');
                      },
                      meta: Meta(
                        title: '因子异常申报',
                        content: '${enterDetail.factorReportTotalCount}',
                        imagePath: 'assets/images/button_image4.png',
                        backgroundPath: 'assets/images/button_bg_pink.png',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //监控点信息
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '监控点信息',
                  imagePath: 'assets/images/icon_monitor_info.png',
                ),
                Gaps.vGap10,
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      UIUtils.getBoxShadow(),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          //全部
                          InkWellButton1(
                            meta: Meta(
                              title: '全部',
                              imagePath: 'assets/images/icon_monitor_all.png',
                              color: Color.fromRGBO(77, 167, 248, 1),
                              content: '${enterDetail.monitorTotalCount}',
                            ),
                            onTap: () {
                              Application.router.navigateTo(
                                  context, '${Routes.monitorList}?enterId=${enterDetail.enterId}');
                            },
                          ),
                          VerticalDividerWidget(height: 30),
                          //在线
                          InkWellButton1(
                            meta: Meta(
                              title: '在线',
                              imagePath:
                                  'assets/images/icon_monitor_online.png',
                              color: Color.fromRGBO(136, 191, 89, 1),
                              content: '${enterDetail.monitorOnlineCount}',
                            ),
                            onTap: () {
                              Application.router.navigateTo(
                                  context, '${Routes.monitorList}?enterId=${enterDetail.enterId}&state=1');
                            },
                          ),
                          VerticalDividerWidget(height: 30),
                          //预警
                          InkWellButton1(
                            meta: Meta(
                              title: '预警',
                              imagePath: 'assets/images/icon_monitor_alarm.png',
                              color: Color.fromRGBO(241, 190, 67, 1),
                              content: '${enterDetail.monitorAlarmCount}',
                            ),
                            onTap: () {
                              Application.router.navigateTo(
                                  context, '${Routes.monitorList}?enterId=${enterDetail.enterId}&state=2');
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          //超标
                          InkWellButton1(
                            meta: Meta(
                              title: '超标',
                              imagePath: 'assets/images/icon_monitor_over.png',
                              color: Color.fromRGBO(233, 119, 111, 1),
                              content: '${enterDetail.monitorOverCount}',
                            ),
                            onTap: () {
                              Application.router.navigateTo(
                                  context, '${Routes.monitorList}?enterId=${enterDetail.enterId}&state=3');
                            },
                          ),
                          VerticalDividerWidget(height: 30),
                          //脱机
                          InkWellButton1(
                            meta: Meta(
                              title: '脱机',
                              imagePath:
                                  'assets/images/icon_monitor_offline.png',
                              color: Color.fromRGBO(179, 129, 127, 1),
                              content: '${enterDetail.monitorOfflineCount}',
                            ),
                            onTap: () {
                              Application.router.navigateTo(
                                  context, '${Routes.monitorList}?enterId=${enterDetail.enterId}&state=4');
                            },
                          ),
                          VerticalDividerWidget(height: 30),
                          //异常
                          InkWellButton1(
                            meta: Meta(
                              title: '异常',
                              imagePath: 'assets/images/icon_monitor_stop.png',
                              color: Color.fromRGBO(137, 137, 137, 1),
                              content: '${enterDetail.monitorStopCount}',
                            ),
                            onTap: () {
                              Application.router.navigateTo(
                                  context, '${Routes.monitorList}?enterId=${enterDetail.enterId}&state=5');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //排污许可证信息
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
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
                  ),
                  onTap: () {
                    Application.router.navigateTo(context,
                        '${Routes.licenseList}?enterId=${enterDetail.enterId}');
                  },
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
