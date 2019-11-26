import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/enter/list/enter_list_bloc.dart';
import 'package:pollution_source/module/enter/list/enter_list_page.dart';
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
import 'package:pollution_source/res/gaps.dart';

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
                              right: 20,
                              bottom: 10,
                              child: Image.asset(
                                'assets/images/application_image_header.png',
                                height: 105,
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
                          vertical: 10,
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return BlocProvider(
                                            builder: (context) =>
                                                EnterListBloc(),
                                            child: EnterListPage(),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                Gaps.hGap20,
                                InkWellButton9(
                                  meta: Meta(
                                      title: '监测数据',
                                      content: '查询监测数据',
                                      imagePath:
                                          'assets/images/application_icon_monitor.png'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return BlocProvider(
                                            builder: (context) =>
                                                MonitorListBloc(),
                                            child: MonitorListPage(state: '0'),
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
                      //异常申报查询
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return BlocProvider(
                                            builder: (context) =>
                                                DischargeReportListBloc(),
                                            child: DischargeReportListPage(),
                                          );
                                        },
                                      ),
                                    );
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return BlocProvider(
                                            builder: (context) =>
                                                FactorReportListBloc(),
                                            child: FactorReportListPage(),
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
                                InkWellButton9(
                                  meta: Meta(
                                      title: '长期停产',
                                      content: '长期停产列表',
                                      imagePath:
                                          'assets/images/application_icon_longStop_report.png'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return BlocProvider(
                                            builder: (context) =>
                                                LongStopReportListBloc(),
                                            child: LongStopReportListPage(),
                                          );
                                        },
                                      ),
                                    );
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
                          vertical: 10,
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return BlocProvider(
                                            builder: (context) =>
                                                OrderListBloc(),
                                            child: OrderListPage(),
                                          );
                                        },
                                      ),
                                    );
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
    /*return Column(
      children: <Widget>[
        Container(
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/button_bg_green.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 20,
                bottom: 10,
                child: Image.asset(
                  'assets/images/application_image_header.png',
                  height: 105,
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 90,
                      child: const Text(
                        '应用',
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                    Gaps.vGap10,
                    Container(
                      width: 90,
                      child: const Text(
                        '污染源应用功能列表',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
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
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ImageTitleWidget(
                  title: '基础数据查询',
                  imagePath: 'assets/images/icon_enter_other_info.png'),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BlocProvider(
                              builder: (context) => EnterListBloc(),
                              child: EnterListPage(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Gaps.hGap20,
                  InkWellButton9(
                    meta: Meta(
                        title: '监测数据',
                        content: '查询监测数据',
                        imagePath:
                        'assets/images/application_icon_monitor.png'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BlocProvider(
                              builder: (context) => MonitorListBloc(),
                              child: MonitorListPage(state: '0'),
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
        //异常申报查询
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ImageTitleWidget(
                  title: '异常申报查询',
                  imagePath: 'assets/images/icon_alarm_error.png'),
              Row(
                children: <Widget>[
                  InkWellButton9(
                    meta: Meta(
                        title: '排口异常',
                        content: '排口异常列表',
                        imagePath:
                        'assets/images/application_icon_discharge_report.png'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BlocProvider(
                              builder: (context) => DischargeReportListBloc(),
                              child: DischargeReportListPage(),
                            );
                          },
                        ),
                      );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BlocProvider(
                              builder: (context) => FactorReportListBloc(),
                              child: FactorReportListPage(),
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
                  InkWellButton9(
                    meta: Meta(
                        title: '长期停产',
                        content: '长期停产列表',
                        imagePath:
                        'assets/images/application_icon_longStop_report.png'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BlocProvider(
                              builder: (context) => LongStopReportListBloc(),
                              child: LongStopReportListPage(),
                            );
                          },
                        ),
                      );
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
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ImageTitleWidget(
                  title: '报警管理单查询',
                  imagePath: 'assets/images/application_icon_alarm.png'),
              Row(
                children: <Widget>[
                  InkWellButton9(
                    meta: Meta(
                        title: '报警管理单',
                        content: '报警管理单列表',
                        imagePath:
                        'assets/images/application_icon_alarm.png'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BlocProvider(
                              builder: (context) => OrderListBloc(),
                              child: OrderListPage(),
                            );
                          },
                        ),
                      );
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
    );*/
  }
}
