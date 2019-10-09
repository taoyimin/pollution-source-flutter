import 'package:equatable/equatable.dart';

abstract class EnterListEvent extends Equatable {
  EnterListEvent([List props = const []]) : super(props);
}

class EnterListLoad extends EnterListEvent {
  //是否刷新
  final bool isRefresh;

  //按企业名称搜索
  final String enterName;

  //按区域搜索
  final String areaCode;

  EnterListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
  }) : super([
          isRefresh,
          enterName,
          areaCode,
        ]);

  @override
  String toString() => 'EnterListLoad';
}
