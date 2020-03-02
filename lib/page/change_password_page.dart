import 'package:flutter/material.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/toast_utils.dart';

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
      appBar: AppBar(
        title: const Text('修改密码'),
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
                  onTap: () {
                    Toast.show('修改密码功能暂未开放');
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
