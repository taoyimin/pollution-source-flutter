import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_bloc.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_page.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_bloc.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_page.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/log_utils.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/widget/left_line_widget.dart';

import 'order_detail.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  OrderDetailPage({@required this.orderId}) : assert(orderId != null);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetailBloc _orderDetailBloc;
  TextEditingController _operatePersonController;
  TextEditingController _operateDescController;

  //PersistentBottomSheetController  _bottomSheetController;

  @override
  void initState() {
    super.initState();
    _orderDetailBloc =
        _orderDetailBloc = BlocProvider.of<OrderDetailBloc>(context);
    _orderDetailBloc.add(OrderDetailLoad(orderId: widget.orderId));
    _operatePersonController = TextEditingController();
    _operateDescController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _operatePersonController.dispose();
    _operateDescController.dispose();
  }

  //用来显示SnackBar
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  IconData _actionIcon = Icons.add;

  //List<Asset> images = List<Asset>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          BlocBuilder<OrderDetailBloc, OrderDetailState>(
            builder: (context, state) {
              String enterName = '';
              String enterAddress = '';
              if (state is OrderDetailLoaded) {
                enterName = state.orderDetail.enterName;
                enterAddress = state.orderDetail.enterAddress;
              }
              return DetailHeaderWidget(
                title: '报警管理单详情',
                subTitle1: '$enterName',
                subTitle2: '$enterAddress',
                imagePath: 'assets/images/order_detail_bg_image.svg',
                backgroundPath: 'assets/images/button_bg_blue.png',
              );
            },
          ),
          BlocBuilder<OrderDetailBloc, OrderDetailState>(
            builder: (context, state) {
              if (state is OrderDetailLoading) {
                return PageLoadingWidget();
              } else if (state is OrderDetailEmpty) {
                return PageEmptyWidget();
              } else if (state is OrderDetailError) {
                return PageErrorWidget(errorMessage: state.errorMessage);
              } else if (state is OrderDetailLoaded) {
                return _buildPageLoadedDetail(state.orderDetail);
              } else {
                return PageErrorWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
              }
            },
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<OrderDetailBloc, OrderDetailState>(
        builder: (context, state) {
          if (state is OrderDetailLoading) {
            return Gaps.empty;
          } else if (state is OrderDetailEmpty) {
            return Gaps.empty;
          } else if (state is OrderDetailError) {
            return Gaps.empty;
          } else if (state is OrderDetailLoaded) {
            return _buildFloatingActionButton();
          } else {
            return Gaps.empty;
          }
        },
      ),
      /*floatingActionButton: Builder(builder: (context) {
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
          backgroundColor: Colours.primary_color,
          onPressed: () {
            setState(() {
              _actionIcon = Icons.close;
            });
            var bottomSheetController = showBottomSheet(
              context: context,
              elevation: 20,
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  height: 300.0,
                  child: GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: const EdgeInsets.all(16),
                    children: List.generate(
                        images == null ? 1 : images.length + 1, (index) {
                      if (index == (images == null ? 1 : images.length)) {
                        return InkWell(onTap: loadAssets, child: Image.asset('assets/images/attachment_image_add.png',
                          width: 300,
                          height: 300,
                        ),);
                      } else {
                        Asset asset = images[index];
                        return AssetThumb(
                          asset: asset,
                          width: 300,
                          height: 300,
                        );
                      }
                    }),
                  ),
                );
              },
            );
            bottomSheetController.closed.then((value) {
              setState(() {
                _actionIcon = Icons.add;
              });
            });
          },
        );
      }),*/
      /*floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        color: Colors.green,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: myheight,
        ),
      ),*/
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
                      content: '监控名称：${orderDetail.monitorName}',
                      icon: Icons.linked_camera,
                      flex: 1,
                    ),
                    Gaps.hGap20,
                    IconBaseInfoWidget(
                      content: '区域：${orderDetail.districtName}',
                      icon: Icons.location_on,
                      flex: 1,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '报警时间：${orderDetail.alarmDateStr}',
                      icon: Icons.date_range,
                      flex: 1,
                    ),
                    Gaps.hGap20,
                    IconBaseInfoWidget(
                      content: '状态：${orderDetail.orderStateStr}',
                      icon: Icons.assignment_late,
                      flex: 1,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '报警类型：${orderDetail.alarmTypeStr}',
                      icon: Icons.alarm,
                    ),
                  ],
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    IconBaseInfoWidget(
                      content: '报警描述：${orderDetail.alarmRemark}',
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
                                      "操作人：${orderDetail.processes[index].operatePerson}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      "操作描述：${orderDetail.processes[index].operateDesc}",
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
          //处理上报
          /*Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ImageTitleWidget(
                    title: '处理上报',
                    imagePath: 'assets/images/icon_fast_link.png',
                  ),
                  Gaps.vGap10,
                ],
              ),
            ),*/
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => EnterDetailBloc(),
                                child: EnterDetailPage(
                                  enterId: orderDetail.enterId,
                                ),
                              );
                            },
                          ),
                        );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                builder: (context) => MonitorDetailBloc(),
                                child: MonitorDetailPage(
                                  monitorId: orderDetail.monitorId,
                                ),
                              );
                            },
                          ),
                        );
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

  PersistentBottomSheetController _bottomSheetController;

  Widget _buildFloatingActionButton() {
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
        backgroundColor: Colours.primary_color,
        onPressed: () {
          if (_bottomSheetController != null) {
            //已经处于打开状态
            _bottomSheetController.close();
            //_bottomSheetController = null;
            return;
          }
          setState(() {
            _actionIcon = Icons.close;
          });
          _bottomSheetController = showBottomSheet(
            context: context,
            elevation: 20,
            backgroundColor: Colors.white,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
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
                                    hintText: "请输入操作人",
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
                                    hintText: "请输入操作描述",
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
                        Offstage(
                          offstage: images == null || images.length == 0,
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
                              images == null ? 0 : images.length,
                              (index) {
                                Asset asset = images[index];
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
                                onTap: () {
                                  loadAssets(setState);
                                },
                              ),
                              Gaps.hGap20,
                              ClipButton(
                                text: '提交',
                                icon: Icons.file_upload,
                                color: Colors.lightBlue,
                                onTap: () {
                                  Toast.show('点击了提交按钮');
                                },
                              ),
                            ],
                          ),
                        ),
                        Gaps.vGap20,
                      ],
                    ),
                  );
                },
              );
            },
          );
          _bottomSheetController.closed.then((value) {
            setState(() {
              _bottomSheetController = null;
              _actionIcon = Icons.add;
            });
          });
        },
      );
    });
  }

  //上报时选中的图片附件
  List<Asset> images = List<Asset>();

  Future<void> loadAssets(StateSetter updateState) async {
    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        enableCamera: true,
        maxImages: 10,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "选取图片",
          allViewTitle: "全部图片",
          actionBarColor: '#03A9F4',
          actionBarTitleColor: "#FFFFFF",
          lightStatusBar: false,
          statusBarColor: '#0288D1',
          startInAllView: false,
          useDetailsView: true,
          selectCircleStrokeColor: "#FFFFFF",
          selectionLimitReachedText: "已达到可选图片最大数",
        ),
      );
    } on NoImagesSelectedException {
      Log.i('没有图片被选择,resultList.length=${resultList?.length}');
      return;
    } on Exception catch (e) {
      Toast.show('选择图片错误！错误信息：$e');
    }
    updateState(() {
      images = resultList ?? List<Asset>();
    });
  }
}
