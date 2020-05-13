import 'package:flutter/material.dart';
import 'package:pollution_source/module/common/collection/law/mobile_law_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';

import '../common_widget.dart';

/// [CollectionDialog]点击修改按钮的回调函数
typedef ConfirmCallBack = void Function(List collection);

class CollectionDialog<T> extends StatefulWidget {
  final String title;
  final String imagePath;
  final List<T> collection;
  final List<T> checkList;
  final ConfirmCallBack confirmCallBack;

  CollectionDialog({
    this.title = '',
    this.imagePath = '',
    @required this.collection,
    this.checkList = const [],
    this.confirmCallBack,
  });

  @override
  _CollectionDialogState<T> createState() => _CollectionDialogState<T>();
}

class _CollectionDialogState<T> extends State<CollectionDialog<T>> {
  final List<T> checkList = <T>[];

  @override
  void initState() {
    super.initState();
    checkList.addAll(widget.checkList);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height / 1.3,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      widget.imagePath,
                      height: 24,
                      width: 24,
                    ),
                    Gaps.hGap10,
                    Text(
                      '${widget.title}(已选中${checkList.length}项)',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Gaps.vGap16,
                Flexible(
                  child: ListView.separated(
                      itemCount: widget.collection.length,
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) {
                        return Gaps.vGap6;
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final item = widget.collection[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (checkList.contains(item))
                                checkList.remove(item);
                              else {
                                checkList.add(item);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: checkList.contains(item)
                                  ? Colors.lightBlueAccent
                                  : Colours.divider_color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(
                              child: () {
                                if (item is MobileLaw) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '执法ID：${item.lawId}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: checkList.contains(item)
                                              ? Colors.white
                                              : Colours.secondary_text,
                                        ),
                                      ),
                                      Text(
                                        '执法人：${item.lawPersonStr}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: checkList.contains(item)
                                              ? Colors.white
                                              : Colours.secondary_text,
                                        ),
                                      ),
                                      Text(
                                        '开始时间：${item.startTimeStr}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: checkList.contains(item)
                                              ? Colors.white
                                              : Colours.secondary_text,
                                        ),
                                      ),
                                      Text(
                                        '结束时间：${item.endTimeStr}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: checkList.contains(item)
                                              ? Colors.white
                                              : Colours.secondary_text,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const Text('未知的类型');
                                }
                              }(),
                            ),
                          ),
                        );
                      }),
                ),
                Gaps.vGap16,
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: InkWellButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        children: <Widget>[
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              boxShadow: [UIUtils.getBoxShadow()],
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(
                              child: Text(
                                '取  消',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.hGap10,
                    Expanded(
                      flex: 1,
                      child: InkWellButton(
                        onTap: () {
                          if (widget.confirmCallBack != null) {
                            widget.confirmCallBack(checkList);
                            Navigator.pop(context);
                          }
                        },
                        children: <Widget>[
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              boxShadow: [UIUtils.getBoxShadow()],
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(
                              child: Text(
                                '确  定',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gaps.vGap6,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
