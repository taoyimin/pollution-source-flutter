import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/page/page_event.dart';
import 'package:pollution_source/module/common/page/page_state.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/order/detail/order_detail_model.dart';
import 'package:pollution_source/module/process/upload/process_upload_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
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

///报警管理单详情状态管理
///
/// [_detailBloc]处理报警管理单详情界面业务
/// [_pageBloc]处理流程上报界面业务
/// [_uploadBloc]处理流程上报业务
/// [_operatePersonController]控制上报界面操作人输入框
/// [_operateDescController]控制上报界面操作描述输入框
class _OrderDetailPageState extends State<OrderDetailPage2>
    with SingleTickerProviderStateMixin {
  DetailBloc _detailBloc;
  PageBloc _pageBloc;
  UploadBloc _uploadBloc;
  TextEditingController _operatePersonController;
  TextEditingController _operateDescController;
  AnimationController controller;
  Animation animation;
  PersistentBottomSheetController _bottomSheetController;
  IconData _actionIcon = Icons.add;

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    //首次加载
    _detailBloc.add(DetailLoad(detailId: widget.orderId));
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
    _pageBloc = PageBloc();
    //首次加载
    _pageBloc.add(PageLoad(model: ProcessUpload(orderId: widget.orderId)));
    //初始化编辑框控制器
    _operatePersonController = TextEditingController();
    _operateDescController = TextEditingController();
    //初始化fab颜色渐变动画
    controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.lightBlue, end: Colors.redAccent)
        .animate(controller);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    //释放资源
    _operatePersonController.dispose();
    _operateDescController.dispose();
    controller.dispose();
    //取消正在进行的请求
    final currentState = _detailBloc?.state;
    if (currentState is DetailLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          //生成header
          BlocBuilder<DetailBloc, DetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              if (state is DetailLoaded) {
                enterName = state.detail.enterName;
                enterAddress = state.detail.enterAddress;
              }
              return DetailHeaderWidget(
                title: '报警管理单详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/order_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_blue.png',
                color: Colours.background_blue,
              );
            },
          ),
          //监听上传业务状态
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
                //关闭BottomSheet
                _bottomSheetController?.close();
                //刷新详情页面
                _detailBloc.add(DetailUpdate(detailId: widget.orderId));
                //刷新上报界面
                _pageBloc.add(
                    PageLoad(model: ProcessUpload(orderId: widget.orderId)));
                //只清空操作描述输入框，不清空操作人输入框
                _operateDescController.text = '';
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
            //生成body
            child: BlocBuilder<DetailBloc, DetailState>(
              builder: (context, state) {
                if (state is DetailLoading) {
                  return LoadingSliver();
                } else if (state is DetailError) {
                  return ErrorSliver(errorMessage: state.message);
                } else if (state is DetailLoaded) {
                  return _buildPageLoadedDetail(state.detail);
                } else {
                  return ErrorSliver(
                      errorMessage: 'BlocBuilder监听到未知的的状态!state=$state');
                }
              },
            ),
          ),
        ],
      ),
      //生成fab
      floatingActionButton: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) {
          if (state is DetailLoading) {
            return Gaps.empty;
          } else if (state is DetailError) {
            return Gaps.empty;
          } else if (state is DetailLoaded) {
            if (getOperateType(state.detail.orderState) == -1)
              return Gaps.empty; // 当前用户不能操作督办单
            else
              return _buildFloatingActionButton(state.detail);
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
          //基本信息
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
                      flex: 1,
                    ),
                    Gaps.hGap20,
                    IconBaseInfoWidget(
                      content: '区域：${orderDetail.districtName ?? ''}',
                      icon: Icons.location_on,
                      flex: 1,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '报警时间：${orderDetail.alarmDateStr ?? ''}',
                      icon: Icons.date_range,
                      flex: 1,
                    ),
                    Gaps.hGap20,
                    IconBaseInfoWidget(
                      content: '状态：${orderDetail.orderStateStr ?? ''}',
                      icon: Icons.assignment_late,
                      flex: 1,
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
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '报警描述：${orderDetail.alarmRemark ?? ''}',
                      icon: Icons.receipt,
                    ),
                  ],
                ),
              ],
            ),
          ),
          //处理流程
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
                                    Text(
                                      "反馈人：${orderDetail.processes[index].operatePerson}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      "核实情况：${orderDetail.processes[index].operateDesc}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Gaps.vGap3,
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
          //快速链接
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
                Row(
                  children: <Widget>[
                    InkWellButton7(
                      meta: Meta(
                          title: '企业信息',
                          content: '查看报警单所属的企业信息',
                          backgroundPath:
                              'assets/images/button_bg_lightblue.png',
                          imagePath:
                              'assets/images/image_enter_statistics1.png'),
                      onTap: () {
                        Application.router.navigateTo(context,
                            '${Routes.enterDetail}/${orderDetail.enterId}');
                      },
                    ),
                    Gaps.hGap10,
                    InkWellButton7(
                      meta: Meta(
                          title: '在线数据',
                          content: '查看报警管理单对应的在线数据',
                          backgroundPath: 'assets/images/button_bg_yellow.png',
                          imagePath:
                              'assets/images/image_enter_statistics2.png'),
                      onTap: () {
                        Application.router.navigateTo(context,
                            '${Routes.monitorDetail}/${orderDetail.monitorId}');
                      },
                    ),
                  ],
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
        backgroundColor: animation.value,
        onPressed: () {
          if (_bottomSheetController != null) {
            //已经处于打开状态
            _bottomSheetController.close();
            return;
          }
          //fab由蓝变红
          controller.forward();
          setState(() {
            _actionIcon = Icons.close;
          });
          //打开BottomSheet
          _bottomSheetController = showBottomSheet(
            context: context,
            elevation: 20,
            backgroundColor: Colors.white,
            builder: (BuildContext context) {
              //生成流程上报界面
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
          //监听BottomSheet关闭
          _bottomSheetController.closed.then((value) {
            //fab由红变蓝
            controller.reverse();
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
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Gaps.vGap20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ImageTitleWidget(
              title: '处理督办单',
              imagePath: 'assets/images/icon_alarm_manage.png',
            ),
          ),
          Gaps.vGap16,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _operatePersonController,
                    decoration: const InputDecoration(
                      fillColor: Color(0xFFDFDFDF),
                      filled: true,
                      hintText: "请输入反馈人",
                      hintStyle: TextStyle(
                        color: Colours.secondary_text,
                      ),
                      prefixIcon: Icon(Icons.person),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gaps.vGap10,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _operateDescController,
                    decoration: const InputDecoration(
                      fillColor: Color(0xFFDFDFDF),
                      filled: true,
                      hintText: "请输入核实情况",
                      hintStyle: TextStyle(
                        color: Colours.secondary_text,
                      ),
                      prefixIcon: Icon(Icons.event_note),
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
                horizontal: 16,
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
          Gaps.vGap5,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                ClipButton(
                  text: '选择图片',
                  icon: Icons.image,
                  color: Colors.green,
                  onTap: () async {
                    //选取图片后重新加载界面
                    _pageBloc.add(PageLoad(
                        model: processUpload.copyWith(
                            attachments: await SystemUtils.loadAssets(
                                processUpload.attachments))));
                  },
                ),
                Gaps.hGap20,
                () {
                  if (getOperateType(orderDetail.orderState) == 1) {
                    return ClipButton(
                      text: '处理',
                      icon: Icons.file_upload,
                      color: Colors.lightBlue,
                      onTap: () {
                        //发送上传事件
                        _uploadBloc.add(
                          Upload(
                            data: processUpload.copyWith(
                              // 退回
                              operateType: '1',
                              operatePerson: _operatePersonController.text,
                              operateDesc: _operateDescController.text,
                            ),
                          ),
                        );
                      },
                    );
                  } else if (getOperateType(orderDetail.orderState) == 4) {
                    return ClipButton(
                      text: '退回',
                      icon: Icons.subdirectory_arrow_left,
                      color: Colors.red,
                      onTap: () {
                        //发送上传事件
                        _uploadBloc.add(
                          Upload(
                            data: processUpload.copyWith(
                              // 退回
                              operateType: '4',
                              operatePerson: _operatePersonController.text,
                              operateDesc: _operateDescController.text,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Gaps.empty;
                  }
                }(),
              ],
            ),
          ),
          Gaps.vGap20,
        ],
      ),
    );
  }

  /// 获取当前用户可以进行的操作
  ///
  /// 返回1表示可以处理 返回4表示可以退回 返回-1表示不可以操作督办单
  int getOperateType(String orderState) {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
        // 环保用户
        if (orderState == '20' || orderState == '40')
          return 1; // 待处理和已退回状态可以处理
        else if (orderState == '50') return 4; // 已办结状态可以退回
        return -1;
      case 1:
      case 2:
        // 企业用户和运维用户
        if (orderState == '20' || orderState == '40') return 1; // 待处理和已退回状态可以处理
        return -1;
      default:
        return -1;
    }
  }
}
