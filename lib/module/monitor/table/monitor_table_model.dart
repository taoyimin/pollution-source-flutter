import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/util/ui_utils.dart';

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
        value: DateUtil.formatDateMs(time, format: '  yyyy-MM-dd HH:mm:ss'),
      );
    }).toList();
    List<List<MonitorTableCell>> rowsCells =
        json['datas'].map<List<MonitorTableCell>>((row) {
      return fixedRowCells.map((header) {
        return MonitorTableCell(
          value: row[header.field] ?? '',
          alarmFlag: row[header.field.replaceAll(RegExp('factor_data|zs_avg'), 'alarm_flag')],
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
  final String alarmFlag; //文字颜色

  const MonitorTableCell({
    this.field,
    this.value,
    this.alarmFlag = '',
  });

  Color get textColor {
    return UIUtils.getAlarmFlagColor(this.alarmFlag);
  }

  @override
  List<Object> get props => [
        field,
        value,
        alarmFlag,
      ];
}