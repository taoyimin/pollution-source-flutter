import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_widget.dart';
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
                title: '督办单详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/task_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_green.png',
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
                return SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      //基本信息
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
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
                                  title: '行政区划',
                                  content: '${state.orderDetail.areaName}',
                                  icon: Icons.location_on,
                                  flex: 5,
                                ),
                                Gaps.hGap20,
                                IconBaseInfoWidget(
                                  title: '监控点名称',
                                  content: '${state.orderDetail.monitorName}',
                                  icon: Icons.linked_camera,
                                  flex: 6,
                                ),
                              ],
                            ),
                            Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                IconBaseInfoWidget(
                                  title: '报警时间',
                                  content: '${state.orderDetail.alarmTime}',
                                  icon: Icons.date_range,
                                  flex: 5,
                                ),
                                Gaps.hGap20,
                                IconBaseInfoWidget(
                                  title: '报警单状态',
                                  content: '${state.orderDetail.state}',
                                  icon: Icons.assignment_late,
                                  flex: 6,
                                ),
                              ],
                            ),
                            Gaps.vGap10,
                            Row(
                              children: <Widget>[
                                IconBaseInfoWidget(
                                  title: '报警类型',
                                  content: '${state.orderDetail.alarmType}',
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
                                  content: '${state.orderDetail.alarmRemark}',
                                  icon: Icons.receipt,
                                  contentTextAlign: TextAlign.left,
                                ),
                              ],
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
                            Container(
                              height: 150,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/button_bg_green.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "监控数据",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 23,
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  "查看该企业在报警发生时间段的监控数据",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Image.asset(
                                                    "assets/images/image_task_monitor_data.png"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 72,
                                          padding: EdgeInsets.all(10),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/button_bg_lightblue.png"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "企业信息",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      "查看该企业的详细信息",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Image.asset(
                                                  "assets/images/image_task_enter_info.png",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Container(
                                          height: 72,
                                          padding: EdgeInsets.all(10),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/button_bg_yellow.png"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "监控点列表",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      "查看该企业监控点列表",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Image.asset(
                                                  "assets/images/image_task_monitor_list.png",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //处理流程
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ImageTitleWidget(
                              title: '处理流程',
                              imagePath: 'assets/images/icon_deal_step.png',
                            ),
                            Gaps.vGap10,
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
          //处理流程列表
          BlocBuilder<OrderDetailBloc, OrderDetailState>(
            builder: (context, state) {
              if (state is OrderDetailLoaded) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
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
                                          state.orderDetail.stepList.length - 1,
                                      index ==
                                          state.orderDetail.stepList.length -
                                              1),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          state.orderDetail.stepList[index]
                                              .dealType,
                                          style: TextStyle(fontSize: 15),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          state.orderDetail.stepList[index]
                                              .dealTime,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colours.secondary_text),
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
                                            state.orderDetail.stepList.length -
                                                1
                                        ? Colors.transparent
                                        : Colours.divider_color,
                                  ),
                                ),
                              ),
                              margin: EdgeInsets.only(left: 23),
                              padding: EdgeInsets.fromLTRB(22, 0, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "操作人：${state.orderDetail.stepList[index].dealPerson}；",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "操作描述：${state.orderDetail.stepList[index].dealRemark}；",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Gaps.vGap3,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: () {
                                      return state.orderDetail.stepList[index]
                                          .attachmentList
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
                        ),
                      );
                    },
                    childCount: state.orderDetail.stepList.length,
                  ),
                );
              } else {
                return SliverToBoxAdapter();
              }
            },
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
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: 16,
      child: CustomPaint(
        painter: LeftLinePainter(showTop, showBottom, isLight),
      ),
    );
  }
}

class LeftLinePainter extends CustomPainter {
  static const double _topHeight = 16;
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
