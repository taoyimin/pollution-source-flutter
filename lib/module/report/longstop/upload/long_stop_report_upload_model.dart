import 'package:equatable/equatable.dart';

class LongStopReportUpload extends Equatable {
  final String enterId; //企业Id
  final DateTime startTime; //开始时间
  final DateTime endTime; //结束时间
  final String remark; //备注

  const LongStopReportUpload({
    this.enterId,
    this.startTime,
    this.endTime,
    this.remark,
  });

  @override
  List<Object> get props => [
        enterId,
        startTime,
        endTime,
        remark,
      ];

  LongStopReportUpload copyWith({
    String enterId,
    DateTime startTime,
    DateTime endTime,
    String remark,
  }) {
    return LongStopReportUpload(
      enterId: enterId ?? this.enterId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      remark: remark ?? this.remark,
    );
  }
}
