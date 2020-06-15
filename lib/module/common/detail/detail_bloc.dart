import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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
  DetailState get initialState => DetailLoading(cancelToken: null);

  @override
  Stream<DetailState> mapEventToState(DetailEvent event) async* {
    if (event is DetailLoad) {
      yield* _mapReportDetailLoadToState(event);
    } else if (event is DetailUpdate) {
      yield* _mapReportDetailUpdateToState(event);
    }
  }

  /// 处理加载详情事件
  Stream<DetailState> _mapReportDetailLoadToState(DetailLoad event) async* {
    try {
      CancelToken cancelToken = CancelToken();
      yield DetailLoading(cancelToken: cancelToken);
      final detail = await detailRepository.request(
          detailId: event.detailId,
          params: event.params,
          cancelToken: cancelToken);
      if(detail != null)
        yield DetailLoaded(detail: detail);
      else
        yield DetailError(message: '数据为空，请重新加载！');
    } catch (e) {
      yield DetailError(message: ExceptionHandle.handleException(e).msg);
    }
  }

  /// 处理更新详情事件，与DetailLoad唯一不同为不会触发DetailLoading状态
  Stream<DetailState> _mapReportDetailUpdateToState(DetailUpdate event) async* {
    try {
      final detail = await detailRepository.request(
          detailId: event.detailId, params: event.params);
      yield DetailLoaded(detail: detail);
    } catch (e) {
      yield DetailError(message: ExceptionHandle.handleException(e).msg);
    }
  }
}
