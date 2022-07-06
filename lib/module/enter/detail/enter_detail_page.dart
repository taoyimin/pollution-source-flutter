import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/collection/collection_bloc.dart';
import 'package:pollution_source/module/common/collection/collection_event.dart';
import 'package:pollution_source/module/common/collection/monitor/monitor_statistics_repository.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'enter_detail_repository.dart';

/// 企业详情页面
class EnterDetailPage extends StatefulWidget {
  final String enterId;

  EnterDetailPage({@required this.enterId}) : assert(enterId != null);

  @override
  _EnterDetailPageState createState() => _EnterDetailPageState();
}

class _EnterDetailPageState extends State<EnterDetailPage> {
  /// 全局Key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 详情Bloc
  final DetailBloc _detailBloc = DetailBloc(
    detailRepository: EnterDetailRepository(),
  );

  /// 监控点统计Bloc
  final CollectionBloc monitorStatisticsBloc = CollectionBloc(
    collectionRepository: MonitorStatisticsRepository(),
  );

  @override
  void initState() {
    super.initState();
    _loadData();
    // 加载监控点统计信息
    monitorStatisticsBloc.add(CollectionLoad(params: _getRequestParam()));
  }

  @override
  void dispose() {
    // 取消正在进行的请求
    if (_detailBloc?.state is DetailLoading)
      (_detailBloc?.state as DetailLoading).cancelToken.cancel();
    super.dispose();
  }

  /// 加载数据
  _loadData() {
    _detailBloc.add(DetailLoad(detailId: widget.enterId));
  }

