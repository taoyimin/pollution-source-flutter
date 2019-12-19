import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/report/longstop/detail/long_stop_report_detail_model.dart';

class LongStopReportDetailRepository
    extends DetailRepository<LongStopReportDetail> {
  @override
  HttpApi createApi() {
    return HttpApi.longStopReportDetail;
  }

  @override
  LongStopReportDetail fromJson(json) {
    return LongStopReportDetail.fromJson(json);
  }
}
