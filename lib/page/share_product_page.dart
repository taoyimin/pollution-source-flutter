import 'package:flutter/material.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/util/compat_utils.dart';
import 'package:share/share.dart';

/// 分享产品界面
class ShareProductPage extends StatefulWidget {
  @override
  _ShareProductPageState createState() => _ShareProductPageState();
}

class _ShareProductPageState extends State<ShareProductPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('分享产品'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 46),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(CompatUtils.getDownloadQRcode()),
            ),
            const Text(
              '扫码下载或点击下方按钮进行分享',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            Row(
              children: <Widget>[
                ClipButton(
                  text: '点我分享',
                  icon: Icons.share,
                  color: Colours.primary_color,
                  onTap: () {
                    Share.share(
                      '【下载地址】${CompatUtils.getDownloadUrl()}',
                      subject: '下载地址：',
                    );
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
