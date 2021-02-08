import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/util/common_utils.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/config_utils.dart';
import 'package:pollution_source/util/system_utils.dart';

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
                                ConfigUtils.getApplicationHeaderImage(),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              top: SystemUtils.isWeb ? 40 : 50,
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
                      // 基础数据查询
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
                                    'assets/images/icon_data_query.png'),
                            //Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                InkWellButton9(
                                  meta: Meta(
                                    title: '企业信息',
                                    content: '查询企业列表',
                                    imagePath:
                                        'assets/images/application_icon_enter.png',
                                    router:
                                        '${Routes.enterList}?attentionLevel=${SpUtil.getString(Constant.spAttentionLevel, defValue: '')}',
                                  ),
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                    title: '在线数据',
                                    content: '查询在线数据',
                                    imagePath:
                                        'assets/images/application_icon_monitor.png',
                                    router:
                                        '${Routes.monitorList}?attentionLevel=${SpUtil.getString(Constant.spAttentionLevel, defValue: '')}&outType=' + CommonUtils.getOutTypeByGobalLevel() + '&state=online',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // 异常申报查询
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
                                        'assets/images/application_icon_discharge_report.png',
                                    router: '${Routes.dischargeReportList}?attentionLevel=${SpUtil.getString(Constant.spAttentionLevel, defValue: '')}&startTime=${DateUtil.formatDate(DateTime(DateTime.now().year, 1, 1), format: DateFormats.y_mo_d)}',
                                  ),
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                    title: '因子异常',
                                    content: '因子异常列表',
                                    imagePath:
                                        'assets/images/application_icon_factor_report.png',
                                    router: '${Routes.factorReportList}?attentionLevel=${SpUtil.getString(Constant.spAttentionLevel, defValue: '')}&startTime=${DateUtil.formatDate(DateTime(DateTime.now().year, 1, 1), format: DateFormats.y_mo_d)}',
                                  ),
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
                                        'assets/images/application_icon_longStop_report.png',
                                    router: '${Routes.longStopReportList}?attentionLevel=${SpUtil.getString(Constant.spAttentionLevel, defValue: '')}&startTime=${DateUtil.formatDate(DateTime(DateTime.now().year, 1, 1), format: DateFormats.y_mo_d)}',
                                  ),
                                ),
                                Gaps.hGap20,
                                Expanded(child: Gaps.empty),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // 报警管理单查询
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
                                    title: '未办结督办单',
                                    content: '查询待办督办单',
                                    imagePath:
                                        'assets/images/application_icon_order.png',
                                    router:
                                        '${Routes.orderList}?alarmState=00&attentionLevel=${SpUtil.getString(Constant.spAttentionLevel, defValue: '')}',
                                  ),
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                    title: '全部督办单',
                                    content: '查询全部督办单',
                                    imagePath:
                                        'assets/images/application_icon_order.png',
                                    router: '${Routes.orderList}?attentionLevel=${SpUtil.getString(Constant.spAttentionLevel, defValue: '')}',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                InkWellButton9(
                                  meta: Meta(
                                    title: '实时预警单',
                                    content: '查询实时预警单',
                                    imagePath:
                                        'assets/images/application_icon_enter.png',
                                    router: '${Routes.warnList}',
                                  ),
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                    title: '历史预警消息',
                                    content: '查询历史推送',
                                    imagePath:
                                        'assets/images/application_icon_monitor.png',
                                    router: '${Routes.noticeList}',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // 异常申报上报
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
                                        'assets/images/application_icon_discharge_report.png',
                                    router: '${Routes.dischargeReportUpload}',
                                  ),
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                    title: '因子异常',
                                    content: '因子异常上报',
                                    imagePath:
                                        'assets/images/application_icon_factor_report.png',
                                    router: '${Routes.factorReportUpload}',
                                  ),
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
                                        'assets/images/application_icon_longStop_report.png',
                                    router: '${Routes.longStopReportUpload}',
                                  ),
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
