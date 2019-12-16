import 'package:bloc/bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
import 'package:pollution_source/module/common/page/page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  @override
  PageState get initialState => PageLoaded(model: null);

  @override
  Stream<PageState> mapEventToState(PageEvent event) async* {
    if (event is PageLoad) {
      yield PageLoaded(model: event.model);
    }
  }
}
