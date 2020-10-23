import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/common_utils.dart';
import 'package:pollution_source/util/compat_utils.dart';

/// 修改密码界面
class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('修改密码'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            EditRowWidget(
              title: '旧密码',
              obscureText: true,
              controller: oldPasswordController,
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '新密码',
              obscureText: true,
              controller: newPasswordController,
            ),
            Gaps.hLine,
            EditRowWidget(
              title: '确认新密码',
              hintText: '请确认新密码',
              obscureText: true,
              controller: confirmPasswordController,
            ),
            Gaps.hLine,
            Gaps.vGap30,
            Row(
              children: <Widget>[
                ClipButton(
                  text: '重置',
                  icon: Icons.refresh,
                  color: Colors.orange,
                  onTap: () {
                    oldPasswordController.text = '';
                    newPasswordController.text = '';
                    confirmPasswordController.text = '';
                  },
                ),
                Gaps.hGap16,
                ClipButton(
                  text: '修改',
                  icon: Icons.check,
                  color: Colors.lightBlue,
                  onTap: () async {
                    try {
                      showDialog(
                          context: context,
                          builder: (context){
                            return LoadingDialog(text: '修改密码中...');
                          }
                      );
                      if (TextUtil.isEmpty(oldPasswordController.text)) {
                        throw DioError(error: InvalidParamException('请输入旧密码'));
                      }
                      if (TextUtil.isEmpty(newPasswordController.text)) {
                        throw DioError(error: InvalidParamException('请输入新密码'));
                      }
                      if(!CommonUtils.checkPassword(newPasswordController.text)){
                        throw DioError(error: InvalidParamException('密码最少6位,必须由大写字母，小写字母，数字，特殊符号组成!'));
                      }
                      if (TextUtil.isEmpty(confirmPasswordController.text)) {
                        throw DioError(error: InvalidParamException('请确认新密码'));
                      }
                      if (newPasswordController.text ==
                          oldPasswordController.text) {
                        throw DioError(
                            error: InvalidParamException('新密码与旧密码不能相同'));
                      }
                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
                        throw DioError(
                            error: InvalidParamException('新密码与确认新密码不一致'));
                      }
                      await CompatUtils.getDio().get(
                        CompatUtils.getApi(HttpApi.changePassword),
                        queryParameters: {
                          // 污染源参数
                          'pwdOld': oldPasswordController.text,
                          'pwdNew': newPasswordController.text,
                          // 运维参数
                          'password': oldPasswordController.text,
                          'oldPassword': newPasswordController.text,
                        },
                      );
                      SpUtil.putString(Constant.spPasswordList[SpUtil.getInt(Constant.spUserType)], newPasswordController.text);
                      Navigator.pop(context);
                    } catch (e) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content:
                            Text('${ExceptionHandle.handleException(e).msg}'),
                        action: SnackBarAction(
                          label: '我知道了',
                          onPressed: () {},
                        ),
                      ));
                    } finally{
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
