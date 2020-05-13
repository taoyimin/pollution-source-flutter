import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_model.dart';
import 'package:pollution_source/module/common/list/list_repository.dart';
import 'package:pollution_source/module/common/list/list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final ListRepository listRepository;

  ListBloc({@required this.listRepository}) : assert(listRepository != null);

  @override
  ListState get initialState => ListInitial();

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is ListLoad) {
      // 加载列表
      yield* _mapListLoadToState(event);
    } else if (event is ListUpdate) {
      yield* _mapListUpdateToState(event);
    }
  }

  Stream<ListState> _mapListLoadToState(ListLoad event) async* {
    try {
      CancelToken cancelToken = CancelToken();
      yield ListLoading(cancelToken: cancelToken);
      final currentState = state;
      final ListPage listPage = await listRepository.request(
          params: event.params, cancelToken: cancelToken);
      if (!event.isRefresh && currentState is ListLoaded) {
        // 加载更多
        yield ListLoaded(
          list: currentState.list + listPage.list,
          currentPage: listPage.currentPage,
          hasNextPage: listPage.hasNextPage,
          total: listPage.total,
        );
      } else {
        // 首次加载或刷新
        if (listPage.list.length == 0) {
          // 没有数据
          yield ListEmpty();
        } else {
          yield ListLoaded(
            list: listPage.list,
            currentPage: listPage.currentPage,
            hasNextPage: listPage.hasNextPage,
            total: listPage.total,
          );
        }
      }
    } catch (e) {
      yield ListError(message: ExceptionHandle
          .handleException(e)
          .msg);
    }
  }

  Stream<ListState> _mapListUpdateToState(ListUpdate event) async* {
    final currentState = state;
    if (currentState is ListLoaded) {
      yield ListLoaded(
        list: currentState.list,
        currentPage: currentState.currentPage,
        hasNextPage: currentState.hasNextPage,
        total: currentState.total,
      );
    }
  }
}
