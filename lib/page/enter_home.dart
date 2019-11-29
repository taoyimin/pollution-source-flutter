import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pollution_source/module/application/enter_application_page.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_bloc.dart';
import 'package:pollution_source/module/enter/detail/enter_index_page.dart';

import 'mine.dart';

class EnterHomePage extends StatefulWidget {
  EnterHomePage({Key key}) : super(key: key);

  @override
  _EnterHomePageState createState() => _EnterHomePageState();
}

class _EnterHomePageState extends State<EnterHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    //IndexPage(),
    BlocProvider(
      builder: (context) => EnterDetailBloc(),
      child: EnterIndexPage(enterId: '10000',),
    ),
    EnterApplicationPage(enterId: '10000',),
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
