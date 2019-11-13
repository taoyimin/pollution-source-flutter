import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_bloc.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_page.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_bloc.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_page.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'order_detail.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  OrderDetailPage({@required this.orderId}) : assert(orderId != null);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetailBloc _orderDetailBloc;

  @override
  void initState() {
    super.initState();
    _orderDetailBloc =
        _orderDetailBloc = BlocProvider.of<OrderDetailBloc>(context);
    _orderDetailBloc.add(OrderDetailLoad(orderId: widget.orderId));
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
          BlocBuilder<OrderDetailBloc, OrderDetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              if (state is OrderDetailLoaded) {
                enterName = state.orderDetail.enterName;
                enterAddress = state.orderDetail.enterAddress;
              }
              return DetailHeaderWidget(
                title: '报警管理单详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/order_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_blue.png',
              );
            },
          ),
          BlocBuilder<OrderDetailBloc, OrderDetailState>(
            builder: (context, state) {
              if (state is OrderDetailLoading) {
                return PageLoadingWidget();
              } else if (state is OrderDetailEmpty) {
                return PageEmptyWidget();
              } else if (state is OrderDetailError) {
                return PageErrorWidget(errorMessage: state.errorMessage);
              } else if (state is OrderDetailLoaded) {
                return _buildPageLoadedDetail(state.orderDetail);
              } else {
                return PageErrorWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(OrderDetail orderDetail) {
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
                      title: '监控名称',
                      content: '${orderDetail.monitorName}',
                      icon: Icons.linked_camera,
                      flex: 1,
                    ),
                    Gaps.hGap20,
                    IconBaseInfoWidget(
                      title: '区域',
                      content: '${orderDetail.districtName}',
                      icon: Icons.location_on,
                      flex: 1,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '报警时间',
                      content: '${orderDetail.alarmDateStr}',
                      icon: Icons.date_range,
                      flex: 1,
                      contentMarginTop: 2,
                    ),
                    Gaps.hGap20,
                    IconBaseInfoWidget(
                      title: '状态',
                      content: '${orderDetail.orderStateStr}',
                      icon: Icons.assignment_late,
                      flex: 1,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '报警类型',
                      content: '${orderDetail.alarmTypeStr}',
                      icon: Icons.alarm,
                      contentTextAlign: TextAlign.left,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      title: '报警描述',
                      content: '${orderDetail.alarmRemark}',
                      icon: Icons.receipt,
                      contentTextAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          ),
          //处理流程
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '处理流程',
                  imagePath: 'assets/images/icon_order_process.png',
                ),
                Gaps.vGap10,
                orderDetail.processList.length == 0
                    ? const Text(
                        '没有相关流程信息',
                        style: TextStyle(fontSize: 13),
                      )
                    : ListView.builder(
                        itemCount: orderDetail.processList.length,
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      // 圆和线
                                      height: 42,
                                      child: LeftLineWidget(
                                          index != 0,
                                          index !=
                                              orderDetail.processList.length -
                                                  1,
                                          index ==
                                              orderDetail.processList.length -
                                                  1),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              orderDetail.processList[index]
                                                  .operateTypeStr,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              orderDetail.processList[index]
                                                  .operateTimeStr,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      Colours.secondary_text),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        width: 2,
                                        color: index ==
                                                orderDetail.processList.length -
                                                    1
                                            ? Colors.transparent
                                            : Colours.divider_color,
                                      ),
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(left: 7),
                                  padding:
                                      const EdgeInsets.fromLTRB(23, 0, 16, 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "操作人：${orderDetail.processList[index].operatePerson}",
                                        style:const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "操作描述：${orderDetail.processList[index].operateDesc}",
                                        style:const TextStyle(fontSize: 12),
                                      ),
                                      Gaps.vGap3,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: () {
                                          return orderDetail
                                              .processList[index].attachmentList
                                              .map((attachment) {
                                            return AttachmentWidget(
                                              attachment: attachment,
                                              onTap: () {},
                                            );
                                          }).toList();
                                        }(),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                        },
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
                          content: '查看报警单所属的企业信息',
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
                                  enterId: orderDetail.enterId,
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
                          title: '监控点信息',
                          content: '查看报警单所属的监控点信息',
                          backgroundPath: 'assets/images/button_bg_yellow.png',
                          imagePath:
                          'assets/images/image_enter_statistics2.png'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => MonitorDetailBloc(),
                                child: MonitorDetailPage(
                                  monitorId: orderDetail.monitorId,
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

class LeftLineWidget extends StatelessWidget {
  final bool showTop;
  final bool showBottom;
  final bool isLight;

  const LeftLineWidget(this.showTop, this.showBottom, this.isLight);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      child: CustomPaint(
        painter: LeftLinePainter(showTop, showBottom, isLight),
      ),
    );
  }
}

class LeftLinePainter extends CustomPainter {
  static const double _topHeight = 12;
  static const Color _lightColor = Colors.green;
  static const Color _normalColor = Colours.divider_color;

  final bool showTop;
  final bool showBottom;
  final bool isLight;

  const LeftLinePainter(this.showTop, this.showBottom, this.isLight);

  @override
  void paint(Canvas canvas, Size size) {
    double lineWidth = 2;
    double centerX = size.width / 2;
    Paint linePain = Paint();
    linePain.color = showTop ? Colours.divider_color : Colors.transparent;
    linePain.strokeWidth = lineWidth;
    linePain.strokeCap = StrokeCap.square;
    canvas.drawLine(Offset(centerX, 0), Offset(centerX, _topHeight), linePain);
    Paint circlePaint = Paint();
    circlePaint.color = isLight ? _lightColor : _normalColor;
    circlePaint.style = PaintingStyle.fill;
    linePain.color = showBottom ? Colours.divider_color : Colors.transparent;
    canvas.drawLine(
        Offset(centerX, _topHeight), Offset(centerX, size.height), linePain);
    canvas.drawCircle(Offset(centerX, _topHeight), centerX, circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
