import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

class Upload extends UploadEvent {
  final data;

  const Upload({@required this.data});

  @override
  List<Object> get props => [data];
}

class Update extends UploadEvent {
  final int progress;

  const Update({@required this.progress});

  @override
  List<Object> get props => [progress];
}

class Cancel extends UploadEvent {}
