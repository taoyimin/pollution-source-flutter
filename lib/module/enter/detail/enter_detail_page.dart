import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_bloc.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_page.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'enter_detail.dart';

class EnterDetailPage extends StatefulWidget {
  final int enterId;

  EnterDetailPage({@required this.enterId}) : assert(enterId != null);

  @override
  _EnterDetailPageState createState() => _EnterDetailPageState();
}

class _EnterDetailPageState extends State<EnterDetailPage> {
  EnterDetailBloc _enterDetailBloc;

  @override
  void initState() {
    super.initState();
    _enterDetailBloc = BlocProvider.of<EnterDetailBloc>(context);
    _enterDetailBloc.add(EnterDetailLoad(enterId: widget.enterId));
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
          BlocBuilder<EnterDetailBloc, EnterDetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              if (state is EnterDetailLoaded) {
                enterName = state.enterDetail.enterName;
                enterAddress = state.enterDetail.enterAddress;
              }
              return DetailHeaderWidget(
                title: '企业详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/enter_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_lightblue.png',
              );
            },
          ),
          BlocBuilder<EnterDetailBloc, EnterDetailState>(
            builder: (context, state) {
              if (state is EnterDetailLoading) {
                return PageLoadingWidget();
              } else if (state is EnterDetailEmpty) {
                return PageEmptyWidget();
              } else if (state is EnterDetailError) {
                return PageErrorWidget(errorMessage: state.errorMessage);
              } else if (state is EnterDetailLoaded) {
                return SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      //基本信息
                      Container(
                        width: double.infinity,
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
                                  title: '关注程度',
                                  content:
                                      '${state.enterDetail.attentionLevelStr}',
                                  icon: Icons.star,
                                  flex: 4,
                                ),
                                Gaps.hGap20,
                                IconBaseInfoWidget(
                                  title: '所属区域',
                                  content: '${state.enterDetail.areaName}',
                                  icon: Icons.location_on,
                                  flex: 5,
                                ),
                              ],
                            ),
                            Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                IconBaseInfoWidget(
                                  title: '行业类别',
                                  content:
                                      '${state.enterDetail.industryTypeStr}',
                                  icon: Icons.work,
                                  contentTextAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                IconBaseInfoWidget(
                                  title: '信用代码',
                                  content: '${state.enterDetail.creditCode}',
                                  icon: Icons.mail,
                                  contentTextAlign: TextAlign.left,
                                  contentMarginTop: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //联系人 没有联系人则隐藏
                      Offstage(
                        offstage: TextUtil.isEmpty(
                                state.enterDetail.enterTel) &&
                            TextUtil.isEmpty(
                                state.enterDetail.contactPersonTel) &&
                            TextUtil.isEmpty(state.enterDetail.legalPersonTel),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ImageTitleWidget(
                                title: '企业联系人',
                                imagePath:
                                    'assets/images/icon_enter_contacts.png',
                              ),
                              Gaps.vGap10,
                              Offstage(
                                offstage: TextUtil.isEmpty(
                                    state.enterDetail.enterTel),
                                child: ContactsWidget(
                                  contactsName: '企业电话',
                                  contactsTel: '${state.enterDetail.enterTel}',
                                ),
                              ),
                              Gaps.vGap10,
                              Offstage(
                                offstage: TextUtil.isEmpty(
                                    state.enterDetail.contactPersonTel),
                                child: ContactsWidget(
                                  contactsName:
                                      '${state.enterDetail.contactPerson}(联系人)',
                                  contactsTel:
                                      '${state.enterDetail.contactPersonTel}',
                                ),
                              ),
                              Gaps.vGap10,
                              Offstage(
                                offstage: TextUtil.isEmpty(
                                    state.enterDetail.legalPersonTel),
                                child: ContactsWidget(
                                  contactsName:
                                      '${state.enterDetail.legalPerson}(法人)',
                                  contactsTel:
                                      '${state.enterDetail.legalPersonTel}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //报警管理单
                      Container(
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
                                  onTap: () {},
                                  meta: Meta(
                                    color: Color(0xFF45C4FF),
                                    title: '已办结',
                                    content:
                                        '${state.enterDetail.orderCompleteCount}',
                                    imagePath:
                                        'assets/images/icon_alarm_manage_complete.png',
                                  ),
                                ),
                                Gaps.hGap10,
                                InkWellButton5(
                                  ratio: 1.2,
                                  onTap: () {},
                                  meta: Meta(
                                    color: Color(0xFFFFB709),
                                    title: '全部',
                                    content: '${state.enterDetail.orderTotalCount}',
                                    imagePath:
                                        'assets/images/icon_alarm_manage_all.png',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //异常申报信息
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
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
                                /*InkWellButton4(
                                  ratio: 1.3,
                                  titleFontSize: 9.5,
                                  contentFontSize: 19,
                                  contentMarginRight: 50,
                                  onTap: () {},
                                  meta: Meta(
                                    title: '排口异常申报有效数',
                                    content:
                                        '${state.enterDetail.monitorReportValid}',
                                    imagePath:
                                        'assets/images/button_image2.png',
                                    backgroundPath:
                                        'assets/images/button_bg_blue.png',
                                  ),
                                ),*/
                                InkWellButton4(
                                  ratio: 1.3,
                                  titleFontSize: 9.5,
                                  contentFontSize: 19,
                                  contentMarginRight: 50,
                                  onTap: () {},
                                  meta: Meta(
                                    title: '排口异常申报总数',
                                    content:
                                        '${state.enterDetail.monitorReportTotalCount}',
                                    imagePath:
                                        'assets/images/button_image1.png',
                                    backgroundPath:
                                        'assets/images/button_bg_pink.png',
                                  ),
                                ),
                                Gaps.hGap10,
                                InkWellButton4(
                                  ratio: 1.3,
                                  titleFontSize: 9.5,
                                  contentFontSize: 19,
                                  contentMarginRight: 50,
                                  onTap: () {},
                                  meta: Meta(
                                    title: '因子异常申报总数',
                                    content:
                                    '${state.enterDetail.factorReportTotalCount}',
                                    imagePath:
                                    'assets/images/button_image4.png',
                                    backgroundPath:
                                    'assets/images/button_bg_yellow.png',
                                  ),
                                ),
                              ],
                            ),
                            /*Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                InkWellButton4(
                                  ratio: 1.3,
                                  titleFontSize: 9.5,
                                  contentFontSize: 19,
                                  contentMarginRight: 50,
                                  onTap: () {},
                                  meta: Meta(
                                    title: '因子异常申报有效数',
                                    content:
                                        '${state.enterDetail.factorReportValid}',
                                    imagePath:
                                        'assets/images/button_image3.png',
                                    backgroundPath:
                                        'assets/images/button_bg_green.png',
                                  ),
                                ),
                                Gaps.hGap10,
                                InkWellButton4(
                                  ratio: 1.3,
                                  titleFontSize: 9.5,
                                  contentFontSize: 19,
                                  contentMarginRight: 50,
                                  onTap: () {},
                                  meta: Meta(
                                    title: '因子异常申报总数',
                                    content:
                                        '${state.enterDetail.factorReportAll}',
                                    imagePath:
                                        'assets/images/button_image4.png',
                                    backgroundPath:
                                        'assets/images/button_bg_yellow.png',
                                  ),
                                ),
                              ],
                            ),*/
                          ],
                        ),
                      ),
                      //监控点信息
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                          imagePath:
                                              'assets/images/icon_monitor_all.png',
                                          color:
                                              Color.fromRGBO(77, 167, 248, 1),
                                          content:
                                              '${state.enterDetail.monitorTotalCount}',
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return BlocProvider(
                                                builder: (context) =>
                                                    MonitorListBloc(),
                                                child: MonitorListPage(),
                                              );
                                            }),
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
                                          color:
                                              Color.fromRGBO(136, 191, 89, 1),
                                          content:
                                              '${state.enterDetail.monitorOnlineCount}',
                                        ),
                                        onTap: () {},
                                      ),
                                      VerticalDividerWidget(height: 30),
                                      //预警
                                      InkWellButton1(
                                        meta: Meta(
                                          title: '预警',
                                          imagePath:
                                              'assets/images/icon_monitor_alarm.png',
                                          color:
                                              Color.fromRGBO(241, 190, 67, 1),
                                          content:
                                              '${state.enterDetail.monitorAlarmCount}',
                                        ),
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      //超标
                                      InkWellButton1(
                                        meta: Meta(
                                          title: '超标',
                                          imagePath:
                                              'assets/images/icon_monitor_over.png',
                                          color:
                                              Color.fromRGBO(233, 119, 111, 1),
                                          content:
                                              '${state.enterDetail.monitorOverCount}',
                                        ),
                                        onTap: () {},
                                      ),
                                      VerticalDividerWidget(height: 30),
                                      //脱机
                                      InkWellButton1(
                                        meta: Meta(
                                          title: '脱机',
                                          imagePath:
                                              'assets/images/icon_monitor_offline.png',
                                          color:
                                              Color.fromRGBO(179, 129, 127, 1),
                                          content:
                                              '${state.enterDetail.monitorOfflineCount}',
                                        ),
                                        onTap: () {},
                                      ),
                                      VerticalDividerWidget(height: 30),
                                      //停产
                                      InkWellButton1(
                                        meta: Meta(
                                          title: '停产',
                                          imagePath:
                                              'assets/images/icon_monitor_stop.png',
                                          color:
                                              Color.fromRGBO(137, 137, 137, 1),
                                          content:
                                              '${state.enterDetail.monitorStopCount}',
                                        ),
                                        onTap: () {},
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
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ImageTitleWidget(
                              title: '排污许可证信息',
                              imagePath:
                                  'assets/images/icon_discharge_permit.png',
                            ),
                            Gaps.vGap10,
                            InkWellButton6(
                              meta: Meta(
                                title: '许可证编号',
                                content: '${state.enterDetail.licenseNumber}',
                                color: Colors.pink,
                                imagePath: 'assets/images/discharge_permit.png',
                                backgroundPath:
                                    'assets/images/button_bg_red.png',
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      //其他信息
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ImageTitleWidget(
                              title: '其他信息统计',
                              imagePath:
                                  'assets/images/icon_enter_other_info.png',
                            ),
                            Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                //监察执法
                                InkWellButton3(
                                  meta: Meta(
                                    title: "建设项目",
                                    content:
                                        '${state.enterDetail.buildProjectCount}',
                                    backgroundPath:
                                        "assets/images/button_bg_lightblue.png",
                                    imagePath:
                                        "assets/images/button_image2.png",
                                  ),
                                  onTap: () {},
                                ),
                                Gaps.hGap10,
                                //项目审批
                                InkWellButton3(
                                  meta: Meta(
                                    title: "现场执法",
                                    content: '${state.enterDetail.sceneLawCount}',
                                    backgroundPath:
                                        "assets/images/button_bg_red.png",
                                    imagePath:
                                        "assets/images/button_image1.png",
                                  ),
                                  onTap: () {},
                                ),
                                Gaps.hGap10,
                                //信访投诉
                                InkWellButton3(
                                  meta: Meta(
                                    title: '环境信访',
                                    content:
                                        '${state.enterDetail.environmentVisitCount}',
                                    backgroundPath:
                                        "assets/images/button_bg_yellow.png",
                                    imagePath:
                                        "assets/images/button_image3.png",
                                  ),
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
              } else {
                return SliverFillRemaining();
              }
            },
          ),
        ],
      ),
    );
  }
}
