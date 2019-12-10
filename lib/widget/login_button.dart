import 'package:flutter/material.dart';
import 'package:pollution_source/res/colors.dart';

//自定义控件：登录按钮
class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
    this.text = '',
    this.color = Colours.primary_color,
    @required this.onPressed,
  }) : super(key: key);

  final String text;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      textColor: Colors.white,
      color: color,
      disabledTextColor: Colors.white.withOpacity(0.7),
      disabledColor: Colours.primary_color.withOpacity(0.5),
      //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        children: <Widget>[
          Container(
            height: 48,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
