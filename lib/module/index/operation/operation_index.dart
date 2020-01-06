import 'package:flutter/material.dart';

class OperationIndexPage extends StatefulWidget {
  OperationIndexPage({Key key}) : super(key: key);

  @override
  _OperationIndexPageState createState() => _OperationIndexPageState();
}

class _OperationIndexPageState extends State<OperationIndexPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(child: Text('运维首页')),
    );
  }
}
