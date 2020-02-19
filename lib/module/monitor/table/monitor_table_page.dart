import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:pollution_source/http/error_handle.dart';
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

  MonitorTablePage({this.monitorId}) : assert(!TextUtil.isEmpty(monitorId));

  @override
  State<StatefulWidget> createState() => _MonitorTableState();
}

class _MonitorTableState extends State<MonitorTablePage> {
  /// 每页数据条数
  final int pageSize = 30;

  /// 每页数据条数
  int currentPage = 0;
  List<dynamic> _dropDownHeaderItem = [
    '实时数据',
    DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0),
    DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59),
  ];
  List<SortCondition> _dataTypeConditions = [];
  SortCondition _selectBrandSortCondition;
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

  DetailBloc _detailBloc;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // 默认选中实时数据
    _dataTypeConditions.add(
        SortCondition(name: '实时数据', value: DataType.minute, isSelected: true));
    _dataTypeConditions.add(SortCondition(
        name: '十分钟数据', value: DataType.tenminute, isSelected: false));
    _dataTypeConditions.add(
        SortCondition(name: '小时数据', value: DataType.hour, isSelected: false));
    _dataTypeConditions.add(
        SortCondition(name: '日数据', value: DataType.day, isSelected: false));
    _selectBrandSortCondition = _dataTypeConditions[0];
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    _detailBloc.add(DetailLoad(
      params: MonitorHistoryDataRepository.createParams(
        monitorId: widget.monitorId,
        dataType: _selectBrandSortCondition.value,
      ),
    ));
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
                  GZXDropDownHeaderItem(_dropDownHeaderItem[0], iconSize: 24),
                  GZXDropDownHeaderItem(
                    _dropDownHeaderItem[1] == null
                        ? '开始时间  '
                        : DateUtil.formatDate(
                            _dropDownHeaderItem[1],
                            format: getDateTimeFormat(
                              _selectBrandSortCondition.value,
                            ),
                          ),
                    iconData: Icons.date_range,
                    iconSize: 15,
                  ),
                  GZXDropDownHeaderItem(
                    _dropDownHeaderItem[2] == null
                        ? '结束时间  '
                        : DateUtil.formatDate(
                            _dropDownHeaderItem[2],
                            format: getDateTimeFormat(
                              _selectBrandSortCondition.value,
                            ),
                          ),
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
                      maxDateTime: DateTime.now(),
                      initialDateTime: _dropDownHeaderItem[1] ?? DateTime.now(),
                      locale: DateTimePickerLocale.zh_cn,
                      onClose: () {
                        _dropdownMenuController.hide();
                      },
                      onConfirm: (dateTime, selectedIndex) {
                        _dropDownHeaderItem[1] = dateTime;
                        if (_dropDownHeaderItem[2] != null) {
                          try {
                            _detailBloc.add(DetailLoad(
                              params: MonitorHistoryDataRepository.createParams(
                                monitorId: widget.monitorId,
                                dataType: _selectBrandSortCondition.value,
                                startTime: dateTime,
                                endTime: _dropDownHeaderItem[2],
                              ),
                            ));
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
                        }
                        setState(() {});
                      },
                    );
                  } else if (index == 2) {
                    DatePicker.showDatePicker(
                      context,
                      dateFormat: 'yyyy年-MM月-dd日',
                      maxDateTime: DateTime.now(),
                      initialDateTime: _dropDownHeaderItem[2] ?? DateTime.now(),
                      locale: DateTimePickerLocale.zh_cn,
                      onClose: () {
                        _dropdownMenuController.hide();
                      },
                      onConfirm: (dateTime, selectedIndex) {
                        _dropDownHeaderItem[2] = dateTime;
                        if (_dropDownHeaderItem[1] != null) {
                          try {
                            _detailBloc.add(DetailLoad(
                              params: MonitorHistoryDataRepository.createParams(
                                monitorId: widget.monitorId,
                                dataType: _selectBrandSortCondition.value,
                                startTime: _dropDownHeaderItem[1],
                                endTime: dateTime,
                              ),
                            ));
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
                  _dataTypeConditions,
                  (value) {
                    _selectBrandSortCondition = value;
                    _dropDownHeaderItem[0] = _selectBrandSortCondition.name;
                    _dropdownMenuController.hide();
                    setState(() {});
                    try {
                      _detailBloc.add(DetailLoad(
                        params: MonitorHistoryDataRepository.createParams(
                          monitorId: widget.monitorId,
                          dataType: _selectBrandSortCondition.value,
                          startTime: _dropDownHeaderItem[1],
                          endTime: _dropDownHeaderItem[2],
                        ),
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

  String getDateTimeFormat(DataType dataType) {
    return 'yyyy-MM-dd  ';
//    switch (dataType) {
//      case 'minute':
//        return 'HH:mm:ss  ';
//      case 'tenminute':
//        return 'HH:mm:ss  ';
//      case 'hour':
//        return 'MM-dd HH时  ';
//      case 'day':
//        return 'yyyy-MM-dd  ';
//      default:
//        return 'yyyy-MM-dd  ';
//    }
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
      items, void itemOnTap(SortCondition sortCondition)) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      // item 的个数
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 1.0),
      // 添加分割线
      itemBuilder: (BuildContext context, int index) {
        SortCondition goodsSortCondition = items[index];
        return GestureDetector(
          onTap: () {
            for (var value in items) {
              value.isSelected = false;
            }
            goodsSortCondition.isSelected = true;
            itemOnTap(goodsSortCondition);
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
                    goodsSortCondition.name,
                    style: TextStyle(
                      color: goodsSortCondition.isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                ),
                goodsSortCondition.isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                        size: 16,
                      )
                    : SizedBox(),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SortCondition {
  String name;
  DataType value;
  bool isSelected;

  SortCondition({this.name, this.value, this.isSelected});
}
