import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/module/common/collection/collection_bloc.dart';
import 'package:pollution_source/module/common/collection/collection_event.dart';
import 'package:pollution_source/module/common/collection/collection_state.dart';
import 'package:pollution_source/module/common/collection/collection_widget.dart';
import 'package:pollution_source/module/common/collection/law/mobile_law_model.dart';
import 'package:pollution_source/module/common/collection/law/mobile_law_repository.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_repository.dart';
import 'package:pollution_source/module/common/dict/data_dict_state.dart';
import 'package:pollution_source/module/common/dict/data_dict_widget.dart';
import 'package:pollution_source/module/common/map_info_page.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
import 'package:pollution_source/module/common/page/page_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/order/detail/order_detail_model.dart';
import 'package:pollution_source/module/process/upload/process_upload_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:pollution_source/widget/git_dialog.dart';
import 'package:pollution_source/widget/custom_header.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/widget/left_line_widget.dart';

///报警管理单详情界面
///
///[orderId]是要查询的报警管理单Id，必传
class OrderDetailPage2 extends StatefulWidget {
  final String orderId;

  OrderDetailPage2({@required this.orderId}) : assert(orderId != null);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

/// 报警管理单详情状态管理
class _OrderDetailPageState extends State<OrderDetailPage2>
    with SingleTickerProviderStateMixin {
  /// 报警管理单详情界面Bloc
  DetailBloc _detailBloc;

  /// 上报界面Bloc
  PageBloc _pageBloc;

  /// 处理流程上报业务Bloc
  UploadBloc _uploadBloc;

  /// 报警原因数据字典Bloc
  final DataDictBloc _alarmCauseBloc = DataDictBloc(
      dataDictRepository: DataDictRepository(HttpApi.orderAlarmCause));

  /// 移动执法Bloc
  final CollectionBloc<MobileLaw> _mobileLawBloc =
      CollectionBloc<MobileLaw>(collectionRepository: MobileLawRepository());

  /// 上报界面操作描述输入框
  final TextEditingController _operateDescController = TextEditingController();

  /// 图标渐变动画控制器
  AnimationController _controller;

  /// 图标渐变动画
  Animation _animation;

  /// 上报BottomSheet控制器
  PersistentBottomSheetController _bottomSheetController;

  /// FloatActionButton图标
  IconData _actionIcon = Icons.add;

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    _loadData();
    _pageBloc = BlocProvider.of<PageBloc>(context);
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
    // 初始化fab颜色渐变动画
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = ColorTween(begin: Colors.lightBlue, end: Colors.redAccent)
        .animate(_controller);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // 释放资源
    _operateDescController.dispose();
    _controller.dispose();
    // 取消正在进行的请求
    if (_detailBloc?.state is DetailLoading)
      (_detailBloc?.state as DetailLoading).cancelToken.cancel();
    if (_alarmCauseBloc?.state is DataDictLoading)
      (_alarmCauseBloc?.state as DataDictLoading).cancelToken.cancel();
    if (_mobileLawBloc?.state is CollectionLoading)
      (_mobileLawBloc?.state as CollectionLoading).cancelToken.cancel();
    super.dispose();
  }

  /// 加载数据
  _loadData() {
    _detailBloc.add(DetailLoad(detailId: widget.orderId));
  }

  /// 加载报警原因
  _loadAlarmCause() {
    _alarmCauseBloc.add(DataDictLoad());
  }

