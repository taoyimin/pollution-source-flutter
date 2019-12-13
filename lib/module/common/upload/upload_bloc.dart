import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/http.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';

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
      CancelToken token = CancelToken();
      yield Uploading(token: token);
      String message = await uploadRepository.upload(event.data, token);
      yield UploadSuccess(message: message);
    } catch (e) {
      yield UploadFail(message: ExceptionHandle.handleException(e).msg);
    }
  }
}
