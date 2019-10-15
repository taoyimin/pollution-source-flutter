import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MonitorDetailEvent extends Equatable {
  MonitorDetailEvent([List props = const []]) : super(props);
}

class MonitorDetailLoad extends MonitorDetailEvent {
  //监控点ID
  final String monitorId;

  MonitorDetailLoad({
    @required this.monitorId,
  }) : super([
          monitorId,
        ]);

  @override
  String toString() => 'MonitorDetailLoad';
}
