import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_bloc.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_page.dart';
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

class ApplicationPage extends StatefulWidget {
  ApplicationPage({Key key}) : super(key: key);

  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GridView.count(
      //设置padding 防止item阴影被裁剪
      padding: const EdgeInsets.only(top: 46, left: 16, right: 16),
      //primary: false,
      //shrinkWrap: true,
      mainAxisSpacing: 10.0,
      crossAxisCount: 3,
      crossAxisSpacing: 10.0,

      children: <Widget>[
        Center(
          child: InkWellButton(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/aaplication_enter_button.png',
                    height: 50,
                    width: 50,
                  ),
                  Gaps.vGap10,
                  Text('企业列表'),
                ],
              ),
            ],
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
        ),
        Center(
          child: InkWellButton(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/application_discharge_button.png',
                    height: 50,
                    width: 50,
                  ),
                  Gaps.vGap10,
                  Text('排口列表'),
                ],
              ),
            ],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      builder: (context) => DischargeListBloc(),
                      child: DischargeListPage(),
                    );
                  },
                ),
              );
            },
          ),
        ),
        Center(
          child: InkWellButton(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/application_monitor_button.png',
                    height: 50,
                    width: 50,
                  ),
                  Gaps.vGap10,
                  Text('监控点列表'),
                ],
              ),
            ],
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
        ),
        Center(
          child: InkWellButton(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/application_long_stop_button.png',
                    height: 50,
                    width: 50,
                  ),
                  Gaps.vGap10,
                  Text('企业长期停产'),
                ],
              ),
            ],
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
        ),
        Center(
          child: InkWellButton(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/application_discharge_report_button.png',
                    height: 50,
                    width: 50,
                  ),
                  Gaps.vGap10,
                  Text('排口异常申报'),
                ],
              ),
            ],
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
        ),
        Center(
          child: InkWellButton(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/application_factor_report_button.png',
                    height: 50,
                    width: 50,
                  ),
                  Gaps.vGap10,
                  Text('因子异常申报'),
                ],
              ),
            ],
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
        ),
        Center(
          child: InkWellButton(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/application_order_button.png',
                    height: 50,
                    width: 50,
                  ),
                  Gaps.vGap10,
                  Text('报警管理单'),
                ],
              ),
            ],
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
        ),
      ],
    );
  }
}
