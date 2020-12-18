import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:pollution_source/module/application/enter_application_page.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_repository.dart';
import 'package:pollution_source/module/index/enter/enter_index_page.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:pollution_source/util/toast_utils.dart';

import 'mine.dart';

class EnterHomePage extends StatefulWidget {
  final String enterId;

  EnterHomePage({Key key,@required this.enterId})
      : assert(enterId != null),
        super(key: key);

  @override
  _EnterHomePageState createState() => _EnterHomePageState();
}

class _EnterHomePageState extends State<EnterHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions;

  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      BlocProvider<DetailBloc>(
        create: (BuildContext context) =>
            DetailBloc(detailRepository: EnterDetailRepository()),
        child: EnterIndexPage(enterId: '${widget.enterId}'),
      ),
      EnterApplicationPage(
        enterId: '${widget.enterId}',
      ),
      MinePage(),
    ];
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

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
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
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: '应用',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        //selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
