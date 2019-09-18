import 'dart:math';

import 'package:pollution_source/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/util/ui_util.dart';

/// 个人中心页面
class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final double _headerHeight = 300;
  final double _headerBgHeight = 230;
  final double _cardHeight = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Color(0xFFFFEE5F),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Color(0xFFFAFAFA),
                  ),
                ),
              ],
            ),
          ),
          EasyRefresh.custom(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  // 顶部栏
                  Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: _headerHeight,
                        color: Color(0xFFFAFAFA),
                      ),
                      ClipPath(
                        clipper: TopBarClipper(
                            MediaQuery.of(context).size.width, _headerBgHeight),
                        child: Container(
                          height: _headerBgHeight,
                          width: double.infinity,
                          child: Image.asset(
                            "assets/images/mine_header_bg.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // 名字
                      Container(
                        margin: new EdgeInsets.only(top: 50.0),
                        child: new Center(
                          child: new Text(
                            '环境保护厅',
                            style: new TextStyle(
                                fontSize: 25.0, color: Colors.white,),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        right: 10,
                        left: 10,
                        child: ClipPath(
                          clipper: TopCardClipper(
                              MediaQuery.of(context).size.width,
                              _headerBgHeight),
                          child: Container(
                            height: _cardHeight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                getBoxShadow(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 120,
                        left: 0,
                        right: 0,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 90,
                                width: 90,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/images/mine_user_header.png"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        right: 10,
                        left: 10,
                        child: Container(
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "18",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  Text(
                                    "代办",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colours.secondary_text),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "458",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  Text(
                                    "代办",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colours.secondary_text),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "69",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  Text(
                                    "代办",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colours.secondary_text),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 140,
                        right: 50,
                        child: Image.asset(
                          "assets/images/icon_QR_code.png",
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 36,
                        left: 16,
                        child: Icon(Icons.notifications_none,color: Colors.white,),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    color: Color(0xFFFAFAFA),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "常用功能",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              getBoxShadow(),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/icon_change_password.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text(
                                        "修改密码",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.secondary_text),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/icon_help_book.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text(
                                        "帮助手册",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.secondary_text),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/icon_share_product.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text(
                                        "分享产品",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.secondary_text),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/icon_feedback.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text(
                                        "问题反馈",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.secondary_text),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/icon_check_update.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text(
                                        "版本更新",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.secondary_text),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/icon_clear_cache.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text(
                                        "清理缓存",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.secondary_text),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/icon_login_out.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text(
                                        "注销登录",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.secondary_text),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "                ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colours.secondary_text),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 顶部栏裁剪
class TopBarClipper extends CustomClipper<Path> {
  // 宽高
  double width;
  double height;

  TopBarClipper(this.width, this.height);

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(width, 0.0);
    path.lineTo(width, height / 2);
    path.lineTo(0.0, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class TopCardClipper extends CustomClipper<Path> {
  // 宽高
  double width;
  double height;

  TopCardClipper(this.width, this.height);

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.moveTo(0, height);
    path.lineTo(width, height);
    path.lineTo(width, 0);
    path.lineTo(0, height / 2);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
