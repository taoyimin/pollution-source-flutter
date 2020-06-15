import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:pollution_source/module/application/operation_application_page.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/enter/list/enter_list_page.dart';
import 'package:pollution_source/module/enter/list/enter_list_repository.dart';
import 'package:pollution_source/module/index/operation/operation_index_bloc.dart';
import 'package:pollution_source/module/index/operation/operation_index_page.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:pollution_source/util/toast_utils.dart';

import 'mine.dart';

class OperationHomePage extends StatefulWidget {
  OperationHomePage({Key key}) : super(key: key);

  @override
  _OperationHomePageState createState() => _OperationHomePageState();
}

class _OperationHomePageState extends State<OperationHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    BlocProvider<IndexBloc>(
      create: (BuildContext context) => IndexBloc(),
      child: OperationIndexPage(),
    ),
    OperationApplicationPage(),
    BlocProvider<ListBloc>(
      create: (BuildContext context) =>
          ListBloc(listRepository: EnterListRepository()),
      child: EnterListPage(
        automaticallyImplyLeading: false,
        attentionLevel: SpUtil.getString(Constant.spAttentionLevel, defValue: ''),
      ),
    ),
    MinePage(),
  ];

  final pageController = PageController();

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
    // 检查定位权限
    SystemUtils.checkLocation();
    // 检查推送权限
    SystemUtils.checkNotification(context);
    // 检查版本更新
    SystemUtils.checkUpdate(context);
    // 设置别名和标签
    try{
      JPush jpush = JPush();
      jpush.setAlias(SpUtil.getInt(Constant.spUserId).toString()).then((map){
        SpUtil.putString(Constant.spAlias, map['alias']);
      });
      jpush.setTags([Constant.userTags[SpUtil.getInt(Constant.spUserType)]]);
    }catch(e){
      Toast.show('配置推送信息失败！错误信息：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: _widgetOptions,
        physics: NeverScrollableScrollPhysics(), // 禁止滑动
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('首页'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text('应用'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('企业'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('我的'),
          ),
        ],
        currentIndex: _selectedIndex,
        //selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
