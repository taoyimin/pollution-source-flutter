import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/util/utils.dart';

import 'common_model.dart';

///一些通用的小组件
///不放复杂的自定义组件
///复杂自定义组件放widget包中

//页面加载中的widget
class PageLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: SizedBox(
            height: 200.0,
            width: 300.0,
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50.0,
                    height: 50.0,
                    child: SpinKitFadingCube(
                      color: Theme.of(context).primaryColor,
                      size: 25.0,
                    ),
                  ),
                  Container(
                    child: Text('加载中'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//页面没有数据的widget
class PageEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: Image.asset('assets/images/nodata.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                '没有数据',
                style:
                    const TextStyle(fontSize: 16.0, color: Colours.grey_color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//页面加载错误的widget
class PageErrorWidget extends StatelessWidget {
  final String errorMessage;

  PageErrorWidget({this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: Image.asset('assets/images/nodata.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                '$errorMessage',
                style:
                    const TextStyle(fontSize: 16.0, color: Colours.grey_color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//左边图片加圆形半透明背景 右边上面标题下面内容 无背景图片 默认一行三个 污染源在线监控ratio=1.15
class InkWellButton1 extends StatelessWidget {
  final double ratio;
  final Meta meta;
  final GestureTapCallback onTap;

  InkWellButton1({
    this.ratio = 1,
    @required this.meta,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        splashColor: this.meta.color.withOpacity(0.3),
        onTap: this.onTap,
        child: Container(
          height: 60 * ratio,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  width: 36 * ratio,
                  height: 36 * ratio,
                  decoration: BoxDecoration(
                    color: this.meta.color.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    this.meta.imagePath,
                    width: 15 * ratio,
                    height: 15 * ratio,
                    color: this.meta.color,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      this.meta.title,
                      style: TextStyle(
                        fontSize: 11 * ratio,
                        color: this.meta.color,
                      ),
                    ),
                    Text(
                      this.meta.content,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//上面内容下面标题 有背景图片无图标 默认一行三个
class InkWellButton2 extends StatelessWidget {
  final Meta meta;
  final GestureTapCallback onTap;

  InkWellButton2({@required this.meta, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWellButton(
        onTap: onTap,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(6),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(meta.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  meta.content,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.vGap6,
                Text(
                  meta.title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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

//左上内容 左下标题 右边图标 有背景图片 默认一行三个 一行两个时建议ratio=1.3
class InkWellButton3 extends StatelessWidget {
  final Meta meta;
  final GestureTapCallback onTap;
  final double ratio;
  final double titleFontSize;
  final double contentFontSize;
  final double contentMarginRight;

  InkWellButton3({
    @required this.meta,
    @required this.onTap,
    this.ratio = 1,
    this.titleFontSize = 13,
    this.contentFontSize = 23,
    this.contentMarginRight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWellButton(
        onTap: onTap,
        children: <Widget>[
          Container(
            height: 48 * ratio + 20,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(meta.backgroundPath),
                fit: BoxFit.fill,
              ),
              boxShadow: [getBoxShadow()],
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset(
                    meta.imagePath,
                    width: 40 * ratio,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        meta.content,
                        style: TextStyle(
                          fontSize: contentFontSize * ratio,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        meta.title,
                        style: TextStyle(
                          fontSize: titleFontSize * ratio,
                          color: Colors.white,
                        ),
                      ),
                    ],
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

//左上标题 左下内容 右边图标 有背景图片
class InkWellButton4 extends StatelessWidget {
  final Meta meta;
  final GestureTapCallback onTap;
  final double ratio;
  final double titleFontSize;
  final double contentFontSize;
  final double contentMarginRight;

  InkWellButton4({
    @required this.meta,
    @required this.onTap,
    this.ratio = 1,
    this.titleFontSize = 13,
    this.contentFontSize = 23,
    this.contentMarginRight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWellButton(
        onTap: onTap,
        children: <Widget>[
          Container(
            height: 48 * ratio + 20,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(meta.backgroundPath),
                fit: BoxFit.fill,
              ),
              boxShadow: [getBoxShadow()],
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    meta.imagePath,
                    width: 46 * ratio,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  right: contentMarginRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        meta.title,
                        style: TextStyle(
                          fontSize: titleFontSize * ratio,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        meta.content,
                        style: TextStyle(
                          fontSize: contentFontSize * ratio,
                          color: Colors.white,
                        ),
                      ),
                    ],
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

//左边图标加圆形半透明背景 右边上面标题下面内容 顶部描边 默认一行三个 一行两个时建议ratio=1.2
class InkWellButton5 extends StatelessWidget {
  final Meta meta;
  final GestureTapCallback onTap;
  final double ratio;

  InkWellButton5({
    @required this.meta,
    @required this.onTap,
    this.ratio = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWellButton(
        onTap: onTap,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10 * ratio),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [getBoxShadow()],
              border: Border(
                top: BorderSide(
                  color: meta.color,
                  width: 2 * ratio,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 36 * ratio,
                  height: 36 * ratio,
                  padding: EdgeInsets.all(10 * ratio),
                  decoration: BoxDecoration(
                      color: meta.color.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(18 * ratio)),
                  child: Image.asset(
                    meta.imagePath,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      meta.title,
                      style: TextStyle(fontSize: 11 * ratio),
                    ),
                    Text(
                      meta.content,
                      style: TextStyle(fontSize: 14 * ratio),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//左上标题 左中内容 左下查看详情按钮 右边图标 有背景图片 默认一行一个
class InkWellButton6 extends StatelessWidget {
  final Meta meta;
  final GestureTapCallback onTap;

  InkWellButton6({
    @required this.meta,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(meta.backgroundPath),
          fit: BoxFit.cover,
        ),
        boxShadow: [getBoxShadow()],
      ),
      child: InkWellButton(
        onTap: onTap,
        children: <Widget>[
          Positioned(
            bottom: -5,
            right: -20,
            child: Image.asset(
              meta.imagePath,
              height: 100,
            ),
          ),
          Positioned(
            top: 10,
            left: 20,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 100,
                  child: Text(
                    meta.title,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                Container(
                  width: 100,
                  child: Text(
                    meta.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    "查看详情",
                    style: TextStyle(
                      fontSize: 10,
                      color: meta.color,
                    ),
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

//list展示信息 展示标题下方的信息
class ListTileWidget extends StatelessWidget {
  final String content;

  ListTileWidget(this.content);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colours.secondary_text,
        fontSize: 12,
      ),
    );
  }
}

//水平分割线 自定义宽高颜色时使用 否则使用Gaps
class HorizontalDividerWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  HorizontalDividerWidget({
    this.width = double.infinity,
    this.height = 0.6,
    this.color = Colours.divider_color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height,
      width: this.width,
      child: DecoratedBox(
        decoration: BoxDecoration(color: this.color),
      ),
    );
  }
}

//垂直分割线 自定义宽高颜色时使用 否则使用Gaps
class VerticalDividerWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  VerticalDividerWidget({
    this.width = 0.6,
    this.height = double.infinity,
    this.color = Colours.divider_color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height,
      width: this.width,
      child: DecoratedBox(
        decoration: BoxDecoration(color: this.color),
      ),
    );
  }
}

//解决InkWell因为child设置了背景而显示不出涟漪的问题
class InkWellButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final List<Widget> children;

  InkWellButton({
    @required this.onTap,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: () {
        this.children.add(
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: this.onTap,
                  ),
                ),
              ),
            );
        return this.children;
      }(),
    );
  }
}

//标签widget
class LabelWidget extends StatelessWidget {
  final Label label;

  LabelWidget({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: this.label.color.withOpacity(0.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextUtil.isEmpty(this.label.imagePath)
              ? Gaps.empty
              : Image.asset(
                  this.label.imagePath,
                  width: 8,
                  height: 8,
                  color: this.label.color,
                ),
          Text(
            '${this.label.name}',
            style: TextStyle(color: this.label.color, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

//标签集合widget
class LabelWrapWidget extends StatelessWidget {
  final List<Label> labelList;

  LabelWrapWidget({@required this.labelList});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 3,
      children: () {
        return labelList.map((label) {
          return LabelWidget(
            label: label,
          );
        }).toList();
      }(),
    );
  }
}

//详情页图片标题widget
class ImageTitleWidget extends StatelessWidget {
  final String title;
  final String imagePath;

  ImageTitleWidget({
    @required this.title,
    @required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          imagePath,
          height: 18,
          width: 18,
        ),
        Gaps.hGap6,
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

//详情页基本信息展示widget
class IconBaseInfoWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final int flex;
  final TextAlign contentTextAlign;
  final double contentMarginTop;

  //final bool isTel;

  IconBaseInfoWidget({
    @required this.icon,
    @required this.title,
    @required this.content,
    this.flex = 1,
    this.contentTextAlign = TextAlign.right,
    this.contentMarginTop = 0,
    //this.isTel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //加一个padding使图标和后面内容对齐
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              size: 14,
            ),
          ),
          Gaps.hGap3,
          Text(title, style: const TextStyle(fontSize: 13)),
          Gaps.hGap10,
          Expanded(
            //当content是纯数字或字母时无法和title对齐，所以加一个padding
            child: Padding(
              padding: EdgeInsets.only(top: contentMarginTop),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 13,
                ),
                textAlign: contentTextAlign,
              ),
            ),
          ),
          /*Expanded(
            child: isTel
                ? InkWell(
                    onTap: () => Utils.launchTelURL("tel:$content"),
                    child: Text(
                      content,
                      style: const TextStyle(fontSize: 13, color: Colors.blue),
                      textAlign: contentTextAlign,
                    ),
                  )
                : Text(
                    content,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                    textAlign: contentTextAlign,
                  ),
          ),*/
        ],
      ),
    );
  }
}

//详情页联系人信息widget
class ContactsWidget extends StatelessWidget {
  final String contactsName;
  final String contactsTel;

  ContactsWidget({
    @required this.contactsName,
    @required this.contactsTel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/mine_user_header.png"),
          ),
        ),
        Gaps.hGap10,
        Container(
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                contactsName,
                style: const TextStyle(fontSize: 16),
              ),
              Text(contactsTel),
            ],
          ),
        ),
        Expanded(
          child: Gaps.empty,
        ),
        VerticalDividerWidget(
          width: 0.5,
          height: 26,
          color: Colours.divider_color,
        ),
        Gaps.hGap10,
        IconButton(
          icon: const Icon(
            Icons.phone,
            color: Colours.primary_color,
          ),
          onPressed: () {
            Utils.launchTelURL(contactsTel);
          },
        ),
      ],
    );
  }
}

//展示附件widget
class AttachmentWidget extends StatelessWidget {
  final Attachment attachment;
  final GestureTapCallback onTap;

  AttachmentWidget({
    @required this.attachment,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            Image.asset(
              attachment.imagePath,
            ),
            Gaps.hGap10,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  attachment.fileName,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  '附件大小:${attachment.size}',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
