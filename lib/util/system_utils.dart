import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/util/compat_utils.dart';
import 'package:pollution_source/util/file_utils.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// 系统工具类
///
/// 用于调用系统相关功能
class SystemUtils {
  /// 当前平台是否为Web
  static const isWeb = kIsWeb;

  /// 调起拨号页
  static void launchTelURL(String phone) async {
    String url = 'tel:' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Toast.show('拨号失败！');
    }
  }

  /// 检查是否拥有定位权限
  static Future<bool> checkLocationPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.location]);
      if (permissions[PermissionGroup.location] != PermissionStatus.granted) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  /// 检查是否需要更新
  static Future<bool> checkUpdate(context) async {
    if(isWeb)
      return false;
    Response response = await CompatUtils.getDio()
        .get(CompatUtils.getApi(HttpApi.checkVersion));
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      if (checkVersion(
          packageInfo.buildNumber, response.data['android']['build'])) {
        String title = response.data['android']['title'];
        String describe = response.data['android']['describe'];
        String url = response.data['android']['url'];
        bool force = response.data['android']['force'];
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return WillPopScope(
                child: AlertDialog(
                  title: Text('$title'),
                  content: Text('$describe'),
                  actions: <Widget>[
                    Offstage(
                      offstage: force,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("取消"),
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        if (!force) Navigator.of(context).pop();
                        ProgressDialog pr;
                        try {
                          Attachment attachment = Attachment(
                            fileName: FileUtils.getFileNameByUrl(url),
                            url: url,
                            size: null,
                          );
                          String localPath = await FileUtils
                              .getAttachmentLocalPathByAttachment(attachment);
                          if (await File(localPath).exists()) {
                            // 安装包已经存在,先删除
                            File(localPath).deleteSync();
                          }
                          pr = ProgressDialog(
                            context,
                            type: ProgressDialogType.Download,
                            isDismissible: true,
                            showLogs: true,
                          );
                          pr.style(
                            message: '正在下载安装包...',
                            borderRadius: 10.0,
                            backgroundColor: Colors.white,
                            elevation: 10.0,
                            insetAnimCurve: Curves.easeInOut,
                            progress: 0.0,
                            maxProgress: 100.0,
                            progressTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400,
                            ),
                            messageTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                          pr.show();
                          await FileDioUtils.instance
                              .getDio()
                              .download("${attachment.url}", localPath,
                                  onReceiveProgress: (int count, int total) {
                            pr.update(
                              progress: double.parse(
                                  (count * 100 / total).toStringAsFixed(2)),
                            );
                          });
                          OpenFile.open(localPath);
                        } catch (e) {
                          Toast.show(e.toString());
                        }
                        if (pr?.isShowing() ?? false) {
                          pr.hide().then((isHidden) {});
                        }
                      },
                      child: const Text("确定"),
                    ),
                  ],
                ),
                onWillPop: () async {
                  return false;
                },
              );
            });
      }
      return checkVersion(
          packageInfo.buildNumber, response.data['android']['build']);
    } else if (Platform.isIOS) {
      if (checkVersion(
          packageInfo.buildNumber, response.data['ios']['build'])) {
        // TODO
      }
      return checkVersion(
          packageInfo.buildNumber, response.data['ios']['build']);
    } else {
      return false;
    }
  }

  /// 检查版本号，返回是否需要更新
  static bool checkVersion(currentBuildCode, targetBuildCode) {
    return int.parse(currentBuildCode) < targetBuildCode;
  }

  /// 调起二维码扫描页
//  static Future<String> scan() async {
//    try {
//      return await BarcodeScanner.scan();
//    } catch (e) {
//      if (e is PlatformException) {
//        if (e.code == BarcodeScanner.CameraAccessDenied) {
//          Toast.show("没有相机权限！");
//        }
//      }
//    }
//    return null;
//  }

  /// 调用图片选择器 [selectedAssets]为默认选中的图片
  static Future<List<Asset>> loadAssets(List<Asset> selectedAssets) async {
    List<Asset> resultAssets;
    try {
      resultAssets = await MultiImagePicker.pickImages(
        enableCamera: true,
        maxImages: 10,
        selectedAssets: selectedAssets ?? List<Asset>(),
        materialOptions: MaterialOptions(
          actionBarTitle: '选取图片',
          allViewTitle: '全部图片',
          actionBarColor: '#03A9F4',
          actionBarTitleColor: '#FFFFFF',
          lightStatusBar: false,
          statusBarColor: '#0288D1',
          startInAllView: false,
          useDetailsView: true,
          selectCircleStrokeColor: '#FFFFFF',
          selectionLimitReachedText: '已达到可选图片最大数',
        ),
      );
    } on NoImagesSelectedException {
      //Toast.show('没有选择任何图片');
      return selectedAssets;
    } on Exception catch (e) {
      Toast.show('选择图片错误！错误信息：$e');
    }
    return resultAssets ?? List<Asset>();
  }

  /// IOS平台键盘配置
  static KeyboardActionsConfig getKeyboardActionsConfig(List<FocusNode> list) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: List.generate(
        list.length,
        (i) => KeyboardAction(
          focusNode: list[i],
          closeWidget: const Padding(
            padding: const EdgeInsets.all(5.0),
            child: const Text("关闭"),
          ),
        ),
      ),
    );
  }
}

/// 默认dialog背景色为半透明黑色，这里修改源码改为透明
@deprecated
Future<T> showTransparentDialog<T>({
  @required BuildContext context,
  bool barrierDismissible = true,
  WidgetBuilder builder,
}) {
  final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: const Color(0x00FFFFFF),
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: _buildMaterialDialogTransitions,
  );
}

@deprecated
Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

@deprecated
Future<T> showElasticDialog<T>({
  @required BuildContext context,
  bool barrierDismissible = true,
  WidgetBuilder builder,
}) {
  final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 550),
    transitionBuilder: _buildDialogTransitions,
  );
}

@deprecated
Widget _buildDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: animation,
        curve: animation.status != AnimationStatus.forward
            ? Curves.easeOutBack
            : ElasticOutCurve(0.85),
      )),
      child: child,
    ),
  );
}