  /// 获取监控点统计接口请求参数
  Map<String, dynamic> _getRequestParam() {
    return MonitorStatisticsRepository.createParams(
      // 运维用户传3，其他用户传2
      userType: SpUtil.getInt(Constant.spUserType) == 2 ? '3' : '2',
      enterId: widget.enterId,
      outType: '',
      attentionLevel: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          BlocBuilder<DetailBloc, DetailState>(
            bloc: _detailBloc,
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              String districtName = '';
              if (state is DetailLoaded) {
                enterName = state.detail.enterName;
                enterAddress = state.detail.enterAddress;
                districtName = state.detail.districtName;
              }
              return DetailHeaderWidget(
                title: '企业详情',
                subTitle1: '$districtName',
                subTitle2: '$enterName',
                subTitle3: '$enterAddress',
                imagePath: 'assets/images/enter_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_lightblue.png',
                color: Colours.background_light_blue,
              );
            },
          ),
          // 生成body
          BlocBuilder<DetailBloc, DetailState>(
            bloc: _detailBloc,
            builder: (context, state) {
              if (state is DetailLoading) {
                return LoadingSliver();
              } else if (state is DetailError) {
                return ErrorSliver(
                  errorMessage: state.message,
                  onReloadTap: () => _loadData(),
                );
              } else if (state is DetailLoaded) {
                return _buildPageLoadedDetail(state.detail);
              } else {
                return ErrorSliver(
                  errorMessage: 'BlocBuilder监听到未知的的状态!state=$state',
                  onReloadTap: () => _loadData(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(EnterDetail enterDetail) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          // 基本信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '基本信息',
                  imagePath: 'assets/images/icon_baseinfo.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '关注程度：${enterDetail.attentionLevelStr}',
                      icon: Icons.star,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '行业类别：${enterDetail.industryTypeStr}',
                      icon: Icons.work,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '信用代码：${enterDetail.creditCode}',
                      icon: Icons.mail,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 联系人 没有联系人则隐藏
          Offstage(
            offstage: TextUtil.isEmpty(enterDetail.enterTel) &&
                TextUtil.isEmpty(enterDetail.contactPersonTel) &&
                TextUtil.isEmpty(enterDetail.legalPersonTel),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ImageTitleWidget(
                    title: '企业联系人',
                    imagePath: 'assets/images/icon_contacts.png',
                  ),
                  Offstage(
                    offstage: TextUtil.isEmpty(enterDetail.enterTel),
                    child: ContactsWidget(
                      contactsName: '企业电话',
                      contactsTel: '${enterDetail.enterTel}',
                      imagePath: 'assets/images/enter_enter_tel_header.png',
                    ),
                  ),
                  Offstage(
                    offstage: TextUtil.isEmpty(enterDetail.contactPersonTel),
                    child: ContactsWidget(
                      contactsName: '${enterDetail.contactPerson}(联系人)',
                      contactsTel: '${enterDetail.contactPersonTel}',
                      imagePath: 'assets/images/enter_contacts_tel_header.png',
                    ),
                  ),
                  Offstage(
                    offstage: TextUtil.isEmpty(enterDetail.legalPersonTel),
                    child: ContactsWidget(
                      contactsName: '${enterDetail.legalPerson}(法人)',
                      contactsTel: '${enterDetail.legalPersonTel}',
                      imagePath: 'assets/images/enter_legal_tel_header.png',
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 报警管理单
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '当年报警管理单',
                  imagePath: 'assets/images/icon_alarm_manage.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    InkWellButton5(
                      ratio: 1.2,
                      meta: Meta(
                        color: Color(0xFF45C4FF),
                        title: '已办结',
                        content: '${enterDetail.orderCompleteCount}',
                        imagePath:
                            'assets/images/icon_alarm_manage_complete.png',
                        router:
                            '${Routes.orderList}?enterId=${widget.enterId}&alarmState=50&startTime=${DateUtil.formatDate(DateTime(DateTime.now().year), format: DateFormats.y_mo_d)}&endTime=${DateUtil.formatDate(DateTime.now().add(Duration(days: -1)), format: DateFormats.y_mo_d)}',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton5(
                      ratio: 1.2,
                      meta: Meta(
                        color: Color(0xFFFFB709),
                        title: '全部',
                        content: '${enterDetail.orderTotalCount}',
                        imagePath: 'assets/images/icon_alarm_manage_all.png',
                        router: '${Routes.orderList}?enterId=${widget.enterId}&startTime=${DateUtil.formatDate(DateTime(DateTime.now().year), format: DateFormats.y_mo_d)}&endTime=${DateUtil.formatDate(DateTime.now().add(Duration(days: -1)), format: DateFormats.y_mo_d)}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 异常申报信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '异常申报(有效数)',
                  imagePath: 'assets/images/icon_outlet_report.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    InkWellButton3(
                      onTap: SpUtil.getInt(Constant.spUserType) == 2
                          ? () {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('运维用户不支持查询长期停产'),
                                  action: SnackBarAction(
                                    label: '我知道了',
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            }
                          : null,
                      meta: Meta(
                        title: '长期停产申报',
                        content: '${enterDetail.longStopReportTotalCount}',
                        imagePath: 'assets/images/button_image2.png',
                        backgroundPath: 'assets/images/button_bg_lightblue.png',
                        router:
                            '${Routes.longStopReportList}?enterId=${enterDetail.enterId}&valid=0',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton3(
                      titleFontSize: 13,
                      meta: Meta(
                        title: '排口异常申报',
                        content: '${enterDetail.dischargeReportTotalCount}',
                        imagePath: 'assets/images/button_image1.png',
                        backgroundPath: 'assets/images/button_bg_green.png',
                        router:
                            '${Routes.dischargeReportList}?enterId=${enterDetail.enterId}&valid=0',
                      ),
                    ),
                    Gaps.hGap10,
                    InkWellButton3(
                      meta: Meta(
                        title: '因子异常申报',
                        content: '${enterDetail.factorReportTotalCount}',
                        imagePath: 'assets/images/button_image4.png',
                        backgroundPath: 'assets/images/button_bg_pink.png',
                        router:
                            '${Routes.factorReportList}?enterId=${enterDetail.enterId}&valid=0',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 监控点信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: MonitorStatisticsCard(
              title: '监控点概况',
              collectionBloc: monitorStatisticsBloc,
              onReloadTap: () {
                monitorStatisticsBloc
                    .add(CollectionLoad(params: _getRequestParam()));
              },
            ),
          ),
          // 排污许可证信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '排污许可证信息',
                  imagePath: 'assets/images/icon_discharge_permit.png',
                ),
                Gaps.vGap10,
                InkWellButton6(
                  meta: Meta(
                    title: '许可证编号',
                    content: '${enterDetail.licenseNumber}',
                    color: Colours.background_red,
                    imagePath: 'assets/images/discharge_permit.png',
                    backgroundPath: 'assets/images/button_bg_red.png',
                    router:
                        '${Routes.licenseList}?enterId=${enterDetail.enterId}',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
