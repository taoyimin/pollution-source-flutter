import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/report/factor/upload/factor_data_dict_model.dart';

class FactorDataDictRepository extends DataDictRepository {
  FactorDataDictRepository(HttpApi httpApi) : super(httpApi);

  @override
  DataDict fromJson(json) {
    return FactorDataDict.fromJson(json);
  }
}
