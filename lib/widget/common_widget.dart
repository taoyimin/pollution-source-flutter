import 'package:flutter/material.dart';
import 'package:pollution_source/res/colors.dart';

class ListTileWidget extends StatelessWidget{
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