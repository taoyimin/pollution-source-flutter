/*
import 'package:flutter/material.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              Image.asset(
                "assets/images/login_logo.png",
                height: 200,
              ),
              Container(
                width: 270,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  decoration: InputDecoration.collapsed(
                    hintText: '用户名',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 270,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  decoration: InputDecoration.collapsed(
                    hintText: '密码',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/util/utils.dart';
import 'package:pollution_source/widget/my_button.dart';
import 'package:pollution_source/widget/text_field.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:pollution_source/res/colors.dart';

import 'enter_home.dart';
import 'home.dart';

/// design/1注册登录/module.index.html
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //定义一个controller
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  KeyboardActionsConfig _config;
  bool _isClick = false;

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

  void _login() async {
    try {
      if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
        Response response = await JavaDioUtils.instance.getDio().get(HttpApiJava.login,
            queryParameters: {
              'userName': _nameController.text,
              'password': _passwordController.text
            });
        //登录成功
        SpUtil.putString(Constant.spUsername, _nameController.text);
        SpUtil.putString(Constant.spPassword, _passwordController.text);
        SpUtil.putString(Constant.spToken,
            response.data[Constant.responseDataKey][Constant.responseTokenKey]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
        );
      } else {
        Response response = await PythonDioUtils.instance.getDio().post(
          HttpApiPython.token,
          data: {
            'userName': _nameController.text,
            'passWord': _passwordController.text
          },
        );
        //登录成功
        SpUtil.putString(Constant.spUsername, _nameController.text);
        SpUtil.putString(Constant.spPassword, _passwordController.text);
        SpUtil.putString(Constant.spToken,
            'Bearer ${response.data[Constant.responseTokenKey]}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
        );
      }
    } catch (e) {
      Toast.show(ExceptionHandle.handleException(e).msg);
    }

    /*FlutterStars.SpUtil.putString('username', _nameController.text);
    FlutterStars.SpUtil.putString('password', _passwordController.text);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      ),
    );*/
  }

  void _enterLogin() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EnterHomePage();
        },
      ),
    );
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
      padding:const EdgeInsets.only(left: 26.0, right: 26.0, top: 50.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            /*onTap: () async {
              Response response = await DioUtils.instance.getDio().patch(
                'api/users/875',
                data: {
                  'userName': _nameController.text,
                  'passWord': _passwordController.text
                },
              );
            },*/
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
          //Gaps.vGap16,
          SizedBox(
            height: 16,
          ),
          MyTextField(
            key: const Key('username'),
            focusNode: _nodeText1,
            controller: _nameController,
            maxLength: 20,
            keyboardType: TextInputType.text,
            hintText: "请输入账号",
          ),
          SizedBox(
            height: 8,
          ),
          MyTextField(
            key: const Key('password'),
            keyName: 'password',
            focusNode: _nodeText2,
            config: _config,
            isInputPwd: true,
            controller: _passwordController,
            maxLength: 16,
            hintText: "请输入密码",
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 15,
          ),
          MyButton(
            key: const Key('login'),
            onPressed: _isClick ? _login : null,
            color: Colors.lightGreen,
            text: "环保登录",
          ),
          SizedBox(
            height: 15,
          ),
          MyButton(
            key: const Key('enterLogin'),
            onPressed: _isClick ? _enterLogin : null,
            text: "企业登录",
          ),
          Container(
            height: 40.0,
            alignment: Alignment.centerRight,
            child: GestureDetector(
              child: Text(
                '忘记密码',
                style: TextStyle(
                    fontSize: 12, color: Colors.white.withOpacity(0.7)),
              ),
              onTap: () {},
            ),
          ),
          //Gaps.vGap16,
          Container(
            alignment: Alignment.center,
            child: GestureDetector(
              child: const Text(
                '还没账号？快去注册',
                style: TextStyle(color: Colours.primary_color),
              ),
              onTap: () {},
            ),
          )
        ],
      ),
    );
  }
}
