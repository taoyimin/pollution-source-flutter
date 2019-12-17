import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/util/utils.dart';
import 'package:pollution_source/widget/login_button.dart';
import 'package:pollution_source/widget/login_text_field.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:pollution_source/res/colors.dart';

import 'enter_home.dart';
import 'admin_home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  KeyboardActionsConfig _config;
  bool _isClick = false;
  //当前选中用户类型 0：环保 1：企业 2：运维
  int _userType;

  @override
  void initState() {
    super.initState();
    //监听输入改变
    _nameController.addListener(_verify);
    _passwordController.addListener(_verify);
    _config = Utils.getKeyboardActionsConfig([_nodeText1, _nodeText2]);
    //初始化输入框
    _nameController.text = SpUtil.getString(Constant.spUsername);
    _passwordController.text = SpUtil.getString(Constant.spPassword);
    _userType = SpUtil.getInt(Constant.spUserType, defValue: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _passwordController.dispose();
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

    /// 状态不一样在刷新，避免重复不必要的setState
    if (isClick != _isClick) {
      setState(() {
        _isClick = isClick;
      });
    }
  }

  void _login(){
    switch(_userType){
      case 0:
        _adminLogin();
        break;
      case 1:
        _enterLogin();
        break;
      case 0:
        _maintainLogin();
        break;
    }
  }

  void _adminLogin() async {
    try {
      if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
        Response response = await JavaDioUtils.instance
            .getDio()
            .get(HttpApiJava.login, queryParameters: {
          'userName': _nameController.text,
          'password': _passwordController.text
        });
        //登录成功
        SpUtil.putInt(Constant.spUserType, _userType);
        SpUtil.putString(Constant.spUsername, _nameController.text);
        SpUtil.putString(Constant.spPassword, _passwordController.text);
        SpUtil.putString(Constant.spToken,
            response.data[Constant.responseDataKey][Constant.responseTokenKey]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AdminHomePage();
            },
          ),
        );
      } else {
        Response response = await PythonDioUtils.instance.getDio().post(
          'admin/${HttpApiPython.token}',
          data: {
            'userName': _nameController.text,
            'passWord': _passwordController.text
          },
        );
        //登录成功
        SpUtil.putInt(Constant.spUserType, _userType);
        SpUtil.putString(Constant.spUsername, _nameController.text);
        SpUtil.putString(Constant.spPassword, _passwordController.text);
        SpUtil.putString(Constant.spToken,
            'Bearer ${response.data[Constant.responseTokenKey]}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AdminHomePage();
            },
          ),
        );
      }
    } catch (e) {
      Toast.show(ExceptionHandle.handleException(e).msg);
    }
  }

  void _enterLogin() async {
    try {
      if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
        Response response = await JavaDioUtils.instance
            .getDio()
            .get(HttpApiJava.login, queryParameters: {
          'userName': _nameController.text,
          'password': _passwordController.text
        });
        //登录成功
        SpUtil.putInt(Constant.spUserType, _userType);
        SpUtil.putString(Constant.spUsername, _nameController.text);
        SpUtil.putString(Constant.spPassword, _passwordController.text);
        SpUtil.putString(Constant.spToken,
            response.data[Constant.responseDataKey][Constant.responseTokenKey]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EnterHomePage(
                enterId: '${response.data['enterId']}',
              );
            },
          ),
        );
      } else {
        Response response = await PythonDioUtils.instance.getDio().post(
          'enter/${HttpApiPython.token}',
          data: {
            'userName': _nameController.text,
            'passWord': _passwordController.text
          },
        );
        //登录成功
        SpUtil.putInt(Constant.spUserType, _userType);
        SpUtil.putString(Constant.spUsername, _nameController.text);
        SpUtil.putString(Constant.spPassword, _passwordController.text);
        SpUtil.putString(Constant.spToken,
            'Bearer ${response.data[Constant.responseTokenKey]}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EnterHomePage(
                enterId: '${response.data['enterId']}',
              );
            },
          ),
        );
      }
    } catch (e) {
      Toast.show(ExceptionHandle.handleException(e).msg);
    }
  }

  void _maintainLogin(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: defaultTargetPlatform == TargetPlatform.iOS
          ? FormKeyboardActions(
              child: _buildBody(),
            )
          : SingleChildScrollView(
              child: _buildBody(),
            ),
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
          GestureDetector(
            onDoubleTap: () {
              SpUtil.putBool(Constant.spJavaApi,
                  !SpUtil.getBool(Constant.spJavaApi, defValue: true));
              SpUtil.getBool(Constant.spJavaApi)
                  ? Toast.show('使用Java后台')
                  : Toast.show('使用Python后台');
            },
            child: Image.asset(
              "assets/images/login_logo.png",
              height: 200,
            ),
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
            config: _config,
            isInputPwd: true,
            controller: _passwordController,
            maxLength: 16,
            hintText: "请输入密码",
          ),
          Gaps.vGap25,
          Row(
            children: <Widget>[
              IconCheckButton(
                text: '环保用户',
                imagePath: 'assets/images/login_icon_admin.png',
                color: Colors.lightGreen,
                checked: _userType == 0,
                onTap: (){
                  setState(() {
                    _userType = 0;
                  });
                },
              ),
              Gaps.hGap10,
              IconCheckButton(
                text: '企业用户',
                imagePath: 'assets/images/login_icon_enter.png',
                color: Colors.lightBlueAccent,
                checked: _userType == 1,
                onTap: (){
                  setState(() {
                    _userType = 1;
                  });
                },
              ),
              Gaps.hGap10,
              IconCheckButton(
                text: '运维用户',
                imagePath: 'assets/images/login_icon_maintain.png',
                color: Colors.orangeAccent,
                checked: _userType == 2,
                onTap: (){
                  setState(() {
                    _userType = 2;
                  });
                },
              ),
            ],
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
