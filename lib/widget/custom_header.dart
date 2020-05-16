import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/system_utils.dart';

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
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(
              10, SystemUtils.isWeb ? 70 : 75, 10, 10),
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
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: 150,
          color: backgroundColor,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: SystemUtils.isWeb ? 50 : 70,
                right: 16,
                bottom: 10,
                child: Image.asset(
                  imagePath,
                ),
              ),
              Positioned(
                  top: SystemUtils.isWeb ? 50 : 70,
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
