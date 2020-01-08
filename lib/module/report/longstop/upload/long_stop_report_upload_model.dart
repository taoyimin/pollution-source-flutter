import 'package:equatable/equatable.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';

class LongStopReportUpload extends Equatable {
  final Enter enter; //企业
  final DateTime startTime; //开始时间
  final DateTime endTime; //结束时间
  final String remark; //备注

  const LongStopReportUpload({
    this.enter,
    this.startTime,
    this.endTime,
    this.remark,
  });

  @override
  List<Object> get props => [
        enter,
        startTime,
        endTime,
        remark,
      ];

  LongStopReportUpload copyWith({
    Enter enter,
    DateTime startTime,
    DateTime endTime,
    String remark,
  }) {
    return LongStopReportUpload(
      enter: enter ?? this.enter,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      remark: remark ?? this.remark,
    );
  }
}
