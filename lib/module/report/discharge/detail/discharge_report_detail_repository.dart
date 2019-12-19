import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/report/discharge/detail/discharge_report_detail_model.dart';

class DischargeReportDetailRepository
    extends DetailRepository<DischargeReportDetail> {
  @override
  HttpApi createApi() {
    return HttpApi.dischargeReportDetail;
  }

  @override
  DischargeReportDetail fromJson(json) {
    return DischargeReportDetail.fromJson(json);
  }
}
