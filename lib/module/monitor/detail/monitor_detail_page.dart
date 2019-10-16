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
              if (state is MonitorDetailLoaded) {
                enterName = state.monitorDetail.enterName;
                enterAddress = state.monitorDetail.enterAddress;
              }
              return DetailHeaderWidget(
                title: '监控点详情',
                subTitle1: enterName,
                subTitle2: enterAddress,
                imagePath: 'assets/images/monitor_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_red.png',
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
                                  content: '${state.monitorDetail.monitorAddress}',
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
                      //联系人 没有联系人则隐藏
                      /*Offstage(
                        offstage: TextUtil.isEmpty(
                            state.monitorDetail.contactPersonTel),
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
                              ContactsWidget(
                                contactsName:
                                    '${state.monitorDetail.contactPerson}',
                                contactsTel:
                                    '${state.monitorDetail.contactPersonTel}',
                              ),
                            ],
                          ),
                        ),
                      ),*/
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
