import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pollution_source/module/application/admin_application_page.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/enter/list/enter_list_page.dart';
import 'package:pollution_source/module/enter/list/enter_list_repository.dart';
import 'package:pollution_source/module/index/operation/operation_index.dart';

import 'mine.dart';

class OperationHomePage extends StatefulWidget {
  OperationHomePage({Key key}) : super(key: key);

  @override
  _OperationHomePageState createState() => _OperationHomePageState();
}

class _OperationHomePageState extends State<OperationHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    OperationIndexPage(),
    AdminApplicationPage(),
    BlocProvider<ListBloc>(
      create: (BuildContext context) =>
          ListBloc(listRepository: EnterListRepository()),
      child: EnterListPage(
        automaticallyImplyLeading: false,
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
