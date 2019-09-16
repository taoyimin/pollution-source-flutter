import 'package:flutter/material.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:pollution_source/res/colors.dart';

//暂未使用
class SearchWidget extends StatefulWidget {
  final double height;

  SearchWidget({@required this.height});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with SingleTickerProviderStateMixin {
  //Animation<double> animation;
  //AnimationController controller;

  initState() {
    super.initState();
    /*controller = new AnimationController(
        duration: const Duration(seconds: 5), vsync: this);
    //图片宽高从0变到300
    animation = new Tween(begin: 0.0, end: widget.height).animate(controller)
      ..addListener(() {
        setState(()=>{});
      });*/
    //启动动画(正向执行)
    //controller.forward();
  }

  dispose() {
    //路由销毁时需要释放动画资源
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colours.primary_color,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 6),
                icon: Icon(Icons.person),
                labelText: "企业名称",
              ),
            ),
          ),
          Text("请选择省市县"),
          Text("取消 确定"),
        ],
      ),
    );
  }
}

//暂未使用
class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  Animation<double> animation;

  final double height = 100;

  SearchBarDelegate({@required this.animation});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SearchWidget(
      height: 100,
    );
  }

  @override
  double get maxExtent => height * animation.value;

  @override
  double get minExtent => height * animation.value;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}



class EnterSearchWidget extends StatefulWidget {
  @override
  _EnterSearchWidgetState createState() => _EnterSearchWidgetState();
}

class _EnterSearchWidgetState extends State<EnterSearchWidget>{
  TextEditingController _controller;

  String enterName="";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      //print('input ${_controller.text}');
      setState(() {
        //_controller.text = "哈哈";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Theme(
            data: ThemeData(
              hoverColor: Colors.white,
              hintColor: Colors.white,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 36,
                    child: TextField(
                      controller: _controller,
                      onChanged: (string) {
                        setState(() {
                          enterName = string;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(6),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "请输入企业名称",
                        hintStyle: TextStyle(
                          color: Colours.secondary_text,
                        ),
                        prefixIcon: Icon(Icons.business),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 36,
                  width: 70,
                  color: Colors.orange,
                  child: RaisedButton(
                    onPressed: () {
                    },
                    child: Text(
                      "搜索",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xFF8BC34A),
                  ),
                ),
              ],
            ),
          ),
          Theme(
            data: ThemeData(
              hoverColor: Colors.white,
              hintColor: Colors.white,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    child: Text(
                      "选择省",
                      style: TextStyle(
                        color: Colours.secondary_text,
                        fontSize: 15,
                      ),
                    ),
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 36,
                    child: Container(
                      height: 36,
                      alignment: Alignment.center,
                      child: Text(
                        "选择市",
                        style: TextStyle(
                          color: Colours.secondary_text,
                          fontSize: 15,
                        ),
                      ),
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 36,
                    child: Container(
                      height: 36,
                      alignment: Alignment.center,
                      child: Text(
                        "选择区",
                        style: TextStyle(
                          color: Colours.secondary_text,
                          fontSize: 15,
                        ),
                      ),
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 36,
                  width: 70,
                  color: Colors.orange,
                  child: RaisedButton(
                    onPressed: () {
                    },
                    child: Text(
                      "重置",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0XFFFFC107),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
