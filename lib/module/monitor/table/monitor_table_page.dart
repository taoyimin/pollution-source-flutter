import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';

import 'monitor_table_model.dart';

class MonitorTablePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MonitorTableState();
}

class _MonitorTableState extends State<MonitorTablePage> {
  List<String> _dropDownHeaderItemStrings = ['小时数据', '开始时间  ', '结束时间  '];
  List<SortCondition> _dataTypeConditions = [];
  SortCondition _selectBrandSortCondition;
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _dataTypeConditions.add(SortCondition(name: '实时数据', isSelected: true));
    _dataTypeConditions.add(SortCondition(name: '十分钟数据', isSelected: false));
    _dataTypeConditions.add(SortCondition(name: '小时数据', isSelected: false));
    _dataTypeConditions.add(SortCondition(name: '日数据', isSelected: false));
    _selectBrandSortCondition = _dataTypeConditions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('历史在线数据'),
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
                  GZXDropDownHeaderItem(_dropDownHeaderItemStrings[0],
                      iconSize: 24),
                  GZXDropDownHeaderItem(_dropDownHeaderItemStrings[1],
                      iconData: Icons.date_range, iconSize: 15),
                  GZXDropDownHeaderItem(_dropDownHeaderItemStrings[2],
                      iconData: Icons.date_range, iconSize: 15),
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
                      locale: DateTimePickerLocale.zh_cn,
                      onClose: (){
                        _dropdownMenuController.hide();
                      },
                      onConfirm: (dateTime, selectedIndex){
                        print('$selectedIndex');
                        _dropDownHeaderItemStrings[1] = DateUtil.formatDate(dateTime, format: 'yyyy-MM-dd  ');
                        setState(() {

                        });
                      }
                    );
                  }else if(index == 2){
                    DatePicker.showDatePicker(
                        context,
                        locale: DateTimePickerLocale.zh_cn,
                        onClose: (){
                          _dropdownMenuController.hide();
                        },
                        onConfirm: (dateTime, selectedIndex){
                          print('$selectedIndex');
                          _dropDownHeaderItemStrings[2] = DateUtil.formatDate(dateTime, format: 'yyyy-MM-dd  ');
                          setState(() {

                          });
                        }
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
                child: CustomDataTable(
                  fixedCornerCell: MonitorTableCell(value: '    监测时间'),
                  rowsCells: MonitorTable.getTestData().rowsCells,
                  fixedColCells: MonitorTable.getTestData().fixedColCells,
                  fixedRowCells: MonitorTable.getTestData().fixedRowCells,
                  cellBuilder: (data) {
                    return Text(
                      '${data.value}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: data.textColor),
                    );
                  },
                ),
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
                    _dropDownHeaderItemStrings[0] =
                        _selectBrandSortCondition.name;
                    _dropdownMenuController.hide();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildConditionListWidget(
      items, void itemOnTap(SortCondition sortCondition)) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      // item 的个数
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
//            color: Colors.blue,
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
  bool isSelected;

  SortCondition({this.name, this.isSelected});
}

class CustomDataTable<T> extends StatefulWidget {
  final T fixedCornerCell;
  final List<T> fixedColCells;
  final List<T> fixedRowCells;
  final List<List<T>> rowsCells;
  final Widget Function(T data) cellBuilder;
  final double fixedColWidth;
  final double cellWidth;
  final double cellHeight;
  final double cellMargin;
  final double cellSpacing;

  CustomDataTable({
    this.fixedCornerCell,
    this.fixedColCells,
    this.fixedRowCells,
    @required this.rowsCells,
    this.cellBuilder,
    this.fixedColWidth = 76.0,
    this.cellHeight = 50.0,
    this.cellWidth = 60.0,
    this.cellMargin = 0.0,
    this.cellSpacing = 0.0,
  });

  @override
  State<StatefulWidget> createState() => CustomDataTableState();
}

class CustomDataTableState<T> extends State<CustomDataTable<T>> {
  final _columnController = ScrollController();
  final _rowController = ScrollController();
  final _subTableYController = ScrollController();
  final _subTableXController = ScrollController();

  Widget _buildChild(double width, T data) => SizedBox(
      width: width, child: widget.cellBuilder?.call(data) ?? Text('$data'));

  Widget _buildFixedCol() => widget.fixedColCells == null
      ? SizedBox.shrink()
      : Material(
          //color: Colors.lightBlueAccent,
          color: Colors.white,
          child: DataTable(
              horizontalMargin: widget.cellMargin,
              columnSpacing: widget.cellSpacing,
              headingRowHeight: widget.cellHeight,
              dataRowHeight: widget.cellHeight,
              columns: [
                DataColumn(
                    label: _buildChild(
                        widget.fixedColWidth, widget.fixedColCells.first))
              ],
              rows: widget.fixedColCells
                  .sublist(widget.fixedRowCells == null ? 1 : 0)
                  .map((c) => DataRow(
                      cells: [DataCell(_buildChild(widget.fixedColWidth, c))]))
                  .toList()),
        );

  Widget _buildFixedRow() => widget.fixedRowCells == null
      ? SizedBox.shrink()
      : Material(
          //color: Colors.greenAccent,
          color: Colors.white,
          child: DataTable(
              horizontalMargin: widget.cellMargin,
              columnSpacing: widget.cellSpacing,
              headingRowHeight: widget.cellHeight,
              dataRowHeight: widget.cellHeight,
              columns: widget.fixedRowCells
                  .map((c) =>
                      DataColumn(label: _buildChild(widget.cellWidth, c)))
                  .toList(),
              rows: []),
        );

  Widget _buildSubTable() => Material(
      //color: Colors.lightGreenAccent,
      color: Colors.white,
      child: DataTable(
          horizontalMargin: widget.cellMargin,
          columnSpacing: widget.cellSpacing,
          headingRowHeight: widget.cellHeight,
          dataRowHeight: widget.cellHeight,
          columns: widget.rowsCells.first
              .map((c) => DataColumn(label: _buildChild(widget.cellWidth, c)))
              .toList(),
          rows: widget.rowsCells
              .sublist(widget.fixedRowCells == null ? 1 : 0)
              .map((row) => DataRow(
                  cells: row
                      .map((c) => DataCell(_buildChild(widget.cellWidth, c)))
                      .toList()))
              .toList()));

  Widget _buildCornerCell() =>
      widget.fixedColCells == null || widget.fixedRowCells == null
          ? SizedBox.shrink()
          : Material(
              //color: Colors.amberAccent,
              color: Colors.white,
              child: DataTable(
                  horizontalMargin: widget.cellMargin,
                  columnSpacing: widget.cellSpacing,
                  headingRowHeight: widget.cellHeight,
                  dataRowHeight: widget.cellHeight,
                  columns: [
                    DataColumn(
                        label: _buildChild(
                            widget.fixedColWidth, widget.fixedCornerCell))
                  ],
                  rows: []),
            );

  @override
  void initState() {
    super.initState();
    _subTableXController.addListener(() {
      _rowController.jumpTo(_subTableXController.position.pixels);
    });
    _subTableYController.addListener(() {
      _columnController.jumpTo(_subTableYController.position.pixels);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            SingleChildScrollView(
              controller: _columnController,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              child: _buildFixedCol(),
            ),
            Flexible(
              child: SingleChildScrollView(
                controller: _subTableXController,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  controller: _subTableYController,
                  scrollDirection: Axis.vertical,
                  child: _buildSubTable(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            _buildCornerCell(),
            Flexible(
              child: SingleChildScrollView(
                controller: _rowController,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                child: _buildFixedRow(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
