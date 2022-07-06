import 'package:flutter/material.dart';

//自定义表格控件：表头固定，并且跟随内容滑动
class FixedDataTable<T> extends StatefulWidget {
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

  FixedDataTable({
    this.fixedCornerCell,
    this.fixedColCells,
    this.fixedRowCells,
    @required this.rowsCells,
    this.cellBuilder,
    this.fixedColWidth = 96.0,
    this.cellHeight = 50.0,
    this.cellWidth = 96.0,
    this.cellMargin = 0.0,
    this.cellSpacing = 0.0,
  });

  @override
  State<StatefulWidget> createState() => FixedDataTableState();
}

class FixedDataTableState<T> extends State<FixedDataTable<T>> {
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
                physics: ClampingScrollPhysics(),
                child: SingleChildScrollView(
                  controller: _subTableYController,
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
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