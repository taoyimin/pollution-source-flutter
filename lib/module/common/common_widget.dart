import 'package:flutter/material.dart';
import 'package:pollution_source/res/colors.dart';

import 'common_model.dart';

///一些通用的小组件
///不放复杂的自定义组件
///复杂自定义组件放widget包中

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
