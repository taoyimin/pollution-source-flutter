import 'package:equatable/equatable.dart';

abstract class EnterListEvent extends Equatable {
  const EnterListEvent();

  @override
  List<Object> get props => [];
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

  //企业类型 outletType1:雨水企业 outletType2:废水企业 outletType3:废气企业 licence:许可证企业
  final String enterType;

  //0:非重点源 1:重点源
  final String attentionLevel;

  const EnterListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
    this.state = '',
    this.attentionLevel = '',
    this.enterType = '',
  });

  @override
  List<Object> get props => [
    isRefresh,
    enterName,
    areaCode,
    state,
    attentionLevel,
    enterType,
  ];
}
