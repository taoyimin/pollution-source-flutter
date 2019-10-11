import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pollution_source/res/colors.dart';

import 'common_model.dart';

///一些通用的小组件
///不放复杂的自定义组件
///复杂自定义组件放widget包中

//页面加载中的widget
class PageLoadingWidget extends StatelessWidget{
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
class PageEmptyWidget extends StatelessWidget{
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
                style: const TextStyle(
                    fontSize: 16.0, color: Colours.grey_color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//页面加载错误的widget
class PageErrorWidget extends StatelessWidget{
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
                style: const TextStyle(
                    fontSize: 16.0, color: Colours.grey_color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//list展示信息
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

//水平分割线
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

//垂直分割线
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
class InkWellWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final List<Widget> children;

  const InkWellWidget({
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
class LabelWidget extends StatelessWidget{
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
          Image.asset(
            this.label.imagePath,
            width: 8,
            height: 8,
            color: this.label.color,
          ),
          Text(
            this.label.name,
            style: TextStyle(color: this.label.color, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

//标签集合widget
class LabelWrapWidget extends StatelessWidget{
  final List<Label> labelList;

  LabelWrapWidget({@required this.labelList});

  @override
  Widget build(BuildContext context) {
   return Wrap(
     spacing: 6,
     runSpacing: 3,
     children: (){
       return labelList.map((label) {
         return LabelWidget(label: label,);
       }).toList();
     }(),
   );
  }
}
