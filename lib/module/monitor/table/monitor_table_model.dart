import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MonitorTable extends Equatable {
  final List<MonitorTableCell> fixedColCells; //左边固定列
  final List<MonitorTableCell> fixedRowCells; //头部固定行
  final List<List<MonitorTableCell>> rowsCells; //数据行
  final String dataType;

  const MonitorTable({
    this.fixedColCells,
    this.fixedRowCells,
    this.rowsCells,
    this.dataType,
  });

  @override
  List<Object> get props => [
        fixedColCells,
        fixedRowCells,
        rowsCells,
        dataType,
      ];

  static MonitorTable fromJson(json) {
    List<MonitorTableCell> fixedRowCells =
        json['headers'].map<MonitorTableCell>((header) {
      return MonitorTableCell(
        value: header['title'],
        field: header['field'],
      );
    }).toList();
    List<MonitorTableCell> fixedColCells =
        json['times'].map<MonitorTableCell>((time) {
      return MonitorTableCell(
        value: DateUtil.formatDateMs(time, format: '  yyyy-MM-dd HH:mm:ss', isUtc: false),
      );
    }).toList();
    List<List<MonitorTableCell>> rowsCells =
        json['datas'].map<List<MonitorTableCell>>((row) {
      return fixedRowCells.map((header) {
        return MonitorTableCell(
          value: row[header.field] ?? '',
          alarmFlag: row[header.field.replaceAll('factor_data', 'alarm_flag')],
        );
      }).toList();
    }).toList();
    return MonitorTable(
      rowsCells: rowsCells,
      fixedColCells: fixedColCells,
      fixedRowCells: fixedRowCells,
    );
  }

//  static MonitorTable getTestData() {
//    return MonitorTable(
//        fixedColCells: List(20).map((data) {
//          return MonitorTableCell(value: '    15时22分');
//        }).toList(),
//        fixedRowCells: [
//          MonitorTableCell(value: '流量'),
//          MonitorTableCell(value: '累计流量'),
//          MonitorTableCell(value: 'PH'),
//          MonitorTableCell(value: '化学需氧量'),
//          MonitorTableCell(value: '氨氮'),
//          MonitorTableCell(value: '总磷'),
//          MonitorTableCell(value: '总氮'),
//        ],
//        rowsCells: List(20).map((data) {
//          return List(7).map((data) {
//            return MonitorTableCell(
//                value: Random.secure().nextInt(50).toString(),
//                color: Random.secure().nextInt(10).toString());
//          }).toList();
//        }).toList());
//  }
}

class MonitorTableCell extends Equatable {
  final String field; //表头对应的取值字段
  final dynamic value; //监测值
  final String alarmFlag; //文字颜色 默认黑色  0:黄色(预警) 1:红色(超标)

  const MonitorTableCell({
    this.field,
    this.value,
    this.alarmFlag = '',
  });

  Color get textColor {
    switch (alarmFlag) {
      case '0':
        // 正常
        return Colors.black;
      case '1':
        // 预警
        return Colors.orange;
      case '2':
        // 超标
        return Colors.red;
      case '3':
        // 负值（原极小值）
        return Colors.red;
      case '4':
        // 超大值（原极大值）
        return Colors.red;
      case '5':
        // 零值
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  List<Object> get props => [
        field,
        value,
        alarmFlag,
      ];
}

/// 监测数据类型枚举类
enum DataType {
  // 实时数据
  minute,
  // 十分钟数据
  tenminute,
  // 小时诗句
  hour,
  // 日数据
  day,
}
