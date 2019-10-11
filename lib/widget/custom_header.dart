import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/res/colors.dart';

class ListHeaderWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String background;
  final String image;
  final Color color;
  final Widget popupMenuButton;
  final bool showSearch;

  //外部传入，用于回到顶部
  final ScrollController scrollController;
  final TextEditingController editController;
  final VoidCallback onSearchPressed;
  final void Function(String areaCode) areaPickerListener;

  ListHeaderWidget(
      {this.title = '标题',
      this.subtitle = '副标题',
      this.background = 'assets/images/button_bg_green.png',
      this.image = 'assets/images/task_list_bg_image.png',
      this.color = Colours.primary_color,
      this.showSearch = false,
      this.popupMenuButton,
      this.scrollController,
      this.editController,
      this.onSearchPressed,
      this.areaPickerListener});

  @override
  _ListHeaderWidgetState createState() => _ListHeaderWidgetState();
}

class _ListHeaderWidgetState extends State<ListHeaderWidget>
    with TickerProviderStateMixin {
  TabController _tabController;
  String provinceName = '选择省';
  String cityName = '选择市';
  String areaName = '选择区';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(
      () {
        switch (_tabController.index) {
          case 0:
            setState(
              () {
                if (_actionIcon == Icons.close) {
                  _actionIcon = Icons.search;
                }
              },
            );
            break;
          case 1:
            setState(
              () {
                if (_actionIcon == Icons.search) {
                  _actionIcon = Icons.close;
                }
              },
            );
            break;
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  IconData _actionIcon = Icons.search;

  _changePage() {
    setState(
      () {
        if (_actionIcon == Icons.search) {
          _actionIcon = Icons.close;
          _tabController.index = 1;
        } else {
          _actionIcon = Icons.search;
          _tabController.index = 0;
        }
      },
    );
  }

  _openPicker() async {
    Result result = await CityPickers.showCityPicker(
      context: context,
      //citiesData: citiesData,
      //provincesData: provincesData,
    );
    //将选中的areaCode通过接口回调传递出去
    if (widget.areaPickerListener != null) {
      widget.areaPickerListener(result.areaId);
    }
    setState(() {
      provinceName = result.provinceName;
      cityName = result.cityName;
      areaName = result.areaName;
    });
  }

  //重置搜索条件
  _resetSearch() {
    setState(() {
      widget.editController.text = '';
      provinceName = '选择省';
      cityName = '选择市';
      areaName = '选择区';
      widget.areaPickerListener('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(widget.title),
      expandedHeight: 150.0,
      pinned: true,
      floating: false,
      snap: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                widget.background,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Stack(
                children: <Widget>[
                  Positioned(
                    right: -20,
                    bottom: 0,
                    child: Image.asset(
                      widget.image,
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
                            widget.subtitle,
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              widget.scrollController.jumpTo(0);
                              _changePage();
                            },
                            child: Text(
                              "点我筛选",
                              style: TextStyle(
                                fontSize: 10,
                                color: widget.color,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 70, 16, 0),
                child: Container(
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
                                  controller: widget.editController,
                                  decoration: const InputDecoration(
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
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 36,
                              width: 70,
                              color: Colors.orange,
                              child: RaisedButton(
                                onPressed: widget.onSearchPressed != null
                                    ? widget.onSearchPressed
                                    : () {},
                                child: Text(
                                  "搜索",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color:const Color(0xFF8BC34A),
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
                                child: GestureDetector(
                                  onTap: () {
                                    _openPicker();
                                  },
                                  child: Text(
                                    provinceName,
                                    style: TextStyle(
                                      color: Colours.secondary_text,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                decoration:const BoxDecoration(color: Colors.white),
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
                                  child: GestureDetector(
                                    onTap: () {
                                      _openPicker();
                                    },
                                    child: Text(
                                      cityName,
                                      style: TextStyle(
                                        color: Colours.secondary_text,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  decoration:
                                      BoxDecoration(color: Colors.white),
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
                                  child: GestureDetector(
                                    onTap: () {
                                      _openPicker();
                                    },
                                    child: Text(
                                      areaName,
                                      style: TextStyle(
                                        color: Colours.secondary_text,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  decoration:
                                      BoxDecoration(color: Colors.white),
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
                                onPressed: () => _resetSearch(),
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
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        widget.showSearch
            ? AnimatedSwitcher(
                transitionBuilder: (child, anim) {
                  return ScaleTransition(child: child, scale: anim);
                },
                duration: Duration(milliseconds: 300),
                child: IconButton(
                  key: ValueKey(_actionIcon),
                  icon: Icon(_actionIcon),
                  onPressed: () {
                    widget.scrollController?.jumpTo(0);
                    _changePage();
                  },
                ),
              )
            : SizedBox(),
        // 隐藏的菜单
        widget.popupMenuButton != null ? widget.popupMenuButton : SizedBox(),
      ],
    );
  }
}
