import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';

import 'system_config_model.dart';

class SystemConfigRepository extends DataDictRepository {
  SystemConfigRepository(HttpApi httpApi) : super(httpApi);

  @override
  DataDict fromJson(json) {
    return SystemConfig.fromJson(json);
  }
}
