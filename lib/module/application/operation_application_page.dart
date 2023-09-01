import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/config_utils.dart';
import 'package:pollution_source/util/system_utils.dart';

class OperationApplicationPage extends StatefulWidget {
  OperationApplicationPage({Key key}) : super(key: key);

  @override
  _OperationApplicationPageState createState() =>
      _OperationApplicationPageState();
}

class _OperationApplicationPageState extends State<OperationApplicationPage>
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
                                imagePath: 'assets/images/icon_data_query.png'),
                            //Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                InkWellButton9(
                                  meta: Meta(
                                    title: '企业信息',
                                    content: '查询企业列表',
                                    imagePath:
                                        'assets/images/application_icon_enter.png',
                                    router: '${Routes.enterList}',
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
                                        '${Routes.monitorList}?state=online',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // 运维管理上报
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: ConfigUtils.showRoutineInspection()
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ImageTitleWidget(
                                      title: '运维管理上报',
                                      imagePath:
                                          'assets/images/icon_operation_manage_upload.png'),
                                  Row(
                                    children: <Widget>[
                                      InkWellButton9(
                                        meta: Meta(
                                          title: '常规巡检',
                                          content: '常规巡检上报',
                                          imagePath:
                                              'assets/images/application_icon_discharge_report.png',
                                          router:
                                              '${Routes.routineInspectionList}?state=1',
                                        ),
                                      ),
                                      Gaps.hGap20,
                                      InkWellButton9(
                                        meta: Meta(
                                          title: '仪器参数设置',
                                          content: '参数查询与上报',
                                          imagePath:
                                              'assets/images/application_icon_factor_report.png',
                                          router:
                                              '${Routes.waterDeviceParamUpload}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      InkWellButton9(
                                        meta: Meta(
                                          title: '易耗品更换',
                                          content: '易耗品更换上报',
                                          imagePath:
                                              'assets/images/application_icon_longStop_report.png',
                                          router:
                                              '${Routes.consumableReplaceUpload}',
                                        ),
                                      ),
                                      Gaps.hGap20,
                                      InkWellButton9(
                                        meta: Meta(
                                          title: '设备检修',
                                          content: '设备检修上报',
                                          imagePath:
                                              'assets/images/application_icon_enter.png',
                                          router:
                                              '${Routes.deviceRepairUpload}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      InkWellButton9(
                                        meta: Meta(
                                          title: '标准样品更换',
                                          content: '标准品更换上报',
                                          imagePath:
                                              'assets/images/application_icon_monitor.png',
                                          router:
                                              '${Routes.standardReplaceUpload}',
                                        ),
                                      ),
                                      Gaps.hGap20,
                                      Expanded(
                                        flex: 1,
                                        child: Gaps.empty,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ImageTitleWidget(
                                      title: '运维管理上报',
                                      imagePath:
                                          'assets/images/icon_operation_manage_upload.png'),
                                  Row(
                                    children: <Widget>[
                                      InkWellButton9(
                                        meta: Meta(
                                          title: '仪器参数设置',
                                          content: '参数查询与上报',
                                          imagePath:
                                              'assets/images/application_icon_factor_report.png',
                                          router:
                                              '${Routes.waterDeviceParamUpload}',
                                        ),
                                      ),
                                      Gaps.hGap20,
                                      InkWellButton9(
                                        meta: Meta(
                                          title: '易耗品更换',
                                          content: '易耗品更换上报',
                                          imagePath:
                                              'assets/images/application_icon_longStop_report.png',
                                          router:
                                              '${Routes.consumableReplaceUpload}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      InkWellButton9(
                                        meta: Meta(
                                          title: '设备检修',
                                          content: '设备检修上报',
                                          imagePath:
                                              'assets/images/application_icon_enter.png',
                                          router:
                                              '${Routes.deviceRepairUpload}',
                                        ),
                                      ),
                                      Gaps.hGap20,
                                      InkWellButton9(
                                        meta: Meta(
                                          title: '标准样品更换',
                                          content: '标准品更换上报',
                                          imagePath:
                                              'assets/images/application_icon_monitor.png',
                                          router:
                                              '${Routes.standardReplaceUpload}',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                      // 日督办单管理
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ImageTitleWidget(
                                title: '日督办单管理',
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
                                    router: '${Routes.orderList}?type=0&alarmState=00',
                                  ),
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                    title: '全部督办单',
                                    content: '查询全部督办单',
                                    imagePath:
                                        'assets/images/application_icon_order.png',
                                    router: '${Routes.orderList}?type=0',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // 实时预警管理
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ImageTitleWidget(
                                title: ConfigUtils.showRealOrder() ? '小时督办单管理' : '实时预警管理',
                                imagePath:
                                'assets/images/application_icon_alarm.png'),
                            Offstage(
                              offstage: !ConfigUtils.showRealOrder(),
                              child: Row(
                                children: <Widget>[
                                  InkWellButton9(
                                    meta: Meta(
                                      title: '未办结督办单',
                                      content: '查询待办督办单',
                                      imagePath:
                                      'assets/images/application_icon_order.png',
                                      router:
                                      '${Routes.orderList}?type=1&alarmState=00',
                                    ),
                                  ),
                                  Gaps.hGap20,
                                  InkWellButton9(
                                    meta: Meta(
                                      title: '督办单汇总',
                                      content: '查询全部督办单',
                                      imagePath:
                                      'assets/images/application_icon_order.png',
                                      router: '${Routes.orderList}?type=1',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                InkWellButton9(
                                  meta: Meta(
                                    title: '实时异常数据',
                                    content: '查询异常数据',
                                    imagePath:
                                    'assets/images/application_icon_enter.png',
                                    router: '${Routes.warnList}',
                                  ),
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                    title: '历史异常数据',
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
                                    router: '${Routes.dischargeReportList}?startTime=${DateUtil.formatDate(DateTime(DateTime.now().year, 1, 1), format: DateFormats.y_mo_d)}',
                                  ),
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                    title: '因子异常',
                                    content: '因子异常列表',
                                    imagePath:
                                        'assets/images/application_icon_factor_report.png',
                                    router: '${Routes.factorReportList}?startTime=${DateUtil.formatDate(DateTime(DateTime.now().year, 1, 1), format: DateFormats.y_mo_d)}',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // 异常申报上报
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 20,
                      //     vertical: 18,
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       ImageTitleWidget(
                      //           title: '异常申报上报',
                      //           imagePath:
                      //               'assets/images/icon_alarm_manage.png'),
                      //       Row(
                      //         children: <Widget>[
                      //           InkWellButton9(
                      //             meta: Meta(
                      //               title: '排口异常',
                      //               content: '排口异常上报',
                      //               imagePath:
                      //                   'assets/images/application_icon_discharge_report.png',
                      //               router: '${Routes.dischargeReportUpload}',
                      //             ),
                      //           ),
                      //           Gaps.hGap20,
                      //           InkWellButton9(
                      //             meta: Meta(
                      //               title: '因子异常',
                      //               content: '因子异常上报',
                      //               imagePath:
                      //                   'assets/images/application_icon_factor_report.png',
                      //               router: '${Routes.factorReportUpload}',
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // 地图
                      Offstage(
                        offstage: !ConfigUtils.showMap(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ImageTitleWidget(
                                  title: '地图',
                                  imagePath:
                                      'assets/images/icon_alarm_manage.png'),
                              Row(
                                children: <Widget>[
                                  InkWellButton9(
                                    meta: Meta(
                                      title: '监控位置',
                                      content: '查看监控点坐标',
                                      imagePath:
                                          'assets/images/application_icon_discharge_report.png',
                                      router: '${Routes.map}',
                                    ),
                                  ),
                                  Gaps.hGap20,
                                  Expanded(
                                    flex: 1,
                                    child: Gaps.empty,
                                  ),
                                ],
                              ),
                            ],
                          ),
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
