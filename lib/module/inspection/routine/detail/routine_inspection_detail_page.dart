import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:pollution_source/module/common/common_widget.dart';
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
  final String _headerBackground = 'assets/images/button_bg_lightblue.png';
  DetailBloc _detailBloc;
  TabController _tabController;

  // 初始化
  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    _detailBloc.add(DetailLoad(detailId: widget.monitorId));
  }

  @override
  void dispose() {
    // _tabController是在请求完成之后初始化的，所以页面销毁时可能为null
    _tabController?.dispose();
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
//            ListHeaderWidget(
//              title: '常规巡检详情',
//              subtitle: '展示常规巡检列表列表，点击列表项查看该常规巡检的列表',
//              subtitle2: '共100条数据',
//              expandedHeight: 170,
//              background: 'assets/images/button_bg_green.png',
//              image: 'assets/images/report_list_bg_image.png',
//              color: Color(0xFF29D0BF),
//              showSearch: false,
//              bottom: PreferredSize(
//                child: Card(
//                    color: Colors.transparent,
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
//                              indicatorColor: Colors.white,
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
            BlocListener<DetailBloc, DetailState>(
              listener: (context, state) {
                if (state is DetailLoaded)
                  _tabController =
                      TabController(length: state.detail.length, vsync: this);
              },
              child: SliverAppBar(
                title: Text('常规巡检详情'),
                expandedHeight: 170.0,
                flexibleSpace: BlocBuilder<DetailBloc, DetailState>(
                  builder: (context, state) {
                    if (state is DetailLoaded) {
                      // tabView切换时，列表header同时渐变切换
                      return AnimatedBuilder(
                        animation: _tabController.animation,
                        builder: (BuildContext context, snapshot) {
                          return FlexibleSpaceBar(
                            background: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    _headerBackground,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Opacity(
                                opacity:
                                    getOpacity(_tabController.animation.value),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      right: 16,
                                      bottom: 45,
                                      child: Image.asset(
                                        [
                                          'assets/images/routine_inspection_detail_header_image1.png',
                                          'assets/images/routine_inspection_detail_header_image2.png',
                                          'assets/images/routine_inspection_detail_header_image3.png',
                                        ][_tabController.animation.value
                                                .round() %
                                            3],
                                        width: 230,
                                      ),
                                    ),
                                    Positioned(
                                      top: 80,
                                      left: 20,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 80,
                                            child: Text(
                                              () {
                                                String type = state
                                                    .detail[_tabController
                                                        .animation.value
                                                        .round()]
                                                    .itemInspectType;
                                                switch (type) {
                                                  case '1':
                                                  case '5':
                                                    return '选中要处理的任务点击处理按钮进行批量处理';
                                                  case '2':
                                                  case '3':
                                                  case '4':
                                                    return '点击列表中要处理的任务进入该任务的上报界面';
                                                  default:
                                                    return '未知任务类型！itemInspectType=$type';
                                                }
                                              }(),
                                              style:const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Gaps.vGap10,
                                          Container(
                                            padding:const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            decoration:const BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: Text(
                                              '共${state.detail[_tabController.animation.value.round()].taskCount}条数据',
                                              style:const TextStyle(
                                                fontSize: 10,
                                                color: Colors.lightBlue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                _headerBackground,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                floating: false,
                pinned: true,
                bottom: PreferredSize(
                  child: Card(
                      color: Colors.transparent,
                      elevation: 0.0,
                      margin: const EdgeInsets.all(0.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      ),
                      child: BlocBuilder<DetailBloc, DetailState>(
                        builder: (context, state) {
                          if (state is DetailLoaded) {
                            return TabBar(
                              isScrollable: true,
                              indicatorColor: Colors.white,
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
                      )),
                  preferredSize:const Size(double.infinity, 46.0),
                ),
              ),
            ),
          ];
        },
        body: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return LoadingWidget();
            } else if (state is DetailError) {
              return ErrorMessageWidget(errorMessage: state.message);
            } else if (state is DetailLoaded) {
              if (state.detail.length == 0) {
                return EmptyWidget(message: '没有任务需要处理');
              } else {
                return _buildPageLoadedDetail(state.detail);
              }
            } else {
              return ErrorMessageWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
            }
          },
        ),
      ),
    );
  }

  /// 根据_tabController的滑动获取列表header透明度
  ///
  /// 将0→1，1→2，2→3的变化趋势映射成1→0→1，1→0→1，1→0→1的变化趋势
  double getOpacity(double value) {
    double temp =
        _tabController.animation.value - _tabController.animation.value.floor();
    if (temp < 0.5)
      return 2 * (0.5 - temp);
    else if (temp > 0.5)
      return 2 * (temp - 0.5);
    else
      return 0;
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
                case '5':
                  // 辅助/监测设备巡检上报列表
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<UploadBloc>(
                        create: (BuildContext context) => UploadBloc(
                            uploadRepository:
                                DeviceInspectionUploadRepository()),
                      ),
                      BlocProvider<PageBloc>(
                        create: (BuildContext context) => PageBloc(),
                      ),
                      BlocProvider<ListBloc>(
                        create: (BuildContext context) => ListBloc(
                            listRepository:
                                RoutineInspectionUploadListRepository()),
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
