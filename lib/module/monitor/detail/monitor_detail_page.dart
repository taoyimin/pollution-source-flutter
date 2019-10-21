import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'monitor_detail.dart';

class MonitorDetailPage extends StatefulWidget {
  final String monitorId;

  MonitorDetailPage({@required this.monitorId});

  @override
  _MonitorDetailPageState createState() => _MonitorDetailPageState();
}

class _MonitorDetailPageState extends State<MonitorDetailPage> {
  MonitorDetailBloc _monitorDetailBloc;

  @override
  void initState() {
    super.initState();
    _monitorDetailBloc = BlocProvider.of<MonitorDetailBloc>(context);
    _monitorDetailBloc.dispatch(MonitorDetailLoad(monitorId: widget.monitorId));
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
              bool isCurved = true;
              bool showDotData = false;
              if (state is MonitorDetailLoaded) {
                enterName = state.monitorDetail.enterName;
                enterAddress = state.monitorDetail.enterAddress;
                isCurved = state.monitorDetail.isCurved;
                showDotData = state.monitorDetail.showDotData;
              }
              return DetailHeaderWidget(
                title: '监控点详情',
                subTitle1: enterName,
                subTitle2: enterAddress,
                imagePath: 'assets/images/monitor_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_red.png',
                popupMenuButton: PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<String>>[
                    UIUtils.getSelectView(
                        Icons.message, isCurved ? '折线图' : '曲线图', '1'),
                    UIUtils.getSelectView(
                        Icons.group_add, showDotData ? '隐藏点' : '显示点', '2'),
                  ],
                  onSelected: (String action) {
                    // 点击选项的时候
                    switch (action) {
                      case '1':
                        break;
                      case '2':
                        break;
                    }
                  },
                ),
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
                                  title: '监控点',
                                  content: '${state.monitorDetail.monitorName}',
                                  icon: Icons.linked_camera,
                                  flex: 6,
                                ),
                                Gaps.hGap20,
                                IconBaseInfoWidget(
                                  title: '监测类型',
                                  content: '${state.monitorDetail.monitorType}',
                                  icon: Icons.videocam,
                                  flex: 5,
                                ),
                              ],
                            ),
                            Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                IconBaseInfoWidget(
                                  title: '监测位置',
                                  content:
                                      '${state.monitorDetail.monitorAddress}',
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
                                  content:
                                      '${state.monitorDetail.dataCollectionNumber} ',
                                  icon: Icons.insert_drive_file,
                                  contentTextAlign: TextAlign.left,
                                  contentMarginTop: 2,
                                ),
                              ],
                            ),
                          ],
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
                                  onTap: () {},
                                  meta: Meta(
                                    color: Color(0xFF45C4FF),
                                    title: '已办结',
                                    content: '25',
                                    imagePath:
                                        'assets/images/icon_alarm_manage_complete.png',
                                  ),
                                ),
                                Gaps.hGap10,
                                InkWellButton5(
                                  onTap: () {},
                                  meta: Meta(
                                    color: Color(0xFFFFB709),
                                    title: '待审核',
                                    content: '1',
                                    imagePath:
                                        'assets/images/icon_alarm_manage_review.png',
                                  ),
                                ),
                                Gaps.hGap10,
                                InkWellButton5(
                                  onTap: () {},
                                  meta: Meta(
                                    color: Colors.green,
                                    title: '全部',
                                    content: '55',
                                    imagePath:
                                        'assets/images/icon_alarm_manage_all.png',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //历史数据
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ImageTitleWidget(
                              title: '监测数据',
                              imagePath:
                                  'assets/images/icon_monitor_statistics.png',
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
                              children: state.monitorDetail.chartDataList
                                  .map((chartData) {
                                return FactorValueWidget(
                                  chartData: chartData,
                                  onTap: () {
                                    _monitorDetailBloc.dispatch(
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
                              chartDataList: state.monitorDetail.chartDataList,
                              isCurved: false,
                              showDotData: true,
                            ),
                          ],
                        ),
                      ),
                      //快速链接
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
                                  onTap: () {},
                                ),
                                Gaps.hGap10,
                                InkWellButton7(
                                  meta: Meta(
                                      title: '报警管理单',
                                      content: '查看该监控点的报警管理单',
                                      backgroundPath:
                                          'assets/images/button_bg_pink.png',
                                      imagePath:
                                          'assets/images/image_enter_statistics2.png'),
                                  onTap: () {},
                                ),
                              ],
                            ),
                            Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                InkWellButton7(
                                  meta: Meta(
                                      title: '排口申报单',
                                      content: '查看该监控点的排口异常申报单',
                                      backgroundPath:
                                          'assets/images/button_bg_yellow.png',
                                      imagePath:
                                          'assets/images/image_enter_statistics3.png'),
                                  onTap: () {},
                                ),
                                Gaps.hGap10,
                                InkWellButton7(
                                  meta: Meta(
                                      title: '因子申报单',
                                      content: '查看该监控点的因子异常申报单',
                                      backgroundPath:
                                          'assets/images/button_bg_red.png',
                                      imagePath:
                                          'assets/images/image_enter_statistics4.png'),
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
