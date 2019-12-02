import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/license/list/license_list_bloc.dart';
import 'package:pollution_source/module/license/list/license_list_page.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_bloc.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_page.dart';
import 'package:pollution_source/module/order/list/order_list_bloc.dart';
import 'package:pollution_source/module/order/list/order_list_page.dart';
import 'package:pollution_source/module/report/discharge/list/discharge_report_list_bloc.dart';
import 'package:pollution_source/module/report/discharge/list/discharge_report_list_page.dart';
import 'package:pollution_source/module/report/factor/list/factor_report_list_bloc.dart';
import 'package:pollution_source/module/report/factor/list/factor_report_list_page.dart';
import 'package:pollution_source/module/report/longstop/list/long_stop_report_list_bloc.dart';
import 'package:pollution_source/module/report/longstop/list/long_stop_report_list_page.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/widget/space_header.dart';

import 'enter_detail.dart';

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

  EnterDetailBloc _enterDetailBloc;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _enterDetailBloc = BlocProvider.of<EnterDetailBloc>(context);
    _refreshCompleter = Completer<void>();
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
          BlocListener<EnterDetailBloc, EnterDetailState>(
            listener: (context, state) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            },
            child: BlocBuilder<EnterDetailBloc, EnterDetailState>(
              builder: (context, state) {
                if (state is EnterDetailLoading) {
                  return PageLoadingWidget();
                } else if (state is EnterDetailEmpty) {
                  return PageEmptyWidget();
                } else if (state is EnterDetailError) {
                  return PageErrorWidget(errorMessage: state.errorMessage);
                } else if (state is EnterDetailLoaded) {
                  return _buildPageLoadedDetail(state.enterDetail);
                } else {
                  return PageErrorWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
                }
              },
            ),
          ),
        ],
        onRefresh: () async {
          _enterDetailBloc.add(EnterDetailLoad(enterId: widget.enterId));
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
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
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
                      ratio: 1.2,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => OrderListBloc(),
                                child: OrderListPage(
                                  state: '5',
                                  enterId: enterDetail.enterId,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      meta: Meta(
                        color: Color(0xFF45C4FF),
                        title: '已办结',
                        content: '${enterDetail.orderCompleteCount}',
                        imagePath:
                            'assets/images/icon_alarm_manage_complete.png',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton5(
                      ratio: 1.2,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => OrderListBloc(),
                                child: OrderListPage(
                                  enterId: enterDetail.enterId,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      meta: Meta(
                        color: Color(0xFFFFB709),
                        title: '全部',
                        content: '${enterDetail.orderTotalCount}',
                        imagePath: 'assets/images/icon_alarm_manage_all.png',
                      ),
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
                    InkWellButton3(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => LongStopReportListBloc(),
                                child: LongStopReportListPage(
                                  enterId: enterDetail.enterId,
                                ),
                              );
                            },
                          ),
                        );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => DischargeReportListBloc(),
                                child: DischargeReportListPage(
                                  enterId: enterDetail.enterId,
                                ),
                              );
                            },
                          ),
                        );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => FactorReportListBloc(),
                                child: FactorReportListPage(
                                  enterId: enterDetail.enterId,
                                ),
                              );
                            },
                          ),
                        );
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BlocProvider(
                                      builder: (context) => MonitorListBloc(),
                                      child: MonitorListPage(
                                        enterId: enterDetail.enterId,
                                      ),
                                    );
                                  },
                                ),
                              );
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BlocProvider(
                                      builder: (context) => MonitorListBloc(),
                                      child: MonitorListPage(
                                        state: '1',
                                        enterId: enterDetail.enterId,
                                      ),
                                    );
                                  },
                                ),
                              );
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BlocProvider(
                                      builder: (context) => MonitorListBloc(),
                                      child: MonitorListPage(
                                        state: '2',
                                        enterId: enterDetail.enterId,
                                      ),
                                    );
                                  },
                                ),
                              );
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BlocProvider(
                                      builder: (context) => MonitorListBloc(),
                                      child: MonitorListPage(
                                        state: '3',
                                        enterId: enterDetail.enterId,
                                      ),
                                    );
                                  },
                                ),
                              );
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BlocProvider(
                                      builder: (context) => MonitorListBloc(),
                                      child: MonitorListPage(
                                        state: '4',
                                        enterId: enterDetail.enterId,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          VerticalDividerWidget(height: 30),
                          //停产
                          InkWellButton1(
                            meta: Meta(
                              title: '停产',
                              imagePath: 'assets/images/icon_monitor_stop.png',
                              color: Color.fromRGBO(137, 137, 137, 1),
                              content: '${enterDetail.monitorStopCount}',
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BlocProvider(
                                      builder: (context) => MonitorListBloc(),
                                      child: MonitorListPage(
                                        state: '5',
                                        enterId: enterDetail.enterId,
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
                    color: Colors.pink,
                    imagePath: 'assets/images/discharge_permit.png',
                    backgroundPath: 'assets/images/button_bg_red.png',
                  ),
                  onTap: () {
                    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return BlocProvider(
                        builder: (context) => LicenseListBloc(),
                        child: LicenseListPage(
                          enterId: enterDetail.enterId,
                        ),
                      );
                    }));*/
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
