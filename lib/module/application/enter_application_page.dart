import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';

class EnterApplicationPage extends StatefulWidget {
  final String enterId;

  EnterApplicationPage({Key key, @required this.enterId})
      : assert(enterId != null),
        super(key: key);

  @override
  _EnterApplicationPageState createState() => _EnterApplicationPageState();
}

class _EnterApplicationPageState extends State<EnterApplicationPage>
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
                                      title: '排口信息',
                                      content: '查询排口列表',
                                      imagePath:
                                          'assets/images/application_icon_enter.png'),
                                  onTap: () {
                                    Application.router.navigateTo(
                                        context, '${Routes.dischargeList}?enterId=${widget.enterId}');
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
                                        context, '${Routes.monitorList}?enterId=${widget.enterId}');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //异常申报上报
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ImageTitleWidget(
                                title: '异常申报上报',
                                imagePath:
                                    'assets/images/icon_alarm_manage.png'),
                            Row(
                              children: <Widget>[
                                InkWellButton9(
                                  meta: Meta(
                                      title: '排口异常',
                                      content: '排口异常上报',
                                      imagePath:
                                          'assets/images/application_icon_discharge_report.png'),
                                  onTap: () {
                                    Application.router.navigateTo(context,
                                        '${Routes.dischargeReportUpload}?enterId=${widget.enterId}');
                                  },
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                      title: '因子异常',
                                      content: '因子异常上报',
                                      imagePath:
                                          'assets/images/application_icon_factor_report.png'),
                                  onTap: () {
                                    Application.router.navigateTo(context,
                                        '${Routes.factorReportUpload}?enterId=${widget.enterId}');
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                InkWellButton9(
                                  meta: Meta(
                                      title: '长期停产',
                                      content: '长期停产上报',
                                      imagePath:
                                          'assets/images/application_icon_longStop_report.png'),
                                  onTap: () {
                                    Application.router.navigateTo(context,
                                        '${Routes.longStopReportUpload}?enterId=${widget.enterId}');
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
                                      title: '报警管理单',
                                      content: '报警管理单列表',
                                      imagePath:
                                          'assets/images/application_icon_order.png'),
                                  onTap: () {
                                    Application.router.navigateTo(
                                        context, '${Routes.orderList}?enterId=${widget.enterId}');
                                  },
                                ),
                                Gaps.hGap20,
                                Expanded(child: Gaps.empty),
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
