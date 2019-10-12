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

  //在线状态 online:在线 空:全部
  final String state;

  //企业类型 EnterType1:废气 EnterType2:废水 EnterType1,EnterType2 水气企业
  final String enterType;

  //0:非重点源 1:重点源
  final String attentionLevel;

  EnterListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
    this.state = '',
    this.attentionLevel = '',
    this.enterType = '',
  }) : super([
          isRefresh,
          enterName,
          areaCode,
        ]);

  @override
  String toString() => 'EnterListLoad';
}
