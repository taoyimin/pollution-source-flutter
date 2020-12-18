import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
// import 'package:keyboard_actions/keyboard_actions.dart';

/// 登录模块的输入框封装
class LoginTextField extends StatefulWidget {
  const LoginTextField({
    Key key,
    @required this.controller,
    this.maxLength: 16,
    this.autoFocus: false,
    this.keyboardType: TextInputType.text,
    this.hintText: "",
    this.focusNode,
    this.isInputPwd: false,
    // this.config,
    this.keyName,
    this.style: const TextStyle(color: Colours.primary_text, fontSize: 14),
    this.hintStyle: const TextStyle(color: Colours.secondary_text, fontSize: 14),
  }) : super(key: key);

  final TextEditingController controller;
  final int maxLength;
  final bool autoFocus;
  final TextInputType keyboardType;
  final String hintText;
  final FocusNode focusNode;
  final bool isInputPwd;
  final TextStyle style;
  final TextStyle hintStyle;

  // final KeyboardActionsConfig config;

  /// 用于集成测试寻找widget
  final String keyName;

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool _isShowPwd = false;
  bool _isShowDelete;

  @override
  void initState() {
    super.initState();

    /// 获取初始化值
    _isShowDelete = widget.controller.text.isEmpty;

    /// 监听输入改变
    widget.controller.addListener(() {
      setState(() {
        _isShowDelete = widget.controller.text.isEmpty;
      });
    });
//    if (widget.config != null && defaultTargetPlatform == TargetPlatform.iOS) {
//      // 因Android平台输入法兼容问题，所以只配置IOS平台
//      FormKeyboardActions.setKeyboardActions(context, widget.config);
//    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(() {});
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        TextField(
          style: widget.style,
          focusNode: widget.focusNode,
          maxLength: widget.maxLength,
          obscureText: widget.isInputPwd ? !_isShowPwd : false,
          autofocus: widget.autoFocus,
          controller: widget.controller,
          textInputAction: TextInputAction.done,
          keyboardType: widget.keyboardType,
          // 数字、手机号限制格式为0到9(白名单)， 密码限制不包含汉字（黑名单）
          inputFormatters: (widget.keyboardType == TextInputType.number ||
                  widget.keyboardType == TextInputType.phone)
              ? [FilteringTextInputFormatter.allow(RegExp("[0-9]"))]
              : [FilteringTextInputFormatter.deny(RegExp("[\u4e00-\u9fa5]"))],
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
              hintText: widget.hintText,
              hintStyle: widget.hintStyle,
              counterText: "",
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colours.primary_color, width: 0.8)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colours.line, width: 0.8))),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _isShowDelete
                ? Gaps.empty
                : GestureDetector(
                    child: Image.asset(
                      'assets/images/icon_login_delete.png',
                      key: Key('${widget.keyName}_delete'),
                      height: 18,
                      width: 18,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      widget.controller.text = "";
                    },
                  ),
            !widget.isInputPwd ? Gaps.empty : Gaps.hGap15,
            !widget.isInputPwd
                ? Gaps.empty
                : GestureDetector(
                    child: Image.asset(
                      _isShowPwd
                          ? 'assets/images/icon_login_display.png'
                          : 'assets/images/icon_login_hide.png',
                      key: Key('${widget.keyName}_showPwd'),
                      height: 18,
                      width: 18,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    },
                  ),
          ],
        )
      ],
    );
  }
}
