import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'monitor_statistics_model.g.dart';

@JsonSerializable()
class MonitorStatistics extends Equatable {
  final String name;
  final String code;
  @JsonKey(name: 'cnt')
  final int count;

  const MonitorStatistics({this.name, this.code, this.count});

  Color get color {
    switch (code) {
      case 'all':
        return Color.fromRGBO(77, 167, 248, 1);
      case 'online':
        return Color.fromRGBO(136, 191, 89, 1);
      case 'warn':
        return Color.fromRGBO(241, 190, 67, 1);
      case 'outrange':
        return Color.fromRGBO(233, 119, 111, 1);
      case 'negativeValue':
        return Color.fromRGBO(0, 188, 212, 1);
      case 'ultraUpperlimit':
        return Color.fromRGBO(255, 87, 34, 1);
      case 'zeroValue':
        return Color.fromRGBO(106, 106, 255, 1);
      case 'offline':
        return Color.fromRGBO(179, 129, 127, 1);
      case 'stopline':
        return Color.fromRGBO(137, 137, 137, 1);
      default:
        return Colors.black;
    }
  }

  String get imagePath {
    switch (code) {
      case 'all':
        return 'assets/images/icon_monitor_all.png';
      case 'online':
        return 'assets/images/icon_monitor_online.png';
      case 'warn':
        return 'assets/images/icon_monitor_alarm.png';
      case 'outrange':
        return 'assets/images/icon_monitor_over.png';
      case 'negativeValue':
        return 'assets/images/icon_monitor_negative_value.png';
      case 'ultraUpperlimit':
        return 'assets/images/icon_monitor_large_value.png';
      case 'zeroValue':
        return 'assets/images/icon_monitor_zero_value.png';
      case 'offline':
        return 'assets/images/icon_monitor_offline.png';
      case 'stopline':
        return 'assets/images/icon_monitor_stop.png';
      default:
        return '';
    }
  }

  @override
  List<Object> get props => [name, code, count];

  factory MonitorStatistics.fromJson(Map<String, dynamic> json) =>
      _$MonitorStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$MonitorStatisticsToJson(this);
}
