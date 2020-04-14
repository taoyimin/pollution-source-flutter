import 'dart:async';
import 'dart:io';
import 'dart:ui' as UI;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/util/file_utils.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/util/ui_utils.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'common_model.dart';

///一些通用的小组件
///不放复杂的自定义组件
///复杂自定义组件放widget包中

/// 页面加载中的Sliver
class LoadingSliver extends StatelessWidget {
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

/// 页面加载中的widget
class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

/// 页面没有数据的Sliver
class EmptySliver extends StatelessWidget {
  final String message;

  EmptySliver({this.message = '没有数据'});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200.0,
              height: 200.0,
              child: Image.asset('assets/images/image_load_error.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                '$message',
                style: const TextStyle(
                    fontSize: 16.0, color: Colours.secondary_text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 页面没有数据的Widget
class EmptyWidget extends StatelessWidget {
  final String message;

  EmptyWidget({this.message = '没有数据'});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 200.0,
            height: 200.0,
            child: Image.asset('assets/images/image_load_error.png'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              '$message',
              style: const TextStyle(
                  fontSize: 16.0, color: Colours.secondary_text),
            ),
          ),
        ],
      ),
    );
  }
}

/// 页面加载错误的Sliver
class ErrorSliver extends StatelessWidget {
  final String errorMessage;

  ErrorSliver({this.errorMessage});

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
              width: 200.0,
              height: 200.0,
              child: Image.asset('assets/images/image_load_error.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                '$errorMessage',
                style: const TextStyle(
                    fontSize: 16.0, color: Colours.secondary_text),
              ),
            ),
            Gaps.vGap30,
          ],
        ),
      ),
    );
  }
}

/// 页面加载错误的widget
class ErrorMessageWidget extends StatelessWidget {
  final String errorMessage;

  ErrorMessageWidget({this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 200.0,
            height: 200.0,
            child: Image.asset('assets/images/image_load_error.png'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              '$errorMessage',
              style: const TextStyle(
                  fontSize: 16.0, color: Colours.secondary_text),
            ),
          ),
          Gaps.vGap30,
        ],
      ),
    );
  }
}

/// BottomSheet展示错误信息用的widget
class MessageWidget extends StatelessWidget {
  final String message;

  MessageWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 200.0,
            height: 200.0,
            child: Image.asset('assets/images/image_load_error.png'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              '$message',
              style: const TextStyle(
                  fontSize: 16.0, color: Colours.secondary_text),
            ),
          ),
        ],
      ),
    );
  }
}

/// 左边图片加圆形半透明背景 右边上面标题下面内容 无背景图片 默认一行三个 污染源在线监控ratio=1.15
class InkWellButton1 extends StatelessWidget {
  final double ratio;
  final Meta meta;
  final GestureTapCallback onTap;

  InkWellButton1({
    this.ratio = 1,
    @required this.meta,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWellButton(
        onTap: onTap ??
            () {
              Application.router.navigateTo(context, meta.router);
            },
        children: <Widget>[
          Container(
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
        ],
      ),
    );
  }
}

/// 上面内容下面标题 有背景图片无图标 默认一行三个
class InkWellButton2 extends StatelessWidget {
  final Meta meta;
  final GestureTapCallback onTap;

