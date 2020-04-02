import 'package:flutter/material.dart';
import 'package:pollution_source/res/gaps.dart';

import 'common_widget.dart';

//展示信息通用页面
class MapInfoPage extends StatelessWidget {
  final String title;
  //要展示的信息 key：标题 value：内容
  final Map<String, dynamic> mapInfo;

  MapInfoPage({@required this.title, @required this.mapInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        elevation: 0,
      ),
      body: _buildBodyWidget(),
    );
  }

  Widget _buildBodyWidget() {
    return ListView.separated(
      padding:const EdgeInsets.symmetric(horizontal: 16),
      itemCount: mapInfo.length,
      itemBuilder: (BuildContext context, int index) {
        return InfoRowWidget(
          title: '${mapInfo.keys.toList()[index]}',
          content: '${mapInfo.values.toList()[index]}',
        );
      },
      separatorBuilder: (BuildContext context, int index) => Gaps.hLine,
    );
  }
}
