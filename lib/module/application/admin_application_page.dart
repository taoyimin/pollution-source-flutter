import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';

class AdminApplicationPage extends StatefulWidget {
  AdminApplicationPage({Key key}) : super(key: key);

  @override
  _AdminApplicationPageState createState() => _AdminApplicationPageState();
}

class _AdminApplicationPageState extends State<AdminApplicationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Color(0xFF19CABA),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          EasyRefresh.custom(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 150,
                        color: Color(0xFF19CABA),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              right: 10,
                              bottom: 10,
                              top: 36,
                              left: 130,
                              child: Image.asset(
                                'assets/images/application_image_header.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              top: 50,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 90,
                                    child: const Text(
                                      '应用',
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.white),
                                    ),
                                  ),
                                  Gaps.vGap10,
                                  Container(
                                    width: 90,
                                    child: const Text(
                                      '污染源应用功能列表',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //基础数据查询
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ImageTitleWidget(
                                title: '基础数据查询',
                                imagePath:
                                    'assets/images/icon_enter_other_info.png'),
                            //Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                InkWellButton9(
                                  meta: Meta(
                                      title: '企业信息',
                                      content: '查询企业列表',
                                      imagePath:
                                          'assets/images/application_icon_enter.png'),
                                  onTap: () {
                                    Application.router.navigateTo(
                                        context, '${Routes.enterList}');
                                  },
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                      title: '在线数据',
                                      content: '查询在线数据',
                                      imagePath:
                                          'assets/images/application_icon_monitor.png'),
                                  onTap: () {
                                    Application.router.navigateTo(
                                        context, '${Routes.monitorList}');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //异常申报查询
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ImageTitleWidget(
                                title: '异常申报查询',
                                imagePath:
                                    'assets/images/icon_alarm_error.png'),
                            Row(
                              children: <Widget>[
                                InkWellButton9(
                                  meta: Meta(
                                      title: '排口异常',
                                      content: '排口异常列表',
                                      imagePath:
                                          'assets/images/application_icon_discharge_report.png'),
                                  onTap: () {
                                    Application.router.navigateTo(context,
                                        '${Routes.dischargeReportList}');
                                  },
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                      title: '因子异常',
                                      content: '因子异常列表',
                                      imagePath:
                                          'assets/images/application_icon_factor_report.png'),
                                  onTap: () {
                                    Application.router.navigateTo(
                                        context, '${Routes.factorReportList}');
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                InkWellButton9(
                                  meta: Meta(
                                      title: '长期停产',
                                      content: '长期停产列表',
                                      imagePath:
                                          'assets/images/application_icon_longStop_report.png'),
                                  onTap: () {
                                    Application.router.navigateTo(context,
                                        '${Routes.longStopReportList}');
                                  },
                                ),
                                Gaps.hGap20,
                                Expanded(child: Gaps.empty),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //报警管理单查询
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ImageTitleWidget(
                                title: '报警管理单查询',
                                imagePath:
                                    'assets/images/application_icon_alarm.png'),
                            Row(
                              children: <Widget>[
                                InkWellButton9(
                                  meta: Meta(
                                      title: '待办督办单',
                                      content: '查询待办督办单',
                                      imagePath:
                                      'assets/images/application_icon_order.png'),
                                  onTap: () {
                                    Application.router.navigateTo(
                                        context, '${Routes.orderList}?state=2');
                                  },
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                      title: '全部督办单',
                                      content: '查询全部督办单',
                                      imagePath:
                                          'assets/images/application_icon_order.png'),
                                  onTap: () {
                                    Application.router.navigateTo(
                                        context, '${Routes.orderList}');
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
