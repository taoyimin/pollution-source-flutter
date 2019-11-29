import 'package:equatable/equatable.dart';

//异常申报单详情
class LongStopReportUpload extends Equatable {
  final DateTime startTime; //开始时间
  final DateTime endTime; //结束时间
  final String remark; //备注

  const LongStopReportUpload({
    this.startTime,
    this.endTime,
    this.remark,
  });

  @override
  List<Object> get props => [
        startTime,
        endTime,
        remark,
      ];

  LongStopReportUpload copyWith({
    DateTime startTime,
    DateTime endTime,
    String remark,
  }) {
    return LongStopReportUpload(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      remark: remark ?? this.remark,
    );
  }
}