  InkWellButton2({
    @required this.meta,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWellButton(
        onTap: onTap ??
            () {
              Application.router.navigateTo(context, meta.router);
            },
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

/// 左上内容 左下标题 右上图标 有背景图片 默认一行三个 一行两个时建议ratio=1.3
class InkWellButton3 extends StatelessWidget {
  final Meta meta;
  final GestureTapCallback onTap;
  final double ratio;
  final double titleFontSize;
  final double contentFontSize;
  final double contentMarginRight;

  InkWellButton3({
    @required this.meta,
    this.onTap,
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
        onTap: onTap ??
            () {
              Application.router.navigateTo(context, meta.router);
            },
        children: <Widget>[
          Container(
            height: 48 * ratio + 20,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(meta.backgroundPath),
                fit: BoxFit.fill,
              ),
              boxShadow: [UIUtils.getBoxShadow()],
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

/// 左上标题 左下内容 右下图标 有背景图片
@Deprecated('目前没有使用')
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
        onTap: onTap ??
            () {
              Application.router.navigateTo(context, meta.router);
            },
        children: <Widget>[
          Container(
            height: 48 * ratio + 20,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(meta.backgroundPath),
                fit: BoxFit.fill,
              ),
              boxShadow: [UIUtils.getBoxShadow()],
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

/// 左边图标加圆形半透明背景 右边上面标题下面内容 顶部描边 默认一行三个 一行两个时建议ratio=1.2
class InkWellButton5 extends StatelessWidget {
  final Meta meta;
  final GestureTapCallback onTap;
  final double ratio;

  InkWellButton5({
    @required this.meta,
    this.onTap,
    this.ratio = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWellButton(
        onTap: onTap ??
            () {
              Application.router.navigateTo(context, meta.router);
            },
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10 * ratio),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [UIUtils.getBoxShadow()],
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
                    color: meta.color,
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

/// 左上标题 左中内容 左下查看详情按钮 右边图标 有背景图片 默认一行一个
class InkWellButton6 extends StatelessWidget {
  final Meta meta;
  final GestureTapCallback onTap;
  final double height;

  InkWellButton6({
    @required this.meta,
    this.onTap,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(meta.backgroundPath),
          fit: BoxFit.cover,
        ),
        boxShadow: [UIUtils.getBoxShadow()],
      ),
      child: InkWellButton(
        onTap: onTap ??
            () {
              Application.router.navigateTo(context, meta.router);
            },
        children: <Widget>[
          Positioned(
            bottom: -5,
            right: -20,
            child: Image.asset(
              meta.imagePath,
              height: height,
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

/// 左上标题 左下内容 右边图标 有背景图片 默认一行两个
class InkWellButton7 extends StatelessWidget {
  final Meta meta;
  final GestureTapCallback onTap;
  final double titleFontSize;
  final double contentFontSize;

  InkWellButton7({
    @required this.meta,
    this.onTap,
    this.titleFontSize = 16,
    this.contentFontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWellButton(
        onTap: onTap ??
            () {
              Application.router.navigateTo(context, meta.router);
            },
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(meta.backgroundPath),
                fit: BoxFit.cover,
              ),
              boxShadow: [UIUtils.getBoxShadow()],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${meta.title}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFontSize,
                        ),
                      ),
                      Text(
                        '${meta.content}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    meta.imagePath,
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

/// 配合InkWellButton7使用，组成两行两列布局，其中两行合并成一个
class InkWellButton8 extends StatelessWidget {
  final Meta meta;
  final GestureTapCallback onTap;
  final double titleFontSize;
  final double contentFontSize;

  InkWellButton8({
    @required this.meta,
    this.onTap,
    this.titleFontSize = 20,
    this.contentFontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWellButton(
        onTap: onTap ??
            () {
              Application.router.navigateTo(context, meta.router);
            },
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(meta.backgroundPath),
                  fit: BoxFit.cover,
                ),
                boxShadow: [UIUtils.getBoxShadow()],
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Image.asset(
              meta.imagePath,
              width: 80,
              height: 80,
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            right: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${meta.title}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, right: 24),
                  child: Text(
                    '${meta.content}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: contentFontSize,
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

/// 应用页功能按钮 左上标题 左下内容 右边图标 默认一行两个
class InkWellButton9 extends StatelessWidget {
  final Meta meta;
  final GestureTapCallback onTap;

  InkWellButton9({
    @required this.meta,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWellButton(
        onTap: onTap ??
            () {
              Application.router.navigateTo(context, meta.router);
            },
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                Image.asset(
                  '${meta.imagePath}',
                  height: 36,
                ),
                Gaps.hGap16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${meta.title}',
                        style: const TextStyle(
                            fontSize: 14, color: Colours.primary_text),
                      ),
                      Text(
                        '${meta.content}',
                        style: const TextStyle(
                            fontSize: 12, color: Colours.secondary_text),
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

/// list展示信息(单行)
class ListTileWidget extends StatelessWidget {
  final String content;

  ListTileWidget(this.content);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colours.secondary_text,
        fontSize: 12,
      ),
    );
  }
}

/// list展示信息(多行)
@Deprecated('已弃用')
class ListTileMultiRowWidget extends StatelessWidget {
  final String content;

  ListTileMultiRowWidget(this.content);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            content,
            style: const TextStyle(
              color: Colours.secondary_text,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

/// 水平分割线 自定义宽高颜色时使用 否则使用Gaps
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

/// 垂直分割线 自定义宽高颜色时使用 否则使用Gaps
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

/// 解决InkWell因为child设置了背景而显示不出涟漪的问题
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

/// 标签widget
class LabelWidget extends StatelessWidget {
  final Label label;

  LabelWidget({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 5),
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
                  width: 10,
                  height: 10,
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

/// 标签集合widget
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

/// 详情页图片标题widget
class ImageTitleWidget extends StatelessWidget {
  final String title;
  final String content;
  final String imagePath;

  ImageTitleWidget({
    @required this.title,
    this.content = '',
    @required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          imagePath,
          height: 20,
          width: 20,
        ),
        Gaps.hGap6,
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            content,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}

/// 详情页基本信息展示widget
class IconBaseInfoWidget extends StatelessWidget {
  final IconData icon;
  final String content;
  final int flex;

  IconBaseInfoWidget({
    @required this.icon,
    @required this.content,
    this.flex = 1,
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
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              size: 14,
            ),
          ),
          Gaps.hGap3,
          Expanded(
            flex: 1,
            child: Text(content, style: const TextStyle(fontSize: 13)),
          )
        ],
      ),
    );
  }
}

/// 详情页联系人信息widget
class ContactsWidget extends StatelessWidget {
  final String contactsName;
  final String contactsTel;
  final String imagePath;

  ContactsWidget({
    @required this.contactsName,
    @required this.contactsTel,
    @required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 34,
          width: 34,
          child: CircleAvatar(
            backgroundImage: AssetImage(imagePath),
          ),
        ),
        Gaps.hGap10,
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                contactsName,
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                contactsTel,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: Gaps.empty,
        ),
        VerticalDividerWidget(
          width: 0.5,
          height: 20,
          color: Colours.divider_color,
        ),
        Gaps.hGap10,
        IconButton(
          icon: const Icon(
            Icons.phone,
            color: Colours.primary_color,
            size: 20,
          ),
          onPressed: () {
            if (SystemUtils.isWeb) {
              Clipboard.setData(ClipboardData(text: '$contactsTel'));
              Toast.show('电话号码已经复制到剪贴板！');
            } else {
              SystemUtils.launchTelURL(contactsTel);
            }
          },
        ),
      ],
    );
  }
}

/// 展示附件widget
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
      onTap: () async {
        ProgressDialog pr;
        try {
          String localPath =
              await FileUtils.getAttachmentLocalPathByAttachment(attachment);
          if (await File(localPath).exists()) {
            // 附件已经存在
            OpenFile.open(localPath);
          } else {
            // 附件不存在
            pr = ProgressDialog(
              context,
              type: ProgressDialogType.Download,
              isDismissible: true,
              showLogs: true,
            );
            pr.style(
              message: '正在下载附件...',
              borderRadius: 10.0,
              backgroundColor: Colors.white,
              elevation: 10.0,
              insetAnimCurve: Curves.easeInOut,
              progress: 0.0,
              maxProgress: 100.0,
              progressTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
              ),
              messageTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 19.0,
                fontWeight: FontWeight.w600,
              ),
            );
            pr.show();
            await FileDioUtils.instance
                .getDio()
                .download("${attachment.url}", localPath,
                    onReceiveProgress: (int count, int total) {
              pr.update(
                progress:
                    double.parse((count * 100 / total).toStringAsFixed(2)),
                message: "正在下载附件...",
                maxProgress: 100.0,
                progressTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400),
                messageTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600),
              );
            });
            OpenFile.open(localPath);
          }
        } catch (e) {
          Toast.show(e.toString());
        }
        if (pr?.isShowing() ?? false) {
          pr.hide().then((isHidden) {});
        }
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            Image.asset(
              attachment.imagePath,
            ),
            Gaps.hGap10,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${attachment.fileName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    '附件大小:${attachment.fileSize}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 展示因子监测数据radio button
class FactorValueWidget extends StatelessWidget {
  final ChartData chartData;
  final GestureTapCallback onTap;

  FactorValueWidget({
    @required this.chartData,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellButton(
      onTap: onTap,
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [UIUtils.getBoxShadow()],
            border: Border(
              top: BorderSide(
                color: chartData.color,
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${chartData.factorName}',
                style: TextStyle(
                  fontSize: 11.5,
                  color: UIUtils.getAlarmFlagColor(chartData.alarmFlag),
                ),
              ),
              Text(
                '${chartData.value}',
                style: TextStyle(
                  fontSize: 11.5,
                  color: UIUtils.getAlarmFlagColor(chartData.alarmFlag),
                ),
              ),
              Text(
                '${chartData.unit}',
                style: TextStyle(
                  fontSize: 11.5,
                  color: UIUtils.getAlarmFlagColor(chartData.alarmFlag),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Offstage(
            offstage: !chartData.checked,
            child: Image.asset(
              'assets/images/icon_bottom_right_label.png',
              height: 20,
              color: chartData.color,
            ),
          ),
        ),
      ],
    );
  }
}

/// 监测因子图表数据
class LineChartWidget extends StatefulWidget {
  //图标数据集合
  final List<ChartData> chartDataList;
  final int xAxisCount;
  final int yAxisCount;
  final bool showDotData;
  final bool isCurved;

  LineChartWidget({
    @required this.chartDataList,
    this.xAxisCount = 7,
    this.yAxisCount = 5,
    this.showDotData = false,
    this.isCurved = true,
  });

  @override
  State<StatefulWidget> createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State<LineChartWidget> {
  StreamController<LineTouchResponse> controller;

  @override
  void initState() {
    super.initState();
    controller = StreamController();
    controller.stream.distinct().listen((LineTouchResponse response) {});
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Container(
        padding: const EdgeInsets.only(top: 30, left: 6, bottom: 10, right: 26),
        decoration: BoxDecoration(
          color: Color(0xFF203857),
          boxShadow: [UIUtils.getBoxShadow()],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: LineChart(
                _getLineChartData(),
                swapAnimationDuration: Duration(milliseconds: 250),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取图表样式
  LineChartData _getLineChartData() {
    double yInterval;
    double maxY = UIUtils.getMax(widget.chartDataList.map((chartData) {
      return chartData.maxY;
    }).toList());
    double minY = UIUtils.getMin(widget.chartDataList.map((chartData) {
      return chartData.minY;
    }).toList());
    if (maxY == minY) {
      //数据是一条直线时，手动设定最大值和最小值
      maxY = maxY + 10;
      minY = minY - 10;
    }
    //最大值减最小值，除以间隔数（坐标数减1）
    yInterval = (maxY - minY) / (widget.yAxisCount - 1);

    double xInterval;
    double maxX = UIUtils.getMax(widget.chartDataList.map((chartData) {
      return chartData.maxX;
    }).toList());
    double minX = UIUtils.getMin(widget.chartDataList.map((chartData) {
      return chartData.minX;
    })?.toList());
    xInterval = (maxX - minX) / (widget.xAxisCount - 1);

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            if (touchedSpots == null) return null;
            return touchedSpots.map((LineBarSpot touchedSpot) {
              if (touchedSpot == null) return null;
              final TextStyle textStyle = TextStyle(
                color: touchedSpot.bar.colors[0],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return LineTooltipItem(
                  '${widget.chartDataList[touchedSpot.barIndex].factorName} ${touchedSpot.y}',
                  textStyle);
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          interval: xInterval,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xff72719b),
            fontSize: 12,
          ),
          margin: 20,
          getTitles: (value) {
            return DateUtil.formatDateMs(value.toInt(), format: 'HH时');
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: yInterval,
          textStyle: const TextStyle(
            color: Color(0xff75729e),
            fontSize: 14,
          ),
          getTitles: (value) {
            if (value < 9999) {
              //间隔大于等于1时，Y轴坐标不保留小数位，小于1时，保留两位小数
              return yInterval >= 1
                  ? value.toStringAsFixed(0)
                  : value.toStringAsFixed(2);
            } else {
              return '${(value / 10000).toStringAsFixed(0)}万';
            }
          },
          margin: 20,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      maxX: maxX,
      maxY: maxY,
      minX: minX,
      minY: minY,
      lineBarsData: _getLineChartBarDataList(widget.chartDataList),
    );
  }

  /// 获取图表数据
  List<LineChartBarData> _getLineChartBarDataList(
      List<ChartData> chartDataList) {
    return chartDataList.map(
      (chartData) {
        return LineChartBarData(
          spots: chartData.points.map(
            (point) {
              return FlSpot(point.x, point.y);
            },
          ).toList(),
          isCurved: widget.isCurved,
          colors: [
            chartData.color,
          ],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: widget.showDotData,
            //dotColor: chartData.color,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        );
      },
    ).toList();
  }
}

/// 自定义裁剪按钮
class ClipButton extends StatelessWidget {
  final double height;
  final String text;
  final double fontSize;
  final IconData icon;
  final Color color;
  final GestureTapCallback onTap;

  ClipButton({
    this.height = 46,
    @required this.text,
    this.fontSize = 15,
    @required this.icon,
    @required this.onTap,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: RaisedButton(
        padding: const EdgeInsets.all(0),
        color: Colors.white,
        onPressed: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            Expanded(
              child: ClipPath(
                clipper: TipClipper(),
                child: Container(
                  height: height,
                  color: color,
                  child: Center(
                    child: Text(
                      '$text',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 自定义尖头裁剪器
class TipClipper extends CustomClipper<UI.Path> {
  double clipHeightRatio; // 裁剪的尖头高度占控件总高度的比率
  double clipWidthRatio; // 裁剪的尖头宽度占控件总高度的比率

  TipClipper({this.clipHeightRatio = 0.5, this.clipWidthRatio = 0.25});

  @override
  UI.Path getClip(Size size) {
    double clipHeight = size.height * clipHeightRatio;
    double clipWidth = size.height * clipWidthRatio;
    double leftHeight = size.height * (1 - clipHeightRatio) / 2;

    final path = Path();
    path.lineTo(0, leftHeight);
    path.conicTo(clipWidth / 4, leftHeight + clipHeight * 3 / 8, clipWidth,
        size.height / 2, 1);
    path.conicTo(clipWidth / 4, leftHeight + clipHeight * 5 / 8, 0,
        clipHeight + leftHeight, 1);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TipClipper oldClipper) => false;
}

/// 单行选择控件
class SelectRowWidget extends StatelessWidget {
  final String title;
  final String content;
  final double height;
  final GestureTapCallback onTap;

  SelectRowWidget({
    Key key,
    @required this.title,
    @required this.content,
    this.height = 46,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Row(
        children: <Widget>[
          Text(
            '$title',
            style: const TextStyle(fontSize: 15),
          ),
          Gaps.hGap20,
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: onTap,
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  content == null || content == '' ? '请选择$title' : content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 15,
                    color: content == null || content == ''
                        ? Colours.secondary_text
                        : Colours.primary_text,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 没有标题的选择控件
class SelectWidget extends StatelessWidget {
  final String content;
  final GestureTapCallback onTap;

  SelectWidget({
    Key key,
    @required this.content,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 46,
          alignment: Alignment.center,
          child: Text(
            content == null || content == '' ? '请选择' : content,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: content == null || content == ''
                  ? Colours.secondary_text
                  : Colours.primary_text,
            ),
          ),
        ),
      ),
    );
  }
}

// 单行文本输入控件
class EditRowWidget extends StatelessWidget {
  final String title;
  final String hintText;
  final TextStyle style;
  final TextInputType keyboardType;
  final bool obscureText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  EditRowWidget({
    Key key,
    @required this.title,
    this.hintText,
    this.style = const TextStyle(fontSize: 15),
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '$title',
            style: style,
          ),
          Gaps.hGap20,
          Flexible(
            child: TextField(
              textAlign: TextAlign.right,
              style: style,
              keyboardType: keyboardType,
              onChanged: onChanged,
              obscureText: obscureText,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText ?? '请输入$title',
                hintStyle: style,
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 没有标题的文本输入控件
class EditWidget extends StatelessWidget {
  final String hintText;
  final int flex;
  final TextStyle style;
  final ValueChanged<String> onChanged;

  EditWidget({
    Key key,
    this.hintText = '请输入',
    this.flex = 1,
    this.style = const TextStyle(fontSize: 15),
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: Container(
        height: 46,
        child: TextField(
          textAlign: TextAlign.center,
          style: style,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: style,
            border: UnderlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

class RadioRowWidget extends StatelessWidget {
  final String title;
  final String trueText;
  final String falseText;
  final bool checked;
  final TextStyle style;
  final ValueChanged<bool> onChanged;

  RadioRowWidget({
    Key key,
    @required this.title,
    @required this.trueText,
    @required this.falseText,
    @required this.checked,
    this.style = const TextStyle(fontSize: 15),
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '$title',
            style: style,
          ),
          Expanded(
            child: Gaps.empty,
            flex: 1,
          ),
          Radio(
            value: true,
            groupValue: checked,
            onChanged: onChanged,
          ),
          Text(
            '$trueText',
            style: style,
          ),
          Radio(
            value: false,
            groupValue: checked,
            onChanged: onChanged,
          ),
          Text(
            '$falseText',
            style: style,
          ),
        ],
      ),
    );
  }
}

/// 单行文本输入控件
@Deprecated('已被DataDictWidget替代，后续将删除')
class EditRowWidget3 extends StatelessWidget {
  final String title;
  final String hintText;
  final bool readOnly;
  final TextEditingController controller;
  final GestureTapCallback onTap;
  final Widget popupMenuButton;

  EditRowWidget3({
    Key key,
    @required this.title,
    this.hintText = '请输入',
    this.readOnly = false,
    @required this.controller,
    this.onTap,
    this.popupMenuButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: Row(
        children: <Widget>[
          Text(
            '$title',
            style: TextStyle(fontSize: 15),
          ),
          Gaps.hGap20,
          Flexible(
            child: Stack(
              children: <Widget>[
                TextField(
                  onTap: onTap,
                  controller: controller,
                  readOnly: readOnly,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: '$hintText',
                    hintStyle: TextStyle(fontSize: 15),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  child: popupMenuButton ?? Gaps.empty,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 多行文本输入控件
class TextAreaWidget extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final GestureTapCallback onTap;
  final int maxLines;

  TextAreaWidget({
    Key key,
    this.title,
    this.hintText = '请输入',
    this.controller,
    this.onChanged,
    this.onTap,
    this.maxLines = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title != null
            ? Container(
                height: 46,
                child: Row(
                  children: <Widget>[
                    Text(
                      '$title',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              )
            : Gaps.empty,
        Container(
          child: TextField(
            onTap: onTap ?? () {},
            controller: controller,
            onChanged: onChanged,
            textAlign: TextAlign.start,
            maxLines: maxLines,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 0, bottom: 16),
              hintText: '$hintText',
              hintStyle: TextStyle(fontSize: 15),
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        )
      ],
    );
  }
}

/// [DetailRowWidget]加载完成后的回调函数
typedef DetailRowLoaded<T> = void Function(T value);

/// 详情加载单行控件
class DetailRowWidget<T> extends StatelessWidget {
  final String title;
  final String content;
  final DetailBloc detailBloc;
  final double height;

  /// 加载完成后触发的回调函数
  final DetailRowLoaded<T> onLoaded;

  /// 加载失败后的点击事件
  final GestureTapCallback onErrorTap;

  DetailRowWidget({
    Key key,
    @required this.title,
    @required this.content,
    @required this.detailBloc,
    this.height = 46,
    @required this.onLoaded,
    this.onErrorTap,
  })  : assert(detailBloc != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailBloc, DetailState>(
      bloc: detailBloc,
      listener: (context, state) {
        if (state is DetailLoaded) {
          // 请求完成后通过回调把实体类传递出去
          onLoaded(state.detail);
        }
      },
      child: BlocBuilder<DetailBloc, DetailState>(
        bloc: detailBloc,
        builder: (context, state) {
          return Container(
            height: height,
            child: Row(
              children: <Widget>[
                Text(
                  '$title',
                  style: const TextStyle(fontSize: 15),
                ),
                Gaps.hGap20,
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: state is DetailError ? onErrorTap : () {},
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        content == null || content == ''
                            ? () {
                                if (state is DetailLoading)
                                  return '$title加载中';
                                else if (state is DetailError)
                                  return '$title加载失败';
                                else if (state is DetailLoaded)
                                  return '$content';
                                else
                                  return '未知状态，state=$state';
                              }()
                            : content,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15,
                          color: content == null || content == ''
                              ? () {
                                  if (state is DetailError)
                                    return Colors.red;
                                  else
                                    return Colours.secondary_text;
                                }()
                              : Colours.primary_text,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 信息展示单行控件
class InfoRowWidget extends StatelessWidget {
  final String title;
  final String content;

  InfoRowWidget({
    @required this.title,
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 46),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: <Widget>[
            Text(
              '$title',
              style: TextStyle(fontSize: 15),
            ),
            Gaps.hGap20,
            Expanded(
              flex: 1,
              child: Text(
                '$content',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 登录页选择用户类型按钮 左边图片右边文字 可改透明度
class IconCheckButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final Color color;
  final bool checked;
  final TextStyle style;
  final EdgeInsetsGeometry padding;
  final int flex;
  final GestureTapCallback onTap;

  IconCheckButton({
    this.text,
    this.imagePath,
    this.imageWidth = 30,
    this.imageHeight = 30,
    this.color,
    this.checked = true,
    this.style = const TextStyle(color: Colors.white, fontSize: 13),
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    this.flex = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Opacity(
        opacity: checked ? 1 : 0.5,
        child: FlatButton(
          onPressed: onTap ?? () {},
          padding: padding,
          color: color,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                imagePath,
                height: imageHeight,
                width: imageWidth,
              ),
              Expanded(
                child: AutoSizeText(
                  text,
                  style: style,
                  maxLines: 1,
                  minFontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingDialog extends Dialog {
  final String text;

  LoadingDialog({
    Key key,
    this.text = '加载中',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Material(
        // 透明类型
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: 120.0,
            height: 120.0,
            child: Container(
              decoration: const ShapeDecoration(
                color: Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SpinKitFadingCube(
                    color: Theme.of(context).primaryColor,
                    size: 25.0,
                  ),
                  Gaps.vGap25,
                  Text(
                    text,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}

/// 监控点统计网格控件
class OnlineMonitorStatisticsGrid extends StatelessWidget {
  final List<Meta> metaList;

  OnlineMonitorStatisticsGrid({
    Key key,
    this.metaList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWellButton1(
              meta: metaList[0],
            ),
            VerticalDividerWidget(height: 40),
            InkWellButton1(
              meta: metaList[1],
            ),
            VerticalDividerWidget(height: 40),
            InkWellButton1(
              meta: metaList[2],
            ),
          ],
        ),
        Row(
          children: <Widget>[
            InkWellButton1(
              meta: metaList[3],
            ),
            VerticalDividerWidget(height: 40),
            InkWellButton1(
              meta: metaList[4],
            ),
            VerticalDividerWidget(height: 40),
            InkWellButton1(
              meta: metaList[5],
            ),
          ],
        ),
        Row(
          children: <Widget>[
            InkWellButton1(
              meta: metaList[6],
            ),
            VerticalDividerWidget(height: 40),
            InkWellButton1(
              meta: metaList[7],
            ),
            VerticalDividerWidget(height: 40),
            InkWellButton1(
              meta: metaList[8],
            ),
          ],
        ),
      ],
    );
  }
}

/// 污染源企业统计网格控件
class PollutionEnterStatisticsGrid extends StatelessWidget {
  final List<Meta> metaList;

  PollutionEnterStatisticsGrid({
    Key key,
    this.metaList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWellButton1(
              meta: metaList[0],
            ),
            VerticalDividerWidget(height: 30),
            InkWellButton1(
              meta: metaList[1],
            ),
            VerticalDividerWidget(height: 30),
            InkWellButton1(
              meta: metaList[2],
            ),
          ],
        ),
        Row(
          children: <Widget>[
            InkWellButton1(
              meta: metaList[3],
            ),
            VerticalDividerWidget(height: 30),
            InkWellButton1(
              meta: metaList[4],
            ),
            VerticalDividerWidget(height: 30),
            InkWellButton1(
              meta: metaList[5],
            ),
          ],
        ),
        Row(
          children: <Widget>[
            InkWellButton1(
              meta: metaList[6],
            ),
            VerticalDividerWidget(height: 30),
            InkWellButton1(
              meta: metaList[7],
            ),
            VerticalDividerWidget(height: 30),
            InkWellButton1(
              meta: metaList[8],
            ),
          ],
        ),
      ],
    );
  }
}
