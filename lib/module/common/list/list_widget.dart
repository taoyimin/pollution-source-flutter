import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:pollution_source/util/ui_utils.dart';

import '../common_widget.dart';
import 'list_bloc.dart';
import 'list_event.dart';
import 'list_state.dart';

class ListHeaderWidget extends StatelessWidget {
  final ListBloc listBloc;
  final String title;
  final String subtitle;
  final String background;
  final String image;
  final Color color;
  final Widget popupMenuButton;
  final bool automaticallyImplyLeading;
  final double expandedHeight;
  final VoidCallback onSearchTap;

  ListHeaderWidget({
    this.listBloc,
    this.title = '标题',
    this.subtitle = '副标题',
    this.background = 'assets/images/button_bg_green.png',
    this.image = 'assets/images/order_list_bg_image.png',
    this.color = Colours.primary_color,
    this.automaticallyImplyLeading = true,
    this.expandedHeight = 150,
    this.popupMenuButton,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(title),
      expandedHeight: expandedHeight,
      pinned: true,
      floating: false,
      snap: false,
      elevation: 0,
      backgroundColor: color,
      automaticallyImplyLeading: automaticallyImplyLeading,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                background,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                right: -20,
                bottom: 0,
                child: Image.asset(
                  image,
                  width: 300,
                ),
              ),
              Positioned(
                top: SystemUtils.isWeb ? 40 : 60,
                left: 20,
                bottom: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 110,
                      child: Text(
                        '$subtitle',
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: BlocBuilder<ListBloc, ListState>(
                        bloc: listBloc,
                        builder: (context, state) {
                          String tip = '';
                          if (state is ListLoading)
                            tip = '数据加载中';
                          else if (state is ListLoaded)
                            tip = '共${state.total}条数据';
                          else if (state is ListEmpty)
                            tip = '共0条数据';
                          else if (state is ListError)
                            tip = '数据加载错误';
                          else
                            tip = 'BlocBuilder监听到未知的的状态！state=$state';
                          return Text(
                            '$tip',
                            style: TextStyle(
                              fontSize: 10,
                              color: color,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        onSearchTap != null
            ? IconButton(
                key: ValueKey(Icons.search),
                icon: Icon(Icons.search),
                onPressed: onSearchTap,
              )
            : Gaps.empty,
        // 隐藏的菜单
        popupMenuButton != null ? popupMenuButton : Gaps.empty,
      ],
    );
  }
}

@Deprecated('暂时不使用')
typedef ListBuilder = Widget Function(List list);

@Deprecated('暂时不使用')
typedef ParamBuilder = Map<String, dynamic> Function();

@Deprecated('暂时不使用')
class ListBodyWidget extends StatefulWidget {
  final ListBloc listBloc;
  final ListBuilder listBuilder;
  final ParamBuilder paramBuilder;
  final EasyRefreshController refreshController;

  ListBodyWidget(
      {this.listBloc, this.listBuilder, this.paramBuilder, this.refreshController})
      : assert(listBloc != null);

  @override
  ListBodyState createState() => ListBodyState();
}

@Deprecated('暂时不使用')
class ListBodyState extends State<ListBodyWidget> {
  final int _pageSize = Constant.defaultPageSize;
  int _currentPage = Constant.defaultCurrentPage;
  Completer<void> _refreshCompleter;

  Map _buildParam() {
    return widget.paramBuilder()
      ..addAll({
        'currentPage': _currentPage,
        'pageSize': _pageSize,
        'start': (_currentPage - 1) * _pageSize,
        'length': _pageSize,
      });
  }

  @override
  void initState() {
    super.initState();
    // 首次加载
    widget.listBloc.add(ListLoad(isRefresh: true, params: _buildParam()));
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      controller: widget.refreshController,
      header: UIUtils.getRefreshClassicalHeader(),
      footer: UIUtils.getLoadClassicalFooter(),
      slivers: <Widget>[
        BlocConsumer<ListBloc, ListState>(
          bloc: widget.listBloc,
          listener: (context, state) {
            if (state is ListLoading) return;
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          },
          buildWhen: (previous, current) {
            if (current is ListLoading)
              return false;
            else
              return true;
          },
          builder: (context, state) {
            if (state is ListInitial || state is ListLoading) {
              return LoadingSliver();
            } else if (state is ListEmpty) {
              return EmptySliver();
            } else if (state is ListError) {
              return ErrorSliver(
                errorMessage: state.message,
                onReloadTap: () => widget.refreshController.callRefresh(),
              );
            } else if (state is ListLoaded) {
              if (!state.hasNextPage) {
                widget.refreshController
                    .finishLoad(noMore: !state.hasNextPage, success: true);
              }
              return widget.listBuilder(state.list);
            } else {
              return ErrorSliver(
                errorMessage: 'BlocBuilder监听到未知的的状态！state=$state',
                onReloadTap: () => widget.refreshController.callRefresh(),
              );
            }
          },
        ),
      ],
      onRefresh: () async {
        _currentPage = Constant.defaultCurrentPage;
        widget.refreshController.resetLoadState();
        widget.listBloc.add(ListLoad(isRefresh: true, params: _buildParam()));
        return _refreshCompleter.future;
      },
      onLoad: () async {
        final currentState = widget.listBloc.state;
        if (currentState is ListLoaded)
          _currentPage = currentState.currentPage + 1;
        else
          _currentPage = Constant.defaultCurrentPage;
        widget.listBloc.add(ListLoad(params: _buildParam()));
        return _refreshCompleter.future;
      },
    );
  }
}