  /// 加载移动执法
  _loadMobileLaw() {
    _mobileLawBloc.add(CollectionLoad(
        params: MobileLawRepository.createParams(orderId: widget.orderId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          // 生成header
          BlocBuilder<DetailBloc, DetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              String districtName = '';
              if (state is DetailLoaded) {
                enterName = state.detail.enterName;
                enterAddress = state.detail.enterAddress;
                districtName = state.detail.districtName;
              }
              return DetailHeaderWidget(
                title: '报警管理单详情',
                subTitle1: '$districtName',
                subTitle2: '$enterName',
                subTitle3: '$enterAddress',
                imagePath: 'assets/images/order_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_blue.png',
                color: Colours.background_blue,
              );
            },
          ),
          // 监听上传业务状态
          MultiBlocListener(
            listeners: [
              BlocListener<UploadBloc, UploadState>(
                listener: (context, state) {
                  if (state is Uploading) {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => GifDialog(
                        onCancelTap: () {
                          state.cancelToken.cancel('取消上传');
                        },
                      ),
                    );
                  } else if (state is UploadSuccess) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${state.message}'),
                        action: SnackBarAction(
                            label: '我知道了',
                            textColor: Colours.primary_color,
                            onPressed: () {}),
                      ),
                    );
                    Application.router.pop(context);
                    // 关闭BottomSheet
                    _bottomSheetController?.close();
                    // 刷新详情页面
                    _detailBloc.add(DetailUpdate(detailId: widget.orderId));
                  } else if (state is UploadFail) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text('${state.message}'),
                        action: SnackBarAction(
                            label: '我知道了',
                            textColor: Colours.primary_color,
                            onPressed: () {}),
                      ),
                    );
                    Application.router.pop(context);
                  }
                },
              ),
              BlocListener<DetailBloc, DetailState>(
                listener: (context, state) {
                  if (state is DetailLoaded) {
                    // 详情加载完成后，加载上报界面
                    _pageBloc.add(PageLoad(
                      model: ProcessUpload(
                        orderId: state.detail.orderId,
                        alarmState: state.detail.alarmState,
                        alarmCauseList: state.detail.alarmCauseList,
                      ),
                    ));
                    if(state.detail.deal == 'T'){
                      // 加载报警原因数据字典
                      _loadAlarmCause();
                    }
                    if(state.detail.audit == 'T'){
                      // 加载报警原因数据字典
                      _loadAlarmCause();
                      // 加载移动执法
                      _loadMobileLaw();
                    }
                  }
                },
              ),
            ],
            // 生成body
            child: BlocBuilder<DetailBloc, DetailState>(
              builder: (context, state) {
                if (state is DetailLoading) {
                  return LoadingSliver();
                } else if (state is DetailError) {
                  return ErrorSliver(
                    errorMessage: state.message,
                    onReloadTap: () => _loadData(),
                  );
                } else if (state is DetailLoaded) {
                  return _buildPageLoadedDetail(state.detail);
                } else {
                  return ErrorSliver(
                    errorMessage: 'BlocBuilder监听到未知的的状态!state=$state',
                    onReloadTap: () => _loadData(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      // 生成fab
      floatingActionButton: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) {
          if (state is DetailLoading) {
            return Gaps.empty;
          } else if (state is DetailError) {
            return Gaps.empty;
          } else if (state is DetailLoaded) {
            if (state.detail.deal == 'T' || state.detail.audit == 'T')
              return _buildFloatingActionButton(state.detail);
            else
              return Gaps.empty; // 当前用户不能操作督办单
          } else {
            return Gaps.empty;
          }
        },
      ),
    );
  }

  Widget _buildPageLoadedDetail(OrderDetail orderDetail) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          // 基本信息
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '基本信息',
                  imagePath: 'assets/images/icon_enter_baseinfo.png',
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '监控名称：${orderDetail.monitorName ?? ''}',
                      icon: Icons.linked_camera,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '报警时间：${orderDetail.alarmDateStr ?? ''}',
                      icon: Icons.date_range,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '工单状态：${orderDetail.alarmStateStr ?? ''}',
                      icon: Icons.assignment_late,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '报警类型：${orderDetail.alarmTypeStr ?? ''}',
                      icon: Icons.alarm,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Offstage(
                  offstage: TextUtil.isEmpty(orderDetail.alarmCauseStr),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconBaseInfoWidget(
                            content: '报警原因：${orderDetail.alarmCauseStr ?? ''}',
                            icon: Icons.help,
                          ),
                        ],
                      ),
                      Gaps.vGap10,
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '报警描述：${orderDetail.alarmDesc ?? ''}',
                      icon: Icons.receipt,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 处理流程
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '处理流程',
                  imagePath: 'assets/images/icon_order_process.png',
                ),
                Gaps.vGap10,
                orderDetail.processes.length == 0
                    ? const Text(
                        '没有相关流程信息',
                        style: TextStyle(fontSize: 13),
                      )
                    : ListView.builder(
                        itemCount: orderDetail.processes.length,
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    // 圆和线
                                    height: 42,
                                    child: LeftLineWidget(
                                        index != 0,
                                        index !=
                                            orderDetail.processes.length - 1,
                                        index ==
                                            orderDetail.processes.length - 1),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            orderDetail.processes[index]
                                                .operateTypeStr,
                                            style:
                                                const TextStyle(fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            orderDetail.processes[index]
                                                .operateTimeStr,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colours.secondary_text),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 2,
                                      color: index ==
                                              orderDetail.processes.length - 1
                                          ? Colors.transparent
                                          : Colours.divider_color,
                                    ),
                                  ),
                                ),
                                margin: const EdgeInsets.only(left: 7),
                                padding:
                                    const EdgeInsets.fromLTRB(23, 0, 16, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return MapInfoPage(
                                            title: '处理流程详情',
                                            mapInfo: orderDetail
                                                .processes[index]
                                                .getMapInfo(),
                                          );
                                        }));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "反馈人：${orderDetail.processes[index].operatePerson}",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "报警原因：${orderDetail.processes[index].alarmCauseStr}",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          Offstage(
                                            offstage: TextUtil.isEmpty(
                                                orderDetail.processes[index]
                                                    .operateResult),
                                            child: Text(
                                              "处理结果：${orderDetail.processes[index].operateResult}",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Text(
                                            "核实情况：${orderDetail.processes[index].operateDesc}",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gaps.vGap3,
                                    Offstage(
                                      offstage: orderDetail.processes[index]
                                                  .mobileLawList ==
                                              null ||
                                          orderDetail.processes[index]
                                                  .mobileLawList.length ==
                                              0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Gaps.vGap6,
                                          Text(
                                            '已关联${orderDetail.processes[index].mobileLawList.length}条现场检查情况：',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          Gaps.vGap3,
                                          ListView.separated(
                                            itemCount: orderDetail
                                                .processes[index]
                                                .mobileLawList
                                                .length,
                                            shrinkWrap: true,
                                            primary: false,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 0,
                                            ),
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return Gaps.vGap6;
                                            },
                                            itemBuilder: (BuildContext context,
                                                int listIndex) {
                                              final MobileLaw mobileLaw =
                                                  orderDetail.processes[index]
                                                      .mobileLawList[listIndex];
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MapInfoPage(
                                                          title: '现场检查情况详情',
                                                          mapInfo: mobileLaw
                                                              .getMapInfo(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '${mobileLaw.lawId}',
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      '开始时间：${mobileLaw.startTimeStr}',
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      '结束时间：${mobileLaw.endTimeStr}',
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          Gaps.vGap10,
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: () {
                                        return orderDetail
                                            .processes[index].attachments
                                            .map((attachment) {
                                          return AttachmentWidget(
                                            attachment: attachment,
                                            onTap: () {},
                                          );
                                        }).toList();
                                      }(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ],
            ),
          ),
          // 快速链接
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageTitleWidget(
                  title: '快速链接',
                  imagePath: 'assets/images/icon_fast_link.png',
                ),
                Gaps.vGap10,
                Container(
                  height: 158,
                  child: Row(
                    children: <Widget>[
                      InkWellButton8(
                        meta: Meta(
                          title: '历史数据',
                          content: '查看报警单报警当天的历史数据',
                          backgroundPath: 'assets/images/button_bg_green.png',
                          imagePath:
                              'assets/images/image_enter_statistics1.png',
                          router:
                              '${Routes.monitorHistoryData}?monitorId=${orderDetail.monitorId}&startTime=${orderDetail.alarmDateStr} 00:00:00&endTime=${orderDetail.alarmDateStr} 23:59:59',
                        ),
                      ),
                      Gaps.hGap10,
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            InkWellButton7(
                              meta: Meta(
                                title: '企业信息',
                                content: '查看报警单所属的企业信息',
                                backgroundPath:
                                    'assets/images/button_bg_lightblue.png',
                                imagePath:
                                    'assets/images/image_enter_statistics3.png',
                                router:
                                    '${Routes.enterDetail}/${orderDetail.enterId}',
                              ),
                            ),
                            Gaps.vGap10,
                            InkWellButton7(
                              meta: Meta(
                                title: '监控点信息',
                                content: '查看报警单对应的监控点信息',
                                backgroundPath:
                                    'assets/images/button_bg_red.png',
                                imagePath:
                                    'assets/images/image_enter_statistics2.png',
                                router:
                                    '${Routes.monitorDetail}/${orderDetail.monitorId}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(OrderDetail orderDetail) {
    return Builder(builder: (context) {
      return FloatingActionButton(
        child: AnimatedSwitcher(
          transitionBuilder: (child, anim) {
            return ScaleTransition(child: child, scale: anim);
          },
          duration: Duration(milliseconds: 300),
          child: Icon(
            _actionIcon,
            key: ValueKey(_actionIcon),
            color: Colors.white,
          ),
        ),
        backgroundColor: _animation.value,
        onPressed: () {
          if (_bottomSheetController != null) {
            // 已经处于打开状态
            _bottomSheetController.close();
            return;
          }
          // fab由蓝变红
          _controller.forward();
          setState(() {
            _actionIcon = Icons.close;
          });
          // 打开BottomSheet
          _bottomSheetController = showBottomSheet(
            context: context,
            elevation: 20,
            backgroundColor: Colors.white,
            builder: (BuildContext context) {
              // 生成流程上报界面
              return BlocBuilder<PageBloc, PageState>(
                bloc: _pageBloc,
                builder: (context, state) {
                  if (state is PageLoaded) {
                    return _buildBottomSheet(state.model, orderDetail);
                  } else {
                    return MessageWidget(
                        message: 'BlocBuilder监听到未知的的状态！state=$state');
                  }
                },
              );
            },
          );
          // 监听BottomSheet关闭
          _bottomSheetController.closed.then((value) {
            // fab由红变蓝
            _controller.reverse();
            setState(() {
              _bottomSheetController = null;
              _actionIcon = Icons.add;
            });
          });
        },
      );
    });
  }

  Widget _buildBottomSheet(
      ProcessUpload processUpload, OrderDetail orderDetail) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ImageTitleWidget(
              title: '处理督办单',
              imagePath: 'assets/images/icon_order_process.png',
            ),
            Gaps.vGap16,
            BlocBuilder<DataDictBloc, DataDictState>(
              bloc: _alarmCauseBloc,
              builder: (context, state) {
                if (state is DataDictLoading) {
                  return LoadingWidget();
                } else if (state is DataDictError) {
                  return RowErrorWidget(
                    tipMessage: '报警原因加载失败，请重试！',
                    errorMessage: state.message,
                    onReloadTap: () => _loadAlarmCause(),
                  );
                } else if (state is DataDictLoaded) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context, //BuildCont
                        builder: (BuildContext context) {
                          return DataDictDialog(
                            title: '报警原因',
                            imagePath: 'assets/images/icon_alarm_error.png',
                            dataDictList: state.dataDictList,
                            checkList: processUpload.alarmCauseList,
                            confirmCallBack: (dataDictList) {
                              _pageBloc.add(PageLoad(
                                  model: processUpload.copyWith(
                                      alarmCauseList: dataDictList)));
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 46,
                      color: Color(0xFFDFDFDF),
                      child: Row(
                        children: <Widget>[
                          Gaps.hGap16,
                          Image.asset(
                            'assets/images/icon_alarm_error.png',
                            height: 20,
                            width: 20,
                          ),
                          Flexible(
                            child: TextField(
                              controller: TextEditingController(
                                  text: processUpload.alarmCauseList
                                      .map((dataDict) {
                                return dataDict.name;
                              }).join(' ')),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                              enabled: false,
                              decoration: const InputDecoration(
                                fillColor: Color(0xFFDFDFDF),
                                filled: true,
                                hintText: "请选择报警原因",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colours.secondary_text,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return RowErrorWidget(
                    errorMessage: 'BlocBuilder监听到未知的的状态!state=$state',
                    onReloadTap: () => _loadAlarmCause(),
                  );
                }
              },
            ),
            Gaps.vGap10,
            Offstage(
              offstage: orderDetail.audit != 'T',
              child: Column(
                children: <Widget>[
                  BlocBuilder<CollectionBloc, CollectionState>(
                    bloc: _mobileLawBloc,
                    builder: (context, state) {
                      if (state is CollectionLoading) {
                        return LoadingWidget();
                      } else if (state is CollectionError) {
                        return RowErrorWidget(
                          tipMessage: '现场检查情况加载失败，请重试！',
                          errorMessage: state.message,
                          onReloadTap: () => _loadMobileLaw(),
                        );
                      } else if (state is CollectionEmpty) {
                        return Gaps.empty;
                      } else if (state is CollectionLoaded) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context, //BuildCont
                              builder: (BuildContext context) {
                                return CollectionDialog<MobileLaw>(
                                  title: '现场检查情况',
                                  imagePath:
                                      'assets/images/icon_mobile_law.png',
                                  collection: state.collection,
                                  checkList: processUpload.mobileLawList,
                                  confirmCallBack: (mobileLawList) {
                                    _pageBloc.add(PageLoad(
                                        model: processUpload.copyWith(
                                            mobileLawList: mobileLawList)));
                                  },
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 46,
                            color: Color(0xFFDFDFDF),
                            child: Row(
                              children: <Widget>[
                                Gaps.hGap16,
                                Image.asset(
                                  'assets/images/icon_mobile_law.png',
                                  height: 20,
                                  width: 20,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: processUpload
                                                    .mobileLawList.length ==
                                                0
                                            ? ''
                                            : '已关联${processUpload.mobileLawList.length}条现场检查情况'),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    enabled: false,
                                    decoration: const InputDecoration(
                                      fillColor: Color(0xFFDFDFDF),
                                      filled: true,
                                      hintText: "选择关联现场检查情况",
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colours.secondary_text,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return RowErrorWidget(
                          errorMessage: 'BlocBuilder监听到未知的的状态!state=$state',
                          onReloadTap: () => _loadMobileLaw(),
                        );
                      }
                    },
                  ),
                  BlocBuilder<CollectionBloc, CollectionState>(
                    bloc: _mobileLawBloc,
                    builder: (context, state) {
                      if (state is CollectionEmpty) {
                        return Gaps.empty;
                      } else {
                        return Gaps.vGap10;
                      }
                    },
                  ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(color: Color(0xFFDFDFDF)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 12),
                    child: Image.asset(
                      'assets/images/icon_alarm_manage.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      controller: _operateDescController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xFFDFDFDF),
                        filled: true,
                        hintText: "请输入核实情况",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colours.secondary_text,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gaps.vGap5,
            //没有选取附件则隐藏GridView
            Offstage(
              offstage: processUpload.attachments == null ||
                  processUpload.attachments.length == 0,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                children: List.generate(
                  processUpload.attachments == null
                      ? 0
                      : processUpload.attachments.length,
                  (index) {
                    Asset asset = processUpload.attachments[index];
                    return AssetThumb(
                      asset: asset,
                      width: 300,
                      height: 300,
                    );
                  },
                ),
              ),
            ),
            Gaps.vGap3,
            Offstage(
              offstage: orderDetail.audit != 'T',
              child: Row(
                children: <Widget>[
                  Container(
                    height: 46,
                    width: 46,
                    child: RaisedButton(
                      padding: const EdgeInsets.all(0),
                      color: Colors.white,
                      onPressed: () async {
                        // 选取图片后重新加载界面
                        _pageBloc.add(PageLoad(
                            model: processUpload.copyWith(
                                attachments: await SystemUtils.loadAssets(
                                    processUpload.attachments))));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.image,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  Gaps.hGap10,
                  ClipButton(
                    text: '不通过',
                    icon: Icons.clear,
                    color: Colors.redAccent,
                    onTap: () {
                      // 发送上传事件
                      _uploadBloc.add(
                        Upload(
                          data: processUpload.copyWith(
                            operateType: '1',
                            operateDesc: _operateDescController.text,
                          ),
                        ),
                      );
                    },
                  ),
                  Gaps.hGap10,
                  ClipButton(
                    text: '通过',
                    icon: Icons.check,
                    color: Colors.lightBlue,
                    onTap: () {
                      // 发送上传事件
                      _uploadBloc.add(
                        Upload(
                          data: processUpload.copyWith(
                            operateType: '0',
                            operateDesc: _operateDescController.text,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Gaps.vGap3,
            Offstage(
              offstage: orderDetail.deal != 'T',
              child: Row(
                children: <Widget>[
                  ClipButton(
                    text: '选择图片',
                    icon: Icons.image,
                    color: Colors.green,
                    onTap: () async {
                      // 选取图片后重新加载界面
                      _pageBloc.add(PageLoad(
                          model: processUpload.copyWith(
                              attachments: await SystemUtils.loadAssets(
                                  processUpload.attachments))));
                    },
                  ),
                  Gaps.hGap20,
                  ClipButton(
                    text: '处理',
                    icon: Icons.file_upload,
                    color: Colors.lightBlue,
                    onTap: () {
                      // 发送上传事件
                      _uploadBloc.add(
                        Upload(
                          data: processUpload.copyWith(
                            operateType: '-1',
                            operateDesc: _operateDescController.text,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
