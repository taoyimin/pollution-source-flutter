import 'package:bloc/bloc.dart';
import 'package:pollution_source/http/http.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/common/dict/data_dict_state.dart';

class DataDictBloc extends Bloc<DataDictEvent, DataDictState> {
  final DataDictRepository dataDictRepository;

  DataDictBloc({@required this.dataDictRepository})
      : assert(dataDictRepository != null);

  @override
  DataDictState get initialState => DataDictInitial();

  @override
  Stream<DataDictState> mapEventToState(DataDictEvent event) async* {
    if (event is DataDictLoad) {
      yield* _mapReportDataDictLoadToState(event);
    }
  }

  //处理加载数据字典列表事件
  Stream<DataDictState> _mapReportDataDictLoadToState(
      DataDictLoad event) async* {
    try {
      yield DataDictLoading();
      final dataDictList = await dataDictRepository.request();
      yield DataDictLoaded(dataDictList: dataDictList);
    } catch (e) {
      yield DataDictError(
          message: ExceptionHandle.handleException(e).msg);
    }
  }
}