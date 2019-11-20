import 'package:equatable/equatable.dart';

abstract class LicenseListEvent extends Equatable {
  const LicenseListEvent();

  @override
  List<Object> get props => [];
}

class LicenseListLoad extends LicenseListEvent {
  //是否刷新
  final bool isRefresh;

  final String enterId;

  const LicenseListLoad({
    this.isRefresh = false,
    this.enterId = '',
  });

  @override
  List<Object> get props => [
        isRefresh,
        enterId,
      ];
}
