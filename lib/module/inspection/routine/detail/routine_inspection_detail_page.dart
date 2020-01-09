import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_repository.dart';
import 'package:pollution_source/module/inspection/inspect/upload/device_inspection_upload_list_page.dart';
import 'package:pollution_source/module/inspection/inspect/upload/device_inspection_upload_list_repository.dart';
import 'package:pollution_source/module/inspection/routine/detail/routine_inspection_detail_model.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/widget/custom_header.dart';

/// 常规巡检详情页
class RoutineInspectionDetailPage extends StatefulWidget {
  final String monitorId;

  RoutineInspectionDetailPage({@required this.monitorId})
      : assert(monitorId != null);

  @override
  _RoutineInspectionDetailPageState createState() =>
      _RoutineInspectionDetailPageState();
}

class _RoutineInspectionDetailPageState
    extends State<RoutineInspectionDetailPage>
    with SingleTickerProviderStateMixin {
  DetailBloc _detailBloc;
  ScrollController _scrollController;
  TabController _tabController;

  // 初始化
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    _detailBloc.add(DetailLoad(detailId: widget.monitorId));
  }

  @override
  void dispose() {
    // _tabController是在请求完成之后初始化的，所以页面销毁时可能为null
    _tabController?.dispose();
    _scrollController.dispose();
    //取消正在进行的请求
    final currentState = _detailBloc?.state;
    if (currentState is DetailLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: extended.NestedScrollView(
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + kToolbarHeight;
        },
        innerScrollPositionKeyBuilder: () {
          return Key('Tab${_tabController.index}');
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            ListHeaderWidget(
              title: '常规巡检列表',
              subtitle: '展示常规巡检列表列表，点击列表项查看该常规巡检的列表',
              subtitle2: '共100条数据',
              expandedHeight: 170,
              background: 'assets/images/button_bg_green.png',
              image: 'assets/images/report_list_bg_image.png',
              color: Color(0xFF29D0BF),
              showSearch: false,
              bottom: PreferredSize(
                child: Card(
                    color: Colors.transparent,
                    elevation: 0.0,
                    margin: EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    ),
                    child: BlocListener<DetailBloc, DetailState>(
                      listener: (context, state) {
                        if (state is DetailLoaded)
                          _tabController = TabController(
                              length: state.detail.length, vsync: this);
                      },
                      child: BlocBuilder<DetailBloc, DetailState>(
                        builder: (context, state) {
                          if (state is DetailLoaded) {
                            return TabBar(
                              indicatorColor: Colors.white,
                              isScrollable: true,
                              controller: _tabController,
                              tabs: state.detail
                                  .map<Widget>((routineInspectionDetail) {
                                return Tab(
                                    text:
                                        '${routineInspectionDetail.itemInspectTypeName}');
                              }).toList(),
                            );
                          } else {
                            return Gaps.empty;
                          }
                        },
                      ),
                    )),
                preferredSize: Size(double.infinity, 46.0),
              ),
            ),
//            SliverAppBar(
//              title: Text("常规巡检列表"),
//              expandedHeight: 190.0,
//              flexibleSpace: SingleChildScrollView(
//                physics: NeverScrollableScrollPhysics(),
//                child: Container(),
//              ),
//              floating: false,
//              pinned: true,
//              bottom: PreferredSize(
//                child: Card(
//                    color: Theme.of(context).primaryColor,
//                    elevation: 0.0,
//                    margin: EdgeInsets.all(0.0),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
//                    ),
//                    child: BlocListener<DetailBloc, DetailState>(
//                      listener: (context, state) {
//                        if (state is DetailLoaded)
//                          _tabController = TabController(
//                              length: state.detail.length, vsync: this);
//                      },
//                      child: BlocBuilder<DetailBloc, DetailState>(
//                        builder: (context, state) {
//                          if (state is DetailLoaded) {
//                            return TabBar(
//                              isScrollable: true,
//                              controller: _tabController,
//                              tabs: state.detail
//                                  .map<Widget>((routineInspectionDetail) {
//                                return Tab(
//                                    text:
//                                        '${routineInspectionDetail.itemInspectTypeName}');
//                              }).toList(),
//                            );
//                          } else {
//                            return Gaps.empty;
//                          }
//                        },
//                      ),
//                    )),
//                preferredSize: Size(double.infinity, 46.0),
//              ),
//            ),
          ];
        },
        body: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return Text('加载中');
            } else if (state is DetailError) {
              return Text(state.message);
            } else if (state is DetailLoaded) {
              return _buildPageLoadedDetail(state.detail);
            } else {
              return Text('BlocBuilder监听到未知的的状态');
            }
          },
        ),
      ),
    );
  }

  Widget _buildPageLoadedDetail(
      List<RoutineInspectionDetail> routineInspectionDetailList) {
    return TabBarView(
        controller: _tabController,
        children:
            routineInspectionDetailList.map<Widget>((routineInspectionDetail) {
          return extended.NestedScrollViewInnerScrollPositionKeyWidget(
            Key('Tab${routineInspectionDetailList.indexOf(routineInspectionDetail)}'),
            () {
              switch (routineInspectionDetail.itemInspectType) {
                case '1':
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<UploadBloc>(
                        create: (BuildContext context) =>
                            UploadBloc(uploadRepository: DeviceInspectionUploadRepository()),
                      ),
                      BlocProvider<PageBloc>(
                        create: (BuildContext context) => PageBloc(),
                      ),
                      BlocProvider<ListBloc>(
                        create: (BuildContext context) => ListBloc(listRepository: RoutineInspectionUploadListRepository()),
                      ),
                    ],
                    child: DeviceInspectionUploadListPage(
                      monitorId: widget.monitorId,
                      itemInspectType: routineInspectionDetail.itemInspectType,
                    ),
                  );
                default:
                  return Center(
                    child: Text(
                        '未知的itemInspectType类型，itemInspectType=${routineInspectionDetail.itemInspectType}'),
                  );
              }
            }(),
          );
        }).toList());
  }
}
