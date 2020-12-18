import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/login/login_repository.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/common_utils.dart';
import 'package:pollution_source/util/compat_utils.dart';
import 'package:pollution_source/util/config_utils.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/login_text_field.dart';

// import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:pollution_source/res/colors.dart';

/// 登录页
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  // KeyboardActionsConfig _config;
  bool _isClick = false;

  /// 当前选中用户类型 0：环保 1：企业 2：运维
  int _userType;
  LoginRepository _loginRepository = LoginRepository();

  @override
  void initState() {
    super.initState();
    // 监听输入改变
    _nameController.addListener(_verify);
    _passwordController.addListener(_verify);
    // _config = SystemUtils.getKeyboardActionsConfig([_nodeText1, _nodeText2]);
    _userType = SpUtil.getInt(Constant.spUserType, defValue: 0);
    // 初始化输入框
    _nameController.text = SpUtil.getString(Constant.spUsernameList[_userType]);
    _passwordController.text =
        SpUtil.getString(Constant.spPasswordList[_userType]);
  }

  @override
  void dispose() {
    // 释放资源(此处执行dispose方法会抛出异常，原因未知)
    // _nameController?.removeListener(_verify);
    // _nameController?.dispose();
    // passwordController?.removeListener(_verify);
    // _passwordController?.dispose();
    super.dispose();
  }

  void _verify() {
    String name = _nameController.text;
    String password = _passwordController.text;
    bool isClick = true;
    if (name.isEmpty) {
      isClick = false;
    }
    if (password.isEmpty) {
      isClick = false;
    }
    // 状态不一样在刷新，避免重复不必要的setState
    if (isClick != _isClick) {
      setState(() {
        _isClick = isClick;
      });
    }
  }

  _login() async {
    if(!CommonUtils.checkPassword(_passwordController.text)){
      Toast.show("您当前使用的是弱密码，无法登录，请前往PC端修改密码！");
      return;
    }
    try {
      Response response = await _loginRepository.login(
        userType: _userType,
        userName: _nameController.text,
        passWord: _passwordController.text,
      );
      // 登录成功
      // 储存userType
      SpUtil.putInt(Constant.spUserType, _userType);
      // 储存userId
      SpUtil.putInt(Constant.spUserId, CompatUtils.getResponseUserId(response));
      // 储存用户名
      SpUtil.putString(
          Constant.spRealName, CompatUtils.getResponseRealName(response));
      // 储存关注程度
      SpUtil.putString(Constant.spAttentionLevel,
          CompatUtils.getResponseAttentionLevel(response));
      // 储存用户级别
      SpUtil.putString(Constant.spGobalLevel,
          CompatUtils.getResponseGobalLevel(response));
      // 储存登录时间
      SpUtil.putString(
        Constant.spLoginTime,
        DateUtil.formatDate(DateTime.now(), format: DateFormats.zh_y_mo_d_h_m),
      );
      // 储存账号
      SpUtil.putString(
          Constant.spUsernameList[_userType], _nameController.text);
      // 存储密码
      SpUtil.putString(
          Constant.spPasswordList[_userType], _passwordController.text);
      // 存储token
      SpUtil.putString(
          Constant.spToken, CompatUtils.getResponseToken(response));
      switch (_userType) {
        case 0:
          Application.router
              .navigateTo(context, '${Routes.adminHome}', clearStack: true);
          break;
        case 1:
          Application.router.navigateTo(context,
              '${Routes.enterHome}/${SpUtil.getInt(Constant.spUserId)}',
              clearStack: true);
          break;
        case 2:
          Application.router
              .navigateTo(context, '${Routes.operationHome}', clearStack: true);
          break;
      }
    } catch (e) {
      Toast.show(ExceptionHandle.handleException(e).msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _buildBody(),
      ),
//      body: defaultTargetPlatform == TargetPlatform.iOS
//          ? FormKeyboardActions(
//              child: _buildBody(),
//            )
//          : SingleChildScrollView(
//              child: _buildBody(),
//            ),
    );
  }

  _buildBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/images/background_login.png",
          ),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.only(left: 26.0, right: 26.0, top: 50.0),
      child: Column(
        children: <Widget>[
          Image.asset(
            "assets/images/login_logo.png",
            height: 200,
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            width: double.infinity,
            child: Text(
              "密码登录",
              style: TextStyle(
                  color: Colours.primary_text.withOpacity(0.6),
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Gaps.vGap16,
          LoginTextField(
            key: const Key('username'),
            focusNode: _nodeText1,
            controller: _nameController,
            maxLength: 20,
            keyboardType: TextInputType.text,
            hintText: "请输入账号",
          ),
          Gaps.vGap10,
          LoginTextField(
            key: const Key('password'),
            keyName: 'password',
            focusNode: _nodeText2,
            // config: _config,
            isInputPwd: true,
            controller: _passwordController,
            maxLength: 16,
            hintText: "请输入密码",
          ),
          Gaps.vGap25,
          Offstage(
            offstage: !ConfigUtils.showEnter() && !ConfigUtils.showOperation(),
            child: Row(
              children: <Widget>[
                IconCheckButton(
                  text: '环保用户',
                  imagePath: 'assets/images/login_icon_admin.png',
                  color: Colors.lightGreen,
                  checked: _userType == 0,
                  onTap: () {
                    setState(() {
                      _userType = 0;
                    });
                    SpUtil.putInt(Constant.spUserType, _userType);
                    _nameController.text =
                        SpUtil.getString(Constant.spUsernameList[_userType]);
                    _passwordController.text =
                        SpUtil.getString(Constant.spPasswordList[_userType]);
                  },
                ),
                Offstage(
                  offstage: !ConfigUtils.showEnter(),
                  child: Gaps.hGap10,
                ),
                IconCheckButton(
                  text: '企业用户',
                  imagePath: 'assets/images/login_icon_enter.png',
                  color: Colors.lightBlueAccent,
                  checked: _userType == 1,
                  show: ConfigUtils.showEnter(),
                  onTap: () {
                    setState(() {
                      _userType = 1;
                    });
                    SpUtil.putInt(Constant.spUserType, _userType);
                    _nameController.text =
                        SpUtil.getString(Constant.spUsernameList[_userType]);
                    _passwordController.text =
                        SpUtil.getString(Constant.spPasswordList[_userType]);
                  },
                ),
                Offstage(
                  offstage: !ConfigUtils.showOperation(),
                  child: Gaps.hGap10,
                ),
                IconCheckButton(
                  text: '运维用户',
                  imagePath: 'assets/images/login_icon_maintain.png',
                  color: Colors.orangeAccent,
                  checked: _userType == 2,
                  show: ConfigUtils.showOperation(),
                  onTap: () {
                    setState(() {
                      _userType = 2;
                    });
                    SpUtil.putInt(Constant.spUserType, _userType);
                    _nameController.text =
                        SpUtil.getString(Constant.spUsernameList[_userType]);
                    _passwordController.text =
                        SpUtil.getString(Constant.spPasswordList[_userType]);
                  },
                ),
              ],
            ),
          ),
          Gaps.vGap15,
          LoginButton(
            key: const Key('login'),
            onPressed: _isClick ? _login : null,
            text: "登录",
          ),
        ],
      ),
    );
  }
}
