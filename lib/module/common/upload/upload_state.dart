import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

class UploadInitial extends UploadState {}

class Uploading extends UploadState {
  final CancelToken cancelToken;

  const Uploading({@required this.cancelToken});

  @override
  List<Object> get props => [cancelToken];
}

class UploadSuccess extends UploadState {
  final String message;

  const UploadSuccess({@required this.message});

  @override
  List<Object> get props => [message];
}

class UploadFail extends UploadState {
  final String message;

  const UploadFail({@required this.message});

  @override
  List<Object> get props => [message];
}
