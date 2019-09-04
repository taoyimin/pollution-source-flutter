import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/res/dimens.dart';
import 'package:pollution_source/util/ui_util.dart';
import 'package:pollution_source/widget/label.dart';

class EnterListPage extends StatelessWidget {
  Widget _selectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(icon, color: Colors.blue),
            new Text(text),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("企业列表"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              tooltip: '搜索',
              onPressed: () {}
          ),
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
                case 'A': break;
                case 'B': break;
                case 'C': break;
              }
            },
          ),
        ],
      ),
      body: EasyRefresh.custom(
        slivers: <Widget>[
          EnterListWidget(),
        ],
        onRefresh: () async {},
        onLoad: () async {},
      ),
    );
  }
}

class EnterListWidget extends StatefulWidget {
  @override
  _EnterListWidgetState createState() => _EnterListWidgetState();
}

class _EnterListWidgetState extends State<EnterListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: 130,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.gap_dp8, vertical: Dimens.gap_dp5),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: EdgeInsets.all(Dimens.gap_dp12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      StyleUtil.getBoxShadow(),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("$index  企业名称企业名称企业名称",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                LabelView(
                  Size.fromHeight(120),
                  labelText: "重点",
                  labelColor: Theme.of(context).primaryColor,
                  labelAlignment: LabelAlignment.rightTop,
                ),
              ],
            )
          );
        },
        childCount: 50,
      ),
    );
  }
}
