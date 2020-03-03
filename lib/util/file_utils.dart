import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pollution_source/module/common/common_model.dart';

class FileUtils {
  /// 获取app根目录
  static Future<String> getApplicationDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  /// 获取app临时缓存目录
  static Future<String> getCacheDirectory() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  /// 根据文件名获取本地路径 传入真实文件名
  static Future<String> getAttachmentLocalPathByFileName(
      String fileName) async {
    return join(await getApplicationDirectory(), fileName);
  }

  /// 根据附件实体类获取附件的本地路径
  static Future<String> getAttachmentLocalPathByAttachment(
      Attachment attachment) async {
    return await getAttachmentLocalPathByFileName(
        getFileNameByAttachment(attachment));
  }

  /// 根据url获取文件名，url为null返回空字符串
  static String getFileNameByUrl(String url) {
    return url?.substring(url.lastIndexOf('/') + 1) ?? '';
  }

  /// 根据附件实体类获取真实文件名
  static String getFileNameByAttachment(Attachment attachment) {
    return getFileNameByUrl(attachment.url);
  }

  /// 清空缓存文件
  static Future<void> clearApplicationDirectory() async {
    String appDocDir = await getApplicationDirectory();
    File(appDocDir).deleteSync(recursive: true);
  }
}
