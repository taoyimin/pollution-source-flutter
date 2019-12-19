import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/http/http.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/widget/git_dialog.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadRepository uploadRepository;

  UploadBloc({@required this.uploadRepository})
      : assert(uploadRepository != null);

  @override
  UploadState get initialState => UploadInitial();

  @override
  Stream<UploadState> mapEventToState(UploadEvent event) async* {
    if (event is Upload) {
      yield* _mapUploadToState(event);
    }
  }

  Stream<UploadState> _mapUploadToState(Upload event) async* {
    try {
      CancelToken cancelToken = CancelToken();
      yield Uploading(cancelToken: cancelToken);
      String message =
          await uploadRepository.upload(data: event.data, cancelToken: cancelToken);
      yield UploadSuccess(message: message);
    } catch (e) {
      yield UploadFail(message: ExceptionHandle.handleException(e).msg);
    }
  }
}

/// 上报时通用的监听方法
uploadListener(context, state) {
  if (state is Uploading) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => GifDialog(
        onCancelTap: () {
          state.cancelToken?.cancel('取消上传');
        },
      ),
    );
  } else if (state is UploadSuccess) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('${state.message}'),
        action: SnackBarAction(
            label: '我知道了', textColor: Colours.primary_color, onPressed: () {}),
      ),
    );
    Application.router.pop(context);
  } else if (state is UploadFail) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('${state.message}'),
        action: SnackBarAction(
            label: '我知道了', textColor: Colours.primary_color, onPressed: () {}),
      ),
    );
    Application.router.pop(context);
  }
}
