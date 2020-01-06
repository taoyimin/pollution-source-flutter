import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pollution_source/module/application/enter_application_page.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_repository.dart';
import 'package:pollution_source/module/index/enter/enter_index_page.dart';

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
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
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
