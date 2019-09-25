import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class IndexEvent extends Equatable {
  IndexEvent([List props = const []]) : super(props);
}

class Load extends IndexEvent {
  final bool isFirst;

  Load({@required this.isFirst}) : super([isFirst]);

  @override
  String toString() => 'Load';
}
