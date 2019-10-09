import 'package:equatable/equatable.dart';

abstract class IndexEvent extends Equatable {}

class Load extends IndexEvent {
  @override
  String toString() => 'Load';
}
