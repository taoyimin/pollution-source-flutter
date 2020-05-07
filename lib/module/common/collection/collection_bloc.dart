import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pollution_source/http/http.dart';
import 'package:meta/meta.dart';

import 'collection_event.dart';
import 'collection_repository.dart';
import 'collection_state.dart';

class CollectionBloc<T> extends Bloc<CollectionEvent, CollectionState> {
  final CollectionRepository collectionRepository;

  CollectionBloc({@required this.collectionRepository})
      : assert(collectionRepository != null);

  @override
  CollectionState get initialState => CollectionInitial();

  @override
  Stream<CollectionState> mapEventToState(CollectionEvent event) async* {
    if (event is CollectionLoad) {
      yield* _mapCollectionLoadToState(event);
    }
  }

  /// 处理加载数据集事件
  Stream<CollectionState> _mapCollectionLoadToState(
      CollectionLoad event) async* {
    try {
      CancelToken cancelToken = CancelToken();
      yield CollectionLoading(cancelToken: cancelToken);
      final List<T> collection = await collectionRepository.request(
        params: event.params,
        cancelToken: cancelToken,
      );
      if (collection.length == 0)
        yield CollectionEmpty();
      else
        yield CollectionLoaded<T>(collection: collection, params: event.params);
    } catch (e) {
      yield CollectionError(message: ExceptionHandle.handleException(e).msg);
    }
  }
}
