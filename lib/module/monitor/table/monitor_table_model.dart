import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MonitorTable extends Equatable {
  final List<MonitorTableCell> fixedColCells; //头部固定行
  final List<MonitorTableCell> fixedRowCells; //左边固定列
  final List<List<MonitorTableCell>> rowsCells; //数据行

  const MonitorTable({
    this.fixedColCells,
    this.fixedRowCells,
    this.rowsCells,
  });

  @override
  List<Object> get props => [
        fixedColCells,
        fixedRowCells,
        rowsCells,
      ];

  static MonitorTable getTestData() {
    return MonitorTable(
      fixedColCells: List(20).map((data) {
        return MonitorTableCell(value: '    15时22分');
      }).toList(),
      fixedRowCells: [
        MonitorTableCell(value: '流量'),
        MonitorTableCell(value: '累计流量'),
        MonitorTableCell(value: 'PH'),
        MonitorTableCell(value: '化学需氧量'),
        MonitorTableCell(value: '氨氮'),
        MonitorTableCell(value: '总磷'),
        MonitorTableCell(value: '总氮'),
      ],
      rowsCells: List(20).map((data){
        return List(7).map((data) {
          return MonitorTableCell(value: Random.secure().nextInt(50).toString(), color: Random.secure().nextInt(10).toString());
        }).toList();
      }).toList()
    );
  }
}

class MonitorTableCell extends Equatable {
  final String value; //监测值
  final String color; //文字颜色 默认黑色  0:黄色(预警) 1:红色(超标)

  const MonitorTableCell({
    this.value,
    this.color = '',
  });

  Color get textColor {
    switch (color) {
      case '0':
        return Colors.orange;
      case '1':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  List<Object> get props => [
        value,
        color,
      ];
}
