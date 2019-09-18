import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/model/model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/util/ui_util.dart';
import 'package:pollution_source/res/dimens.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class EnterDetailPage extends StatefulWidget {
  @override
  _EnterDetailPageState createState() => _EnterDetailPageState();
}

class _EnterDetailPageState extends State<EnterDetailPage> {
  /*ScrollController _controller = new ScrollController();
  double _appbarOpacity = 0;
  final double _headerHeight = 150;*/

  @override
  void initState() {
    /*_controller.addListener(() {
      print(_controller.offset);
      if (_controller.offset >= 0 && _controller.offset <= _headerHeight) {
        setState(() {
          _appbarOpacity = _controller.offset / _headerHeight;
        });
      }
    });*/
    super.initState();
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  TextStyle _getTitleTextStyle() {
    return TextStyle(
      fontSize: 16,
    );
  }

  TextStyle _getContentTextStyle() {
    return TextStyle(
      fontSize: 13,
    );
  }

  Widget _getOtherInfoRowItem(
      {@required String title,
      @required String count,
      @required String bgPath,
      @required String imagePath}) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              bgPath,
            ),
            fit: BoxFit.cover,
          ),
          boxShadow: [getBoxShadow()],
        ),
        padding: EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                imagePath,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  count,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showSnackBar(_scaffoldKey, "无法调用$url");
    }
  }

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: EasyRefresh.custom(
        //controller: _controller,
        slivers: <Widget>[
          SliverAppBar(
            title: Text("企业详情"),
            expandedHeight: 150.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: EdgeInsets.fromLTRB(10, 75, 10, 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/button_bg_lightblue.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "深圳市腾讯计算机系统有限公司",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "深圳市南山区高新区高新南一路飞亚达大厦5-10楼",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SvgPicture.asset(
                        "assets/images/enter_detail_bg_image.svg",
                      ),
                    ),
                  ],
                ),
                /*child: Stack(
                  children: <Widget>[
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: SvgPicture.asset(
                        "assets/images/enter_detail_bg_image.svg",
                        width: 150,
                      ),
                    ),
                    Positioned(
                      top: 75,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 180,
                            child: Text(
                              "深圳市腾讯计算机系统有限公司",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 180,
                            child: Text(
                              "深圳市南山区高新区高新南一路飞亚达大厦5-10楼",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),*/
              ),
            ),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/images/icon_enter_baseinfo.png",
                            height: 18,
                            width: 18,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "基本信息",
                            style: _getTitleTextStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text("联系人", style: _getContentTextStyle()),
                                Expanded(child: SizedBox()),
                                Text("张三", style: _getContentTextStyle()),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text("联系电话", style: _getContentTextStyle()),
                                Expanded(child: SizedBox()),
                                GestureDetector(
                                  onTap: () {
                                    _launchURL("tel:15879085164");
                                  },
                                  child: Text(
                                    "15879085164",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text("法人姓名", style: _getContentTextStyle()),
                                Expanded(child: SizedBox()),
                                Text("李四", style: _getContentTextStyle()),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text("法人电话", style: _getContentTextStyle()),
                                Expanded(child: SizedBox()),
                                GestureDetector(
                                  onTap: () {
                                    _launchURL("tel:15879085164");
                                  },
                                  child: Text(
                                    "15879085164",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text("关注程度", style: _getContentTextStyle()),
                                Expanded(child: SizedBox()),
                                Text("重点源", style: _getContentTextStyle()),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text("所属区域", style: _getContentTextStyle()),
                                Expanded(child: SizedBox()),
                                Text("赣州市章贡区", style: _getContentTextStyle()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //加一个padding和后面的中文对齐
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.work,
                              size: 14,
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "行业类别",
                            style: _getContentTextStyle(),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "稀有稀土金属冶炼、常用有色金属冶炼稀有稀土金属冶炼、常用有色金属冶炼稀有稀土金属冶炼、常用有色金属冶炼",
                              style: _getContentTextStyle(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //加一个padding和后面的中文对齐
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.mail,
                              size: 14,
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "信用代码",
                            style: _getContentTextStyle(),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            //纯英文无法和前面中文对齐，所以加一个padding
                            child: Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Text(
                                "G2125FD1GF51D5F5FSD545G2125FD",
                                style: _getContentTextStyle(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //报警管理单
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/icon_alarm_manage.png",
                            height: 18,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "报警管理单",
                            style: _getTitleTextStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [getBoxShadow()],
                                    border: Border(
                                        top: BorderSide(
                                            color: Color(0xFF45C4FF),
                                            width: 3)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 40,
                                        height: 40,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Color(0xFF45C4FF)
                                                .withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Image.asset(
                                          "assets/images/icon_alarm_manage_complete.png",
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "已办结",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "254",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
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
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [getBoxShadow()],
                                    border: Border(
                                        top: BorderSide(
                                            color: Color(0xFFFFB709),
                                            width: 3)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 40,
                                        height: 40,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFFFB709)
                                                .withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Image.asset(
                                          "assets/images/icon_alarm_manage_all.png",
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "全部",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "5254",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //异常申报信息
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/icon_outlet_report.png",
                            height: 18,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "异常申报信息",
                            style: _getTitleTextStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 86,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/button_bg_blue.png"),
                                  fit: BoxFit.fill,
                                ),
                                boxShadow: [getBoxShadow()],
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 80,
                                          child: Text(
                                            "排口异常申报有效数",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "42",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Image.asset(
                                      "assets/images/button_image2.png",
                                      width: 70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 86,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/button_bg_pink.png"),
                                  fit: BoxFit.fill,
                                ),
                                boxShadow: [getBoxShadow()],
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 80,
                                          child: Text(
                                            "排口异常申报总数",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "42",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Image.asset(
                                      "assets/images/button_image1.png",
                                      width: 70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 86,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/button_bg_green.png"),
                                  fit: BoxFit.fill,
                                ),
                                boxShadow: [getBoxShadow()],
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 80,
                                          child: Text(
                                            "因子异常申报有效数",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "42",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Image.asset(
                                      "assets/images/button_image3.png",
                                      width: 70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 86,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/button_bg_yellow.png"),
                                  fit: BoxFit.fill,
                                ),
                                boxShadow: [getBoxShadow()],
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 80,
                                          child: Text(
                                            "因子异常申报总数",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "42",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Image.asset(
                                      "assets/images/button_image4.png",
                                      width: 70,
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
                ),
                //监控点信息
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/icon_monitor_info.png",
                            height: 18,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "监控点信息",
                            style: _getTitleTextStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      OnlineMonitorWidget(),
                    ],
                  ),
                ),
                //排污许可证信息
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/icon_discharge_permit.png",
                            height: 18,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "排污许可证信息",
                            style: _getTitleTextStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage("assets/images/button_bg_red.png"),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [getBoxShadow()],
                        ),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              bottom: -5,
                              right: -20,
                              child: Image.asset(
                                "assets/images/discharge_permit.png",
                                height: 100,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 20,
                              bottom: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Text(
                                      "许可证编号",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    child: Text(
                                      "546DSAFKSJDHKJHF546545DFHAJKH",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      "查看详情",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.pinkAccent),
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
                //其他信息
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/icon_enter_other_info.png",
                            height: 18,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "其他信息统计",
                            style: _getTitleTextStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          _getOtherInfoRowItem(
                            title: "建设项目",
                            count: "12",
                            bgPath: "assets/images/button_bg_lightblue.png",
                            imagePath: "assets/images/button_image2.png",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          _getOtherInfoRowItem(
                            title: "现场执法",
                            count: "4",
                            bgPath: "assets/images/button_bg_red.png",
                            imagePath: "assets/images/button_image1.png",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          _getOtherInfoRowItem(
                            title: "环境信访",
                            count: "25",
                            bgPath: "assets/images/button_bg_yellow.png",
                            imagePath: "assets/images/button_image3.png",
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
