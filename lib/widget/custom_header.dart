import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ListHeaderWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String subtitle2;
  final String background;
  final String image;
  final Color color;
  final Widget popupMenuButton;
  final bool automaticallyImplyLeading;
  final double expandedHeight;
  final VoidCallback onSearchTap;

  ListHeaderWidget({
    this.title = '标题',
    this.subtitle = '副标题',
    this.subtitle2 = '副标题2',
    this.background = 'assets/images/button_bg_green.png',
    this.image = 'assets/images/order_list_bg_image.png',
    this.color = Colours.primary_color,
    this.automaticallyImplyLeading = true,
    this.expandedHeight = 150,
    this.popupMenuButton,
    this.onSearchTap,
  });

  @override
  _ListHeaderWidgetState createState() => _ListHeaderWidgetState();
}

class _ListHeaderWidgetState extends State<ListHeaderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(widget.title),
      expandedHeight: widget.expandedHeight,
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: widget.color,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
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
          child: Stack(
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
                top: kIsWeb ? 40 : 60,
                left: 20,
                bottom: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 110,
                      child: Text(
                        '${widget.subtitle}',
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        '${widget.subtitle2}',
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        widget.onSearchTap != null
            ? IconButton(
                key: ValueKey(Icons.search),
                icon: Icon(Icons.search),
                onPressed: widget.onSearchTap,
              )
            : Gaps.empty,
        // 隐藏的菜单
        widget.popupMenuButton != null ? widget.popupMenuButton : Gaps.empty,
      ],
    );
  }
}

class DetailHeaderWidget extends StatelessWidget {
  final String title;
  final Color color;
  final String backgroundPath;
  final String imagePath;
  final String subTitle1;
  final String subTitle2;
  final String subTitle3;
  final Widget popupMenuButton;

  DetailHeaderWidget({
    this.title = '',
    this.color = Colours.primary_color,
    this.subTitle1,
    this.subTitle2,
    this.subTitle3,
    this.imagePath = '',
    this.backgroundPath = '',
    this.popupMenuButton,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(title),
      expandedHeight: 150.0,
      pinned: true,
      backgroundColor: color,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(10, 75, 10, 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                backgroundPath,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Offstage(
                      offstage: TextUtil.isEmpty(subTitle1),
                      child: Text(
                        '$subTitle1',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: TextUtil.isEmpty(subTitle2),
                      child: Text(
                        '$subTitle2',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: TextUtil.isEmpty(subTitle3),
                      child: Text(
                        '$subTitle3',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: SvgPicture.asset(
                  imagePath,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        // 隐藏的菜单
        popupMenuButton != null ? popupMenuButton : Gaps.empty,
      ],
    );
  }
}

class UploadHeaderWidget extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final String imagePath;
  final String subTitle;
  final Widget popupMenuButton;

  UploadHeaderWidget({
    this.title = '主标题',
    this.subTitle = '副标题',
    this.imagePath = '',
    this.backgroundColor = Colours.primary_color,
    this.popupMenuButton,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(title),
      expandedHeight: 150.0,
      pinned: true,
      backgroundColor: backgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: 150,
          color: backgroundColor,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 70,
                right: 16,
                bottom: 10,
                child: Image.asset(
                  imagePath,
                ),
              ),
              Positioned(
                  top: 70,
                  left: 20,
                  bottom: 10,
                  right: 150,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Text(
                        '$subTitle',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        // 隐藏的菜单
        popupMenuButton != null ? popupMenuButton : Gaps.empty,
      ],
    );
  }
}
