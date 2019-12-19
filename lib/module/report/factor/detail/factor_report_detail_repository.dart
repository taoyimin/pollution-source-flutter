import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/report/factor/detail/factor_report_detail_model.dart';

class FactorReportDetailRepository
    extends DetailRepository<FactorReportDetail> {
  @override
  HttpApi createApi() {
    return HttpApi.factorReportDetail;
  }

  @override
  FactorReportDetail fromJson(json) {
    return FactorReportDetail.fromJson(json);
  }
}
