import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_event.dart';
import 'package:pollution_source/module/common/detail/detail_state.dart';
import 'package:pollution_source/module/monitor/table/monitor_table_repository.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/widget/fixed_data_table.dart';

import 'monitor_table_model.dart';

/// 监控点历史数据界面
class MonitorTablePage extends StatefulWidget {
  final String monitorId;
  final String dataType;
  final DateTime startTime;
  final DateTime endTime;

  MonitorTablePage({
    this.monitorId,
    this.dataType,
    this.startTime,
    this.endTime,
  }) : assert(!TextUtil.isEmpty(monitorId));

  @override
  State<StatefulWidget> createState() => _MonitorTableState();
}

class _MonitorTableState extends State<MonitorTablePage> {
  /// 每页数据条数
  final int pageSize = 30;

  /// 当前页数
  int currentPage = 0;

  /// 数据类型菜单
  final List<DataDict> _dataTypeList = [
    DataDict(name: '实时数据', code: 'minute', checked: false),
    DataDict(name: '十分钟数据', code: 'tenminute', checked: false),
    DataDict(name: '小时数据', code: 'hour', checked: true),
    DataDict(name: '日数据', code: 'day', checked: false),
  ];
  final GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _stackKey = GlobalKey();

  String _dataType;
  String _dataTypeStr;
  DateTime _startTime;
  DateTime _endTime;
  DetailBloc _detailBloc;

  @override
  void initState() {
    super.initState();
    initParam();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    _detailBloc.add(DetailLoad(params: getRequestParam()));
  }

  /// 初始化查询参数
  initParam() {
    _dataType = widget.dataType;
    _dataTypeStr = _dataTypeList.singleWhere((DataDict dataDict) {
      return dataDict.code == _dataType;
    }).name;
    DateTime nowDateTime = DateTime.now();
    _startTime = widget.startTime ??
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, 0, 0, 0);
    _endTime = widget.endTime ??
        DateTime(
            nowDateTime.year, nowDateTime.month, nowDateTime.day, 23, 59, 59);
  }

  /// 获取请求参数
  Map<String, dynamic> getRequestParam() {
    return MonitorHistoryDataRepository.createParams(
      monitorId: widget.monitorId,
      dataType: _dataType,
      startTime: _startTime,
      endTime: _endTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('历史在线数据'),
      ),
      body: Stack(
        key: _stackKey,
        children: <Widget>[
          Column(
            children: <Widget>[
              // 下拉菜单头部
              GZXDropDownHeader(
                // 下拉的头部项，目前每一项，只能自定义显示的文字、图标、图标大小修改
                items: [
                  GZXDropDownHeaderItem(_dataTypeStr, iconSize: 24),
                  GZXDropDownHeaderItem(
                    DateUtil.formatDate(_startTime, format: 'yyyy-MM-dd  '),
                    iconData: Icons.date_range,
                    iconSize: 15,
                  ),
                  GZXDropDownHeaderItem(
                    DateUtil.formatDate(_endTime, format: 'yyyy-MM-dd  '),
                    iconData: Icons.date_range,
                    iconSize: 15,
                  ),
                ],
                // GZXDropDownHeader对应第一父级Stack的key
                stackKey: _stackKey,
                // controller用于控制menu的显示或隐藏
                controller: _dropdownMenuController,
                // 当点击头部项的事件，在这里可以进行页面跳转或openEndDrawer
                onItemTap: (index) {
                  if (index == 1) {
                    DatePicker.showDatePicker(
                      context,
                      dateFormat: 'yyyy年-MM月-dd日',
                      initialDateTime: _startTime,
                      maxDateTime: DateTime.now(),
                      locale: DateTimePickerLocale.zh_cn,
                      onClose: () {
                        _dropdownMenuController.hide();
                      },
                      onConfirm: (dateTime, selectedIndex) {
                        _startTime = dateTime;
                        try {
                          currentPage = 0;
                          _detailBloc
                              .add(DetailLoad(params: getRequestParam()));
                        } catch (e) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${ExceptionHandle.handleException(e).msg}'),
                              action: SnackBarAction(
                                  label: '我知道了',
                                  textColor: Colours.primary_color,
                                  onPressed: () {}),
                            ),
                          );
                        }
                        setState(() {});
                      },
                    );
                  } else if (index == 2) {
                    DatePicker.showDatePicker(
                      context,
                      dateFormat: 'yyyy年-MM月-dd日',
                      initialDateTime: _endTime,
                      maxDateTime: DateTime.now(),
                      locale: DateTimePickerLocale.zh_cn,
                      onClose: () {
                        _dropdownMenuController.hide();
                      },
                      onConfirm: (dateTime, selectedIndex) {
                        // 结束时间默认加上23小时59分59秒
                        _endTime = dateTime.add(Duration(
                          hours: 23,
                          minutes: 59,
                          seconds: 59,
                        ));
                        try {
                          currentPage = 0;
                          _detailBloc
                              .add(DetailLoad(params: getRequestParam()));
                        } catch (e) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${ExceptionHandle.handleException(e).msg}'),
                              action: SnackBarAction(
                                  label: '我知道了',
                                  textColor: Colours.primary_color,
                                  onPressed: () {}),
                            ),
                          );
                        }
                        setState(() {});
                      },
                    );
                  }
                },
