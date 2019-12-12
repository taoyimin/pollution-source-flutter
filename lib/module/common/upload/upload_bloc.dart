import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pollution_source/http/http.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';

///上传业务使用的bloc
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
      yield Uploading();
      String message = await uploadRepository.upload(event.data);
      yield UploadSuccess(message: message);
    } catch (e) {
      print('${ExceptionHandle.handleException(e).msg}');
      yield UploadFail(message: ExceptionHandle.handleException(e).msg);
    }
  }
}
