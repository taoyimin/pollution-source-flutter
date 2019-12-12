import 'package:flutter/material.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';

class UploadDialog extends Dialog {
  final UploadBloc uploadBloc;

  UploadDialog({Key key, @required this.uploadBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: (MediaQuery.of(context).size.height / 2) * 0.6,
                    child: Card(
                      elevation: 0.0,
                      margin: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/men_wearing_jackets.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: const Text(
                      '上传中，请耐心等待...',
                      style: TextStyle(fontSize: 16),
                    ),
                    /*child: BlocBuilder<UploadBloc, UploadState>(
                      bloc: uploadBloc,
                      builder: (context, state) {
                        if (state is UploadSuccess) {
                          return Text('上传成功');
                        } else if (state is ProgressUpdate) {
                          return Text('${state.progress}');
                        }else{
                          return Text('未知状态');
                        }
                      },
                    ),*/
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
