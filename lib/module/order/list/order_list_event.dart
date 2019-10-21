import 'package:equatable/equatable.dart';

abstract class OrderListEvent extends Equatable {
  const OrderListEvent();

  @override
  List<Object> get props => [];
}

class OrderListLoad extends OrderListEvent {
  //是否刷新
  final bool isRefresh;

  //按企业名称搜索
  final String enterName;

  //按区域搜索
  final String areaCode;

  //督办单状态
  final String state;

  const OrderListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
    this.state = '',
  });

  @override
  List<Object> get props => [
        isRefresh,
        enterName,
        areaCode,
        state,
      ];
}
