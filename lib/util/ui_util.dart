import 'package:flutter/material.dart';

class StyleUtil {
  //获取默认的阴影
  static BoxShadow getBoxShadow(){
   return BoxShadow(
     offset: Offset(0, 12),
     color: Color(0xFFDFDFDF),
     blurRadius: 25,
     spreadRadius: -9,
   );
  }
}