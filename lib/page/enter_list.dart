import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pollution_source/model/model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/dimens.dart';
import 'package:pollution_source/util/ui_util.dart';
import 'package:pollution_source/widget/label.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;

import 'enter_detail.dart';

class EnterListPage extends StatefulWidget {
  @override
  _EnterListPageState createState() => _EnterListPageState();
}

class _EnterListPageState extends State<EnterListPage> {
  ScrollController _scrollController;

  int _listCount = 100;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _selectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(icon, color: Colors.blue),
            new Text(text),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: extended.NestedScrollView(
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + kToolbarHeight;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text("企业列表"),
              expandedHeight: 150.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/index_header_bg.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: -20,
                        bottom: 0,
                        child: Image.asset(
                          "assets/images/enter_list_bg_image.png",
                          width: 300,
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 110,
                              child: Text(
                                "展示污染源企业列表，点击列表项查看该企业的详细信息",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Text(
                                "点我筛选",
                                style:
                                    TextStyle(fontSize: 10, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.search),
                    tooltip: '搜索',
                    onPressed: () {}),
                // 隐藏的菜单
                new PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<String>>[
                    this._selectView(Icons.message, '发起群聊', 'A'),
                    this._selectView(Icons.group_add, '添加服务', 'B'),
                    this._selectView(Icons.cast_connected, '扫一扫码', 'C'),
                  ],
                  onSelected: (String action) {
                    // 点击选项的时候
                    switch (action) {
                      case 'A':
                        break;
                      case 'B':
                        break;
                      case 'C':
                        break;
                    }
                  },
                ),
              ],
            ),
          ];
        },
        body: extended.NestedScrollViewInnerScrollPositionKeyWidget(
          Key('Tab0'),
          EasyRefresh.custom(
            header: getRefreshClassicalHeader(),
            footer: getLoadClassicalFooter(),
            slivers: <Widget>[
              EnterListWidget(),
            ],
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  _listCount = 20;
                });
              });
            },
            onLoad: () async {
              await Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  _listCount += 10;
                });
              });
            },
          ),
        ),
      ),
    );

    /*return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('企业列表',),
              background: Image.asset(
                "./images/avatar.png",
                fit: BoxFit.cover,
              ),
            ),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.search),
                  tooltip: '搜索',
                  onPressed: () {}),
              // 隐藏的菜单
              new PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  this._selectView(Icons.message, '发起群聊', 'A'),
                  this._selectView(Icons.group_add, '添加服务', 'B'),
                  this._selectView(Icons.cast_connected, '扫一扫码', 'C'),
                ],
                onSelected: (String action) {
                  // 点击选项的时候
                  switch (action) {
                    case 'A':
                      break;
                    case 'B':
                      break;
                    case 'C':
                      break;
                  }
                },
              ),
            ],
          ),
          EnterListWidget(),
        ],
        onRefresh: () async {},
        onLoad: () async {},
      ),
    );*/
  }
}

class EnterListWidget extends StatefulWidget {
  @override
  _EnterListWidgetState createState() => _EnterListWidgetState();
}

class _EnterListWidgetState extends State<EnterListWidget> {
  final List<Enter> enterList = [
    Enter(
      name: "深圳市腾讯计算机系统有限公司",
      imagePath: "assets/images/logo_tencent.png",
      address: "深圳市南山区高新区高新南一路飞亚达大厦5-10楼",
      industryType: "计算机软、硬件的设计、技术开发、销售",
      isImportant: true,
    ),
    Enter(
      name: "百度在线网络技术（北京）有限公司",
      imagePath: "assets/images/logo_baidu.png",
      address: "中国北京海淀区上地十街10号百度大厦",
      industryType: "网络信息服务",
      isImportant: true,
    ),
    Enter(
      name: "谷歌信息技术(中国)有限公司",
      imagePath: "assets/images/logo_google.png",
      address: "北京市海淀区科学院南路2号院1号楼4、5、6、7层",
      industryType: "设计、研究、开发计算机软、硬件；制作计算机软",
      isImportant: false,
    ),
    Enter(
      name: "北京京东叁佰陆拾度电子商务有限公司",
      imagePath: "assets/images/logo_jingdong.png",
      address: "北京市北京经济技术开发区科创十一街18号C座2层222室",
      industryType: "网络零售服务",
      isImportant: false,
    ),
    Enter(
      name: "北京三快在线科技有限公司",
      imagePath: "assets/images/logo_meituan.png",
      address: "北京市朝阳区望京东路6号 望京国际研发园三期",
      industryType: "网络购物",
      isImportant: true,
    ),
    Enter(
      name: "深圳市腾讯计算机系统有限公司",
      imagePath: "assets/images/logo_tencent.png",
      address: "深圳市南山区高新区高新南一路飞亚达大厦5-10楼",
      industryType: "计算机软、硬件的设计、技术开发、销售",
      isImportant: true,
    ),
    Enter(
      name: "百度在线网络技术（北京）有限公司",
      imagePath: "assets/images/logo_baidu.png",
      address: "中国北京海淀区上地十街10号百度大厦",
      industryType: "网络信息服务",
      isImportant: false,
    ),
    Enter(
      name: "谷歌信息技术(中国)有限公司",
      imagePath: "assets/images/logo_google.png",
      address: "北京市海淀区科学院南路2号院1号楼4、5、6、7层",
      industryType: "设计、研究、开发计算机软、硬件；制作计算机软",
      isImportant: true,
    ),
    Enter(
      name: "北京京东叁佰陆拾度电子商务有限公司",
      imagePath: "assets/images/logo_jingdong.png",
      address: "北京市北京经济技术开发区科创十一街18号C座2层222室",
      industryType: "网络零售服务",
      isImportant: false,
    ),
    Enter(
      name: "北京三快在线科技有限公司",
      imagePath: "assets/images/logo_meituan.png",
      address: "北京市朝阳区望京东路6号 望京国际研发园三期",
      industryType: "网络购物",
      isImportant: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: 125,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimens.gap_dp8, vertical: Dimens.gap_dp5),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(Dimens.gap_dp12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      getBoxShadow(),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(3),
                        child: Image.asset(
                          enterList[index].imagePath,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Text(
                                enterList[index].name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.2),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/icon_pollution_water_outlet.png",
                                        width: 10,
                                        height: 10,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        "废水排口",
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.2),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/icon_pollution_air_outlet.png",
                                        width: 10,
                                        height: 10,
                                        color: Colors.orange,
                                      ),
                                      Text(
                                        "废气排口",
                                        style: TextStyle(
                                            color: Colors.orange, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/icon_pollution_water_enter.png",
                                        width: 8,
                                        height: 8,
                                        color: Colors.green,
                                      ),
                                      Text(
                                        "雨水",
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "地址：${enterList[index].address}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colours.secondary_text,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "行业类别：${enterList[index].industryType}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colours.secondary_text,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Offstage(
                  offstage: !enterList[index].isImportant,
                  child: LabelView(
                    Size.fromHeight(100),
                    labelText: "重点",
                    labelColor: Theme.of(context).primaryColor,
                    labelAlignment: LabelAlignment.rightTop,
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EnterDetailPage();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        childCount: enterList.length,
      ),
    );
  }
}
