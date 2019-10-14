import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/model/model.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

class TaskDetailPage extends StatefulWidget {
  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  List<DealStep> stepList = [
    DealStep(
      dealType: "县局督办",
      dealPerson: "南昌市市辖区管理员",
      dealTime: "2019-09-19 11:13",
      dealRemark: "操作描述操作描述操作描述操作描述操作描述操作描述操作描述",
      attachmentList: [
        Attachment(type: 0, fileName: "文件名文件名.png", url: "", size: "1.2M"),
        Attachment(type: 1, fileName: "文件名文件名文件名.doc", url: "", size: "56KB"),
      ],
    ),
    DealStep(
      dealType: "园区处理",
      dealPerson: "南昌市市辖区管理员",
      dealTime: "2019-09-19 11:13",
      dealRemark: "操作描述操作描述操作描述操作描述操作描述操作描述操作描述",
      attachmentList: [
        Attachment(
            type: 2, fileName: "文件名文件名文件名4515455.xls", url: "", size: "256KB"),
      ],
    ),
    DealStep(
      dealType: "县局审核",
      dealPerson: "南昌市市辖区管理员",
      dealTime: "2019-09-19 11:13",
      dealRemark: "操作描述操作描述操作描述操作描述操作描述操作描述操作描述",
      attachmentList: [
        Attachment(
            type: 3, fileName: "文件文件名文件文件文件名.pdf", url: "", size: "4.3M"),
        Attachment(type: 5, fileName: "文件文件名文件文件名.psd", url: "", size: "412KB"),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //用来显示SnackBar
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _getAttachmentWidgets(List<Attachment> attachmentList) {
    return attachmentList.map((attachment) {
      return InkWell(
        onTap: () {},
        child: Container(
          height: 40,
          padding: EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: <Widget>[
              Image.asset(
                attachment.imagePath,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    attachment.fileName,
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    attachment.size,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          DetailHeaderWidget(
            title: '督办单详情',
            subTitle1: '深圳市腾讯计算机系统有限公司',
            subTitle2: '深圳市南山区高新区高新南一路飞亚达大厦5-10楼',
            imagePath: 'assets/images/task_detail_bg_image.svg',
            backgroundPath: 'assets/images/button_bg_green.png',
          ),
          SliverToBoxAdapter(
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
                        imagePath: 'assets/images/icon_enter_baseinfo.png',
                      ),
                      Gaps.vGap10,
                      Row(
                        children: <Widget>[
                          IconBaseInfoWidget(
                            title: '行政区划',
                            content: '市辖区',
                            icon: Icons.location_on,
                            flex: 4,
                          ),
                          Gaps.hGap20,
                          IconBaseInfoWidget(
                            title: '监控点名称',
                            content: '废水排放口',
                            icon: Icons.linked_camera,
                            flex: 5,
                          ),
                        ],
                      ),
                      Gaps.vGap10,
                      Row(
                        children: <Widget>[
                          IconBaseInfoWidget(
                            title: '报警时间',
                            content: '9月18日',
                            icon: Icons.date_range,
                            flex: 4,
                          ),
                          Gaps.hGap20,
                          IconBaseInfoWidget(
                            title: '报警单状态',
                            content: '县局待督办',
                            icon: Icons.assignment_late,
                            flex: 5,
                          ),
                        ],
                      ),
                      Gaps.vGap10,
                      Row(
                        children: <Widget>[
                          IconBaseInfoWidget(
                            title: '报警类型',
                            content: '连续恒值  数采仪掉线  污染物超标',
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
                            content:
                                '报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述报警描述',
                            icon: Icons.receipt,
                            contentTextAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //联系人
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ImageTitleWidget(
                        title: '企业联系人',
                        imagePath: 'assets/images/icon_enter_contacts.png',
                      ),
                      Gaps.vGap10,
                      ContactsWidget(
                        contactsName: '李四',
                        contactsTel: '15879085164',
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          ),
          SliverList(
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
                                index != stepList.length - 1,
                                index == stepList.length - 1),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    stepList[index].dealType,
                                    style: TextStyle(fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    stepList[index].dealTime,
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
                              color: index == stepList.length - 1
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
                              "操作人：${stepList[index].dealPerson}；",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "操作描述：${stepList[index].dealRemark}；",
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _getAttachmentWidgets(
                                  stepList[index].attachmentList),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              childCount: stepList.length,
            ),
          ),
        ],
      ),
    );
  }
}

//在线监控点概况
class OnlineMonitorWidget extends StatefulWidget {
  OnlineMonitorWidget({Key key}) : super(key: key);

  @override
  _OnlineMonitorWidgetState createState() => _OnlineMonitorWidgetState();
}

class _OnlineMonitorWidgetState extends State<OnlineMonitorWidget> {
  final List<Monitor> _monitors = [
    Monitor("全部", 145, "assets/images/icon_monitor_all.png",
        Color.fromRGBO(77, 167, 248, 1)),
    Monitor("在线", 65, "assets/images/icon_monitor_online.png",
        Color.fromRGBO(136, 191, 89, 1)),
    Monitor("预警", 4, "assets/images/icon_monitor_alarm.png",
        Color.fromRGBO(241, 190, 67, 1)),
    Monitor("超标", 14, "assets/images/icon_monitor_over.png",
        Color.fromRGBO(233, 119, 111, 1)),
    Monitor("脱机", 56, "assets/images/icon_monitor_offline.png",
        Color.fromRGBO(179, 129, 127, 1)),
    Monitor("停产", 1, "assets/images/icon_monitor_stop.png",
        Color.fromRGBO(137, 137, 137, 1)),
  ];

  Widget _getOnlineMonitorRowItem(Monitor monitor) {
    return Expanded(
      flex: 1,
      child: Stack(
        children: <Widget>[
          Container(
            height: 66,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: monitor.color.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      monitor.imagePath,
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          monitor.title,
                          style: TextStyle(
                            fontSize: 13,
                            color: monitor.color,
                          ),
                        ),
                        Text(
                          monitor.count.toString(),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          getBoxShadow(),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _getOnlineMonitorRowItem(_monitors[0]),
              Container(
                height: 40,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getOnlineMonitorRowItem(_monitors[1]),
              Container(
                height: 40,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getOnlineMonitorRowItem(_monitors[2]),
            ],
          ),
          Row(
            children: <Widget>[
              _getOnlineMonitorRowItem(_monitors[3]),
              Container(
                height: 40,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getOnlineMonitorRowItem(_monitors[4]),
              Container(
                height: 40,
                width: 0.5,
                color: ThemeData.light().dividerColor,
              ),
              _getOnlineMonitorRowItem(_monitors[5]),
            ],
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
