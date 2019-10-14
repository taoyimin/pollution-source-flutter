import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/monitor/monitor_list.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

class EnterDetailPage extends StatefulWidget {
  @override
  _EnterDetailPageState createState() => _EnterDetailPageState();
}

class _EnterDetailPageState extends State<EnterDetailPage> {
  final List<Meta> metaList = [
    Meta(
      title: '全部',
      imagePath: 'assets/images/icon_monitor_all.png',
      color: Color.fromRGBO(77, 167, 248, 1),
      content: '52',
    ),
    Meta(
      title: '在线',
      imagePath: 'assets/images/icon_monitor_online.png',
      color: Color.fromRGBO(136, 191, 89, 1),
      content: '2',
    ),
    Meta(
      title: '预警',
      imagePath: 'assets/images/icon_monitor_alarm.png',
      color: Color.fromRGBO(241, 190, 67, 1),
      content: '12',
    ),
    Meta(
      title: '超标',
      imagePath: 'assets/images/icon_monitor_over.png',
      color: Color.fromRGBO(233, 119, 111, 1),
      content: '55',
    ),
    Meta(
      title: '脱机',
      imagePath: 'assets/images/icon_monitor_offline.png',
      color: Color.fromRGBO(179, 129, 127, 1),
      content: '0',
    ),
    Meta(
      title: '停产',
      imagePath: 'assets/images/icon_monitor_stop.png',
      color: Color.fromRGBO(137, 137, 137, 1),
      content: '1',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          DetailHeaderWidget(
            title: '企业详情',
            subTitle1: '深圳市腾讯计算机系统有限公司',
            subTitle2: '深圳市南山区高新区高新南一路飞亚达大厦5-10楼',
            imagePath: 'assets/images/enter_detail_bg_image.svg',
            backgroundPath: 'assets/images/button_bg_lightblue.png',
          ),
          SliverToBoxAdapter(
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
                        imagePath: 'assets/images/icon_enter_baseinfo.png',
                      ),
                      Gaps.vGap10,
                      Row(
                        children: <Widget>[
                          IconBaseInfoWidget(
                            title: '联系人',
                            content: '张三三',
                            icon: Icons.person,
                            flex: 2,
                          ),
                          Gaps.hGap20,
                          IconBaseInfoWidget(
                            title: '联系电话',
                            content: '15879085164',
                            icon: Icons.phone,
                            flex: 3,
                            isTel: true,
                          ),
                        ],
                      ),
                      Gaps.vGap10,
                      Row(
                        children: <Widget>[
                          IconBaseInfoWidget(
                            title: '法人姓名',
                            content: '李四',
                            icon: Icons.person,
                            flex: 2,
                          ),
                          Gaps.hGap20,
                          IconBaseInfoWidget(
                            title: '法人电话',
                            content: '15879085164',
                            icon: Icons.phone,
                            flex: 3,
                            isTel: true,
                          ),
                        ],
                      ),
                      Gaps.vGap10,
                      Row(
                        children: <Widget>[
                          IconBaseInfoWidget(
                            title: '关注程度',
                            content: '重点源',
                            icon: Icons.star,
                            flex: 2,
                          ),
                          Gaps.hGap20,
                          IconBaseInfoWidget(
                            title: '所属区域ss',
                            content: '赣州市章贡区',
                            icon: Icons.location_on,
                            flex: 3,
                          ),
                        ],
                      ),
                      Gaps.vGap10,
                      Row(
                        children: <Widget>[
                          IconBaseInfoWidget(
                            title: '行业类别',
                            content: '稀有稀土金属冶炼、常用有色金属冶炼',
                            icon: Icons.work,
                            contentTextAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      Gaps.vGap10,
                      Row(
                        children: <Widget>[
                          IconBaseInfoWidget(
                            title: '信用代码',
                            content: 'G2125FD1GF51D5F5FSD545G2125FD',
                            icon: Icons.mail,
                            contentTextAlign: TextAlign.left,
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
                            ratio: 1.2,
                            onTap: () {},
                            meta: Meta(
                              color: Color(0xFF45C4FF),
                              title: '已办结',
                              content: '255',
                              imagePath:
                                  'assets/images/icon_alarm_manage_complete.png',
                            ),
                          ),
                          Gaps.hGap10,
                          InkWellButton5(
                            ratio: 1.2,
                            onTap: () {},
                            meta: Meta(
                              color: Color(0xFFFFB709),
                              title: '全部',
                              content: '311',
                              imagePath:
                                  'assets/images/icon_alarm_manage_all.png',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //异常申报信息
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          InkWellButton4(
                            ratio: 1.3,
                            titleFontSize: 9.5,
                            contentFontSize: 19,
                            contentMarginRight: 50,
                            onTap: () {},
                            meta: Meta(
                              title: '排口异常申报有效数',
                              content: '44',
                              imagePath: 'assets/images/button_image2.png',
                              backgroundPath:
                                  'assets/images/button_bg_blue.png',
                            ),
                          ),
                          Gaps.hGap10,
                          InkWellButton4(
                            ratio: 1.3,
                            titleFontSize: 9.5,
                            contentFontSize: 19,
                            contentMarginRight: 50,
                            onTap: () {},
                            meta: Meta(
                              title: '排口异常申报总数',
                              content: '61',
                              imagePath: 'assets/images/button_image1.png',
                              backgroundPath:
                                  'assets/images/button_bg_pink.png',
                            ),
                          ),
                        ],
                      ),
                      Gaps.vGap10,
                      Row(
                        children: <Widget>[
                          InkWellButton4(
                            ratio: 1.3,
                            titleFontSize: 9.5,
                            contentFontSize: 19,
                            contentMarginRight: 50,
                            onTap: () {},
                            meta: Meta(
                              title: '因子异常申报有效数',
                              content: '66',
                              imagePath: 'assets/images/button_image3.png',
                              backgroundPath:
                                  'assets/images/button_bg_green.png',
                            ),
                          ),
                          Gaps.hGap10,
                          InkWellButton4(
                            ratio: 1.3,
                            titleFontSize: 9.5,
                            contentFontSize: 19,
                            contentMarginRight: 50,
                            onTap: () {},
                            meta: Meta(
                              title: '因子异常申报总数',
                              content: '34',
                              imagePath: 'assets/images/button_image4.png',
                              backgroundPath:
                                  'assets/images/button_bg_yellow.png',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //监控点信息
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ImageTitleWidget(
                        title: '监控点信息',
                        imagePath: 'assets/images/icon_monitor_info.png',
                      ),
                      Gaps.vGap10,
                      Container(
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
                                //全部
                                InkWellButton1(
                                  meta: metaList[0],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return BlocProvider(
                                          builder: (context) =>
                                              MonitorListBloc(),
                                          child: MonitorListPage(),
                                        );
                                      }),
                                    );
                                  },
                                ),
                                VerticalDividerWidget(height: 30),
                                //在线
                                InkWellButton1(
                                  meta: metaList[1],
                                  onTap: () {},
                                ),
                                VerticalDividerWidget(height: 30),
                                //预警
                                InkWellButton1(
                                  meta: metaList[2],
                                  onTap: () {},
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                //超标
                                InkWellButton1(
                                  meta: metaList[3],
                                  onTap: () {},
                                ),
                                VerticalDividerWidget(height: 30),
                                //脱机
                                InkWellButton1(
                                  meta: metaList[4],
                                  onTap: () {},
                                ),
                                VerticalDividerWidget(height: 30),
                                //停产
                                InkWellButton1(
                                  meta: metaList[5],
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //排污许可证信息
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          content: '546DSAFKSJDHKJHF546545DFHAJKH',
                          color: Colors.pink,
                          imagePath: 'assets/images/discharge_permit.png',
                          backgroundPath: 'assets/images/button_bg_red.png',
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                //其他信息
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ImageTitleWidget(
                        title: '其他信息统计',
                        imagePath: 'assets/images/icon_enter_other_info.png',
                      ),
                      Gaps.vGap10,
                      Row(
                        children: <Widget>[
                          //监察执法
                          InkWellButton3(
                            meta: Meta(
                              title: "建设项目",
                              content: "12",
                              backgroundPath:
                                  "assets/images/button_bg_lightblue.png",
                              imagePath: "assets/images/button_image2.png",
                            ),
                            onTap: () {},
                          ),
                          Gaps.hGap10,
                          //项目审批
                          InkWellButton3(
                            meta: Meta(
                              title: "现场执法",
                              content: "12",
                              backgroundPath:
                              "assets/images/button_bg_red.png",
                              imagePath: "assets/images/button_image1.png",
                            ),
                            onTap: () {},
                          ),
                          Gaps.hGap10,
                          //信访投诉
                          InkWellButton3(
                            meta: Meta(
                              title: "环境信访",
                              content: "12",
                              backgroundPath:
                              "assets/images/button_bg_yellow.png",
                              imagePath: "assets/images/button_image3.png",
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
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
