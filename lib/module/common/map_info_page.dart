import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';

import 'common_widget.dart';

/// 展示信息通用页面
class MapInfoPage extends StatelessWidget {
  /// 页面导航栏标题
  final String title;

  /// 要展示的信息 key：标题 value：内容
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: mapInfo.length,
      itemBuilder: (BuildContext context, int index) {
        final String title = mapInfo.keys.toList()[index];
        final String content = mapInfo.values.toList()[index];
        return InkWell(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: '$content'));
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${title.replaceAll('\n', '')}已复制到剪贴板'),
                action: SnackBarAction(
                    label: '我知道了',
                    textColor: Colours.primary_color,
                    onPressed: () {}),
              ),
            );
          },
          child: () {
            if (TextUtil.isEmpty(content)) {
              // 不显示内容为空的项
              return Gaps.empty;
            } else if ('$title'.endsWith('\n')) {
              // 换行显示内容
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InfoRowWidget(
                    title: '${title.replaceAll('\n', '')}',
                    content: '',
                  ),
                  Text(
                    '$content',
                    style: TextStyle(fontSize: 15),
                  ),
                  Gaps.vGap16,
                ],
              );
            } else {
              return InfoRowWidget(
                title: '$title',
                content: '$content',
              );
            }
          }(),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        if (TextUtil.isEmpty(mapInfo.values.toList()[index])) {
          return Gaps.empty;
        } else {
          return Gaps.hLine;
        }
      },
    );
  }
}
