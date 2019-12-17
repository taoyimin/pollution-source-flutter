import 'package:flutter/material.dart';
import 'package:pollution_source/res/gaps.dart';

/// 可以播放gif动画的对话框
///
/// 传入[text]设置要显示的文字
/// 传入[onCancelTap]设置取消按钮的点击事件
/// 因为包裹了一层[WillPopScope]，并且重写了[onWillPop]方法
/// 所以点击手机的返回键无法关闭[Dialog]
class GifDialog extends Dialog {
  final String text;
  final GestureTapCallback onCancelTap;

  GifDialog({Key key, this.text = '上传中，请耐心等待...', @required this.onCancelTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: (MediaQuery.of(context).size.height / 2) * 0.6,
                  child: Card(
                    elevation: 0.0,
                    margin: const EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/men_wearing_jackets.gif',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Gaps.vGap10,
                Text(
                  text,
                  style: const TextStyle(fontSize: 16),
                ),
                Gaps.vGap10,
                SizedBox(
                  width: 100,
                  child: FlatButton(
                    onPressed: onCancelTap ?? () {},
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    color: Colors.redAccent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Text(
                          '取消',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                Gaps.vGap10,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
