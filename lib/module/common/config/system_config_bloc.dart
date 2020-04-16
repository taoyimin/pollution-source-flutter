import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/http.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/config/system_config_event.dart';
import 'package:pollution_source/module/common/config/system_config_repository.dart';
import 'package:pollution_source/module/common/config/system_config_state.dart';

class SystemConfigBloc extends Bloc<SystemConfigEvent, SystemConfigState> {
  final SystemConfigRepository systemConfigRepository;

  SystemConfigBloc({@required this.systemConfigRepository})
      : assert(systemConfigRepository != null);

  @override
  SystemConfigState get initialState => SystemConfigInitial();

  @override
  Stream<SystemConfigState> mapEventToState(SystemConfigEvent event) async* {
    if (event is SystemConfigLoad) {
      yield* _mapSystemConfigLoadToState(event);
    }
  }

  /// 处理加载系统配置事件
  Stream<SystemConfigState> _mapSystemConfigLoadToState(SystemConfigLoad event) async* {
    try {
      CancelToken cancelToken = CancelToken();
      yield SystemConfigLoading(cancelToken: cancelToken);
      final systemConfig =
          await systemConfigRepository.request(cancelToken: cancelToken);
      yield SystemConfigLoaded(systemConfig: systemConfig);
    } catch (e) {
      yield SystemConfigError(message: ExceptionHandle.handleException(e).msg);
    }
  }
}
