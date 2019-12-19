import 'package:bloc/bloc.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_repository.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:meta/meta.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final DetailRepository detailRepository;

  DetailBloc({@required this.detailRepository})
      : assert(detailRepository != null);

  @override
  DetailState get initialState => DetailLoading();

  @override
  Stream<DetailState> mapEventToState(DetailEvent event) async* {
    if (event is DetailLoad) {
      yield* _mapReportDetailLoadToState(event);
    }
  }

  //处理加载详情事件
  Stream<DetailState> _mapReportDetailLoadToState(DetailLoad event) async* {
    try {
      yield DetailLoading();
      final detail = await detailRepository.request(
          detailId: event.detailId, params: event.params);
      yield DetailLoaded(detail: detail);
    } catch (e) {
      yield DetailError(message: ExceptionHandle.handleException(e).msg);
    }
  }
}