//                // 头部的高度
                height: 50,
//                // 头部背景颜色
//                color: Colors.red,
//                // 头部边框宽度
//                borderWidth: 1,
//                // 头部边框颜色
//                borderColor: Color(0xFFeeede6),
//                // 分割线高度
//                dividerHeight: 20,
//                // 分割线颜色
//                dividerColor: Color(0xFFeeede6),
//                // 文字样式
//                style: TextStyle(color: Color(0xFF666666), fontSize: 13),
//                // 下拉时文字样式
//                dropDownStyle: TextStyle(
//                  fontSize: 13,
//                  color: Theme.of(context).primaryColor,
//                ),
//                // 图标大小
//                iconSize: 20,
//                // 图标颜色
//                iconColor: Color(0xFFafada7),
//                // 下拉时图标颜色
//                iconDropDownColor: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: BlocBuilder<DetailBloc, DetailState>(
                  builder: (context, state) {
                    if (state is DetailLoading) {
                      return LoadingWidget();
                    } else if (state is DetailError) {
                      return ErrorMessageWidget(errorMessage: state.message);
                    } else if (state is DetailLoaded) {
                      if (state.detail.fixedColCells.length == 0) {
                        return EmptyWidget(message: '没有数据');
                      }
                      return _buildPageLoadedDetail(state.detail);
                    } else {
                      return ErrorMessageWidget(
                          errorMessage: 'BlocBuilder监听到未知的的状态!state=$state');
                    }
                  },
                ),
              ),
              BlocBuilder<DetailBloc, DetailState>(
                builder: (context, state) {
                  if (state is DetailLoaded) {
                    int pages =
                        (state.detail.fixedColCells.length / pageSize).ceil();
                    if (pages > 1) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(pages, (index) {
                            return InkWellButton(
                              onTap: () {
                                setState(() {
                                  currentPage = index;
                                });
                              },
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: index == currentPage
                                        ? Colours.primary_color.withOpacity(0.3)
                                        : Colors.white,
                                    border: Border.all(
                                      width: 0.5,
                                      color: Colours.divider_color,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text('${index + 1}'),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      );
                    } else {
                      return Gaps.empty;
                    }
                  } else {
                    return Gaps.empty;
                  }
                },
              ),
            ],
          ),
          // 下拉菜单
          GZXDropDownMenu(
            // controller用于控制menu的显示或隐藏
            controller: _dropdownMenuController,
            // 下拉菜单显示或隐藏动画时长
            animationMilliseconds: 300,
            // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
            menus: [
              GZXDropdownMenuBuilder(
                dropDownHeight: 50 * 4.0,
                dropDownWidget: _buildConditionListWidget(
                  _dataTypeList,
                  (value) {
                    _dataType = value.code;
                    _dataTypeStr = value.name;
                    _dropdownMenuController.hide();
                    setState(() {});
                    try {
                      currentPage = 0;
                      _detailBloc.add(DetailLoad(
                        params: getRequestParam(),
                      ));
                    } catch (e) {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content:
                              Text('${ExceptionHandle.handleException(e).msg}'),
                          action: SnackBarAction(
                              label: '我知道了',
                              textColor: Colours.primary_color,
                              onPressed: () {}),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail(MonitorTable monitorTable) {
    return FixedDataTable(
      fixedCornerCell: MonitorTableCell(value: '    监测时间'),
      rowsCells: monitorTable.rowsCells
          .skip(currentPage * pageSize)
          .take(pageSize)
          .toList(),
      fixedColCells: monitorTable.fixedColCells
          .skip(currentPage * pageSize)
          .take(pageSize)
          .toList(),
      fixedRowCells: monitorTable.fixedRowCells,
      cellBuilder: (data) {
        return Text(
          '${data.value}',
          textAlign: TextAlign.center,
          style: TextStyle(color: data.textColor),
        );
      },
    );
  }

  _buildConditionListWidget(
      List<DataDict> items, void itemOnTap(DataDict dataDict)) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      // item 的个数
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 1.0),
      // 添加分割线
      itemBuilder: (BuildContext context, int index) {
        DataDict dataDict = items[index];
        return GestureDetector(
          onTap: () {
            for (int i = 0; i < items.length; i++) {
              items[i] = items[i].copyWith(checked: false);
            }
            dataDict = dataDict.copyWith(checked: true);
            itemOnTap(dataDict);
          },
          child: Container(
            // color: Colors.blue,
            height: 50,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    dataDict.name,
                    style: TextStyle(
                      color: dataDict.checked
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                ),
                dataDict.checked
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                        size: 16,
                      )
                    : Gaps.empty,
                Gaps.hGap16,
              ],
            ),
          ),
        );
      },
    );
  }
}
