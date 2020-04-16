import 'package:equatable/equatable.dart';

abstract class SystemConfigEvent extends Equatable {
  const SystemConfigEvent();

  @override
  List<Object> get props => [];
}

class SystemConfigLoad extends SystemConfigEvent {}
