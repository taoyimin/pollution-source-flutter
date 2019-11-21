import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_bloc.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_page.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_bloc.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_page.dart';
import 'package:pollution_source/module/order/list/order_list_bloc.dart';
import 'package:pollution_source/module/order/list/order_list_page.dart';
import 'package:pollution_source/module/report/discharge/list/discharge_report_list_bloc.dart';
import 'package:pollution_source/module/report/discharge/list/discharge_report_list_page.dart';
import 'package:pollution_source/module/report/factor/list/factor_report_list_bloc.dart';
import 'package:pollution_source/module/report/factor/list/factor_report_list_page.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'monitor_detail.dart';

class MonitorDetailPage extends StatefulWidget {
  final String monitorId;

  MonitorDetailPage({@required this.monitorId}) : assert(monitorId != null);

  @override
  _MonitorDetailPageState createState() => _MonitorDetailPageState();
}

class _MonitorDetailPageState extends State<MonitorDetailPage> {
  MonitorDetailBloc _monitorDetailBloc;

  @override
  void initState() {
    super.initState();
    _monitorDetailBloc = BlocProvider.of<MonitorDetailBloc>(context);
    _monitorDetailBloc.add(MonitorDetailLoad(monitorId: widget.monitorId));
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
          BlocBuilder<MonitorDetailBloc, MonitorDetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              Widget popupMenuButton = Gaps.empty;
              if (state is MonitorDetailLoaded) {
                enterName = state.monitorDetail.enterName;
                enterAddress = state.monitorDetail.enterAddress;
                final bool isCurved = state.isCurved;
                final bool showDotData = state.showDotData;
                popupMenuButton = PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<String>>[
                    UIUtils.getSelectView(
                        Icons.message, isCurved ? '折线图' : '曲线图', '1'),
                    UIUtils.getSelectView(
                        Icons.group_add, showDotData ? '隐藏点' : '显示点', '2'),
                  ],
                  onSelected: (String action) {
                    // 点击选项的时候 持久化储存并更新配置
                    switch (action) {
                      case '1':
                        SpUtil.putBool(Constant.spIsCurved, !isCurved);
                        _monitorDetailBloc.add(UpdateChartConfig(
                            isCurved: !isCurved, showDotData: showDotData));
                        break;
                      case '2':
                        SpUtil.putBool(Constant.spShowDotData, !showDotData);
                        _monitorDetailBloc.add(UpdateChartConfig(
                            isCurved: isCurved, showDotData: !showDotData));
                        break;
                    }
                  },
                );
              }
              return DetailHeaderWidget(
                title: '监控点详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/monitor_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_red.png',
                popupMenuButton: popupMenuButton,
              );
            },
          ),
          BlocBuilder<MonitorDetailBloc, MonitorDetailState>(
            builder: (context, state) {
              if (state is MonitorDetailLoading) {
                return PageLoadingWidget();
              } else if (state is MonitorDetailEmpty) {
                return PageEmptyWidget();
              } else if (state is MonitorDetailError) {
                return PageErrorWidget(errorMessage: state.errorMessage);
              } else if (state is MonitorDetailLoaded) {
                return _buildPageLoadedDetail(state.monitorDetail, state.isCurved, state.showDotData);
              } else {
                return PageErrorWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(MonitorDetail monitorDetail, bool isCurved, bool showDotData) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
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
                      title: '监控点名',
                      content: '${monitorDetail.monitorName}',
                      icon: Icons.linked_camera,
                      flex: 6,
                    ),
                    Gaps.hGap20,
                    IconBaseInfoWidget(
                      title: '监控类型',
                      content: '${monitorDetail.monitorTypeStr}',
                      icon: Icons.videocam,
                      flex: 5,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '监控类别',
                      content: '${monitorDetail.monitorCategoryStr}',
                      icon: Icons.nature,
                      flex: 6,
                    ),
                    Gaps.hGap20,
                    IconBaseInfoWidget(
                      title: '网络类型',
                      content: '${monitorDetail.networkTypeStr}',
                      icon: Icons.network_wifi,
                      flex: 5,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '监控位置',
                      content: '${monitorDetail.monitorAddress}',
                      icon: Icons.location_on,
                      contentTextAlign: TextAlign.left,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '数采编号',
                      content: '${monitorDetail.mnCode} ',
                      icon: Icons.insert_drive_file,
                      contentTextAlign: TextAlign.left,
                      contentMarginTop: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          //历史数据
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '监测数据',
                  imagePath: 'assets/images/icon_monitor_statistics.png',
                ),
                GridView.count(
                  //设置padding 防止item阴影被裁剪
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    top: 10,
                  ),
                  primary: false,
                  shrinkWrap: true,
                  mainAxisSpacing: 10.0,
                  crossAxisCount: 4,
                  crossAxisSpacing: 10.0,
                  children: monitorDetail.chartDataList.map((chartData) {
                    return FactorValueWidget(
                      chartData: chartData,
                      onTap: () {
                        _monitorDetailBloc.add(
                          UpdateChartData(
                            chartData: chartData.copyWith(
                              checked: !chartData.checked,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                LineChartWidget(
                  chartDataList: monitorDetail.chartDataList,
                  isCurved: isCurved,
                  showDotData: showDotData,
                ),
              ],
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
                                child: OrderListPage(state: '5', monitorId: monitorDetail.monitorId,),
                              );
                            },
                          ),
                        );
                      },
                      meta: Meta(
                        color: Color(0xFF45C4FF),
                        title: '已办结',
                        content: '${monitorDetail.orderCompleteCount}',
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
                                child: OrderListPage(monitorId: monitorDetail.monitorId,),
                              );
                            },
                          ),
                        );
                      },
                      meta: Meta(
                        color: Color(0xFFFFB709),
                        title: '全部',
                        content: '${monitorDetail.orderTotalCount}',
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
                    InkWellButton7(
                      titleFontSize: 13,
                      contentFontSize: 19,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => DischargeReportListBloc(),
                                child: DischargeReportListPage(
                                  monitorId: monitorDetail.monitorId,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      meta: Meta(
                        title: '排口异常申报总数',
                        content: '${monitorDetail.dischargeReportTotalCount}',
                        imagePath: 'assets/images/button_image1.png',
                        backgroundPath: 'assets/images/button_bg_green.png',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton7(
                      titleFontSize: 13,
                      contentFontSize: 19,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => FactorReportListBloc(),
                                child: FactorReportListPage(
                                  monitorId: monitorDetail.monitorId,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      meta: Meta(
                        title: '因子异常申报总数',
                        content: '${monitorDetail.factorReportTotalCount}',
                        imagePath: 'assets/images/button_image4.png',
                        backgroundPath: 'assets/images/button_bg_pink.png',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //快速链接
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '快速链接',
                  imagePath: 'assets/images/icon_fast_link.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    InkWellButton7(
                      meta: Meta(
                          title: '企业信息',
                          content: '查看监控点所属的企业信息',
                          backgroundPath:
                              'assets/images/button_bg_lightblue.png',
                          imagePath:
                              'assets/images/image_enter_statistics1.png'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => EnterDetailBloc(),
                                child: EnterDetailPage(
                                  enterId: monitorDetail.enterId,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    Gaps.hGap10,
                    InkWellButton7(
                      meta: Meta(
                          title: '排口信息',
                          content: '查看该监控点所属的排口信息',
                          backgroundPath: 'assets/images/button_bg_yellow.png',
                          imagePath:
                              'assets/images/image_enter_statistics2.png'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => DischargeDetailBloc(),
                                child: DischargeDetailPage(
                                  dischargeId: monitorDetail.dischargeId,
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
    );
  }
}
