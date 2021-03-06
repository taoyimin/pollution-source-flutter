import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_state.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/toast_utils.dart';
import 'package:pollution_source/util/ui_utils.dart';

import 'data_dict_model.dart';

/// 数据字典弹出菜单控件
///
/// 通过传入[title]和[content]设置标题和内容，标题居左，内容居右，根据[DataDictBloc]
/// 处于不同的状态以及[content]是否为null或空字符串来判断当前是否有选项被选中，[content]
/// 的点击事件和文字与样式也会有所不同。[tipText]为提示文字，当[DataDictBloc]处于未初始
/// 化状态时，点击[content]将弹出[SnackBarAction]提示用户。通过传入[onSelected]函数，
/// 可以在外部监听选中的选项，控件高度默认46
class DataDictPopupMenuWidget extends StatelessWidget {
  final String title;
  final String content;
  final String tipText;
  final DataDictBloc dataDictBloc;
  final PopupMenuItemSelected<DataDict> onSelected;
  final double height;

  DataDictPopupMenuWidget({
    Key key,
    @required this.title,
    @required this.content,
    this.tipText = '还未完成初始化，无法选择',
    @required this.dataDictBloc,
    @required this.onSelected,
    this.height = 46,
  })  : assert(dataDictBloc != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataDictBloc, DataDictState>(
      bloc: dataDictBloc,
      listener: (context, state) {
        if (state is DataDictError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('$title加载失败！'),
              action: SnackBarAction(
                label: '查看详情',
                textColor: Colours.primary_color,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("错误信息"),
                        content: SingleChildScrollView(
                          child: Text('${state.message}'),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: '${state.message}'));
                              Toast.show('复制到剪贴板成功！');
                              Navigator.of(context).pop();
                            },
                            child: const Text("复制"),
                          ),
                          FlatButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            child: const Text("确认"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        }
      },
      child: BlocBuilder<DataDictBloc, DataDictState>(
        bloc: dataDictBloc,
        builder: (context, state) {
          return Container(
            height: height,
            child: Row(
              children: <Widget>[
                Text(
                  '$title',
                  style: const TextStyle(fontSize: 15),
                ),
                Gaps.hGap20,
                Expanded(
                  flex: 1,
                  child: PopupMenuButton<DataDict>(
                    child: InkWell(
                      // 如果state不是DataDictError或DataDictInitial，则点击事件为null
                      // 将点击事件向下传递给PopupMenuButton
                      onTap: state is DataDictError || state is DataDictInitial
                          ? () {
                              if (state is DataDictError) {
                                // 如果加载失败，则点击重新加载
                                dataDictBloc.add(DataDictLoad());
                              } else if (state is DataDictInitial) {
                                // 如果还未初始化，则显示提示信息
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('$tipText'),
                                    action: SnackBarAction(
                                        label: '我知道了',
                                        textColor: Colours.primary_color,
                                        onPressed: () {}),
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          content == null || content == ''
                              ? () {
                                  if (state is DataDictLoading)
                                    return '$title加载中';
                                  else if (state is DataDictError)
                                    return '$title加载失败';
                                  else if (state is DataDictInitial)
                                    return '$tipText';
                                  else if (state is DataDictLoaded)
                                    return '请选择$title';
                                  else
                                    return '未知状态，state=$state';
                                }()
                              : content,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 15,
                            color: content == null || content == ''
                                ? () {
                                    if (state is DataDictError)
                                      return Colors.red;
                                    else
                                      return Colours.secondary_text;
                                  }()
                                : Colours.primary_text,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    onSelected: onSelected,
                    itemBuilder: (BuildContext context) {
                      if (state is DataDictLoaded) {
                        return state.dataDictList
                            .map<PopupMenuItem<DataDict>>((dataDict) {
                          return PopupMenuItem<DataDict>(
                            value: dataDict,
                            child: Text('${dataDict.name}'),
                          );
                        }).toList();
                      } else {
                        return [];
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// [DataDictGrid] item点击的回调函数
typedef DataDictGridItemTap = void Function(String value);

/// 网格布局的数据字典控件
class DataDictGrid extends StatelessWidget {
  final List<DataDict> dataDictList;
  final String checkValue;
  final DataDictGridItemTap onItemTap;

  DataDictGrid({
    @required this.dataDictList,
    @required this.checkValue,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: 2,
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: List.generate(
        dataDictList.length,
        (index) {
          return InkWell(
            onTap: onItemTap != null
                ? () {
                    onItemTap(dataDictList[index].code);
                  }
                : () {},
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: checkValue == dataDictList[index].code
                      ? Colours.primary_color
                      : Colours.divider_color,
                ),
                color: checkValue == dataDictList[index].code
                    ? Colours.primary_color.withOpacity(0.3)
                    : Colours.divider_color,
              ),
              child: Center(
                child: Text(
                  dataDictList[index].name,
                  style: TextStyle(
                    fontSize: 12,
                    color: checkValue == dataDictList[index].code
                        ? Colours.primary_color
                        : Colours.secondary_text,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 带标题的网格布局数据字典控件
class DataDictGridWidget extends StatelessWidget {
  final String title;
  final List<DataDict> dataDictList;
  final String checkValue;
  final DataDictGridItemTap onItemTap;

  DataDictGridWidget({
    @required this.title,
    @required this.dataDictList,
    @required this.checkValue,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        DataDictGrid(
          checkValue: checkValue,
          dataDictList: dataDictList,
          onItemTap: onItemTap,
        ),
        Gaps.vGap10,
      ],
    );
  }
}

/// 网格布局的数据字典控件（通过Bloc获取数据字典的内容）
class DataDictBlocGrid extends StatelessWidget {
  final DataDictBloc dataDictBloc;
  final String checkValue;
  final DataDictGridItemTap onItemTap;
  final bool addFirst;
  final DataDict defaultDataDict;

  DataDictBlocGrid({
    Key key,
    @required this.dataDictBloc,
    this.checkValue,
    this.onItemTap,
    this.addFirst = true,
    this.defaultDataDict,
  })  : assert(dataDictBloc != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataDictBloc, DataDictState>(
      bloc: dataDictBloc,
      builder: (context, state) {
        if (state is DataDictLoaded) {
          if (defaultDataDict != null) {
            // 默认添加一个数据字典
            if (!state.dataDictList.contains(defaultDataDict)) {
              // 防止重复添加
              state.dataDictList.insert(0, defaultDataDict);
            }
          }
          if (addFirst) {
            // 默认添加一个全部的数据字典
            DataDict dataDict = DataDict(code: '', name: '全部');
            if (!state.dataDictList.contains(dataDict)) {
              // 防止重复添加
              state.dataDictList.insert(0, dataDict);
            }
          }
          return GridView.count(
            shrinkWrap: true,
            childAspectRatio: 2,
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 10),
            children: List.generate(
              state.dataDictList.length,
              (index) {
                return InkWell(
                  onTap: onItemTap != null
                      ? () {
                          onItemTap(state.dataDictList[index].code);
                        }
                      : () {},
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: checkValue == state.dataDictList[index].code
                            ? Colours.primary_color
                            : Colours.divider_color,
                      ),
                      color: checkValue == state.dataDictList[index].code
                          ? Colours.primary_color.withOpacity(0.3)
                          : Colours.divider_color,
                    ),
                    child: Center(
                      child: Text(
                        state.dataDictList[index].name,
                        style: TextStyle(
                          fontSize: 12,
                          color: checkValue == state.dataDictList[index].code
                              ? Colours.primary_color
                              : Colours.secondary_text,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is DataDictLoading) {
          return LoadingWidget();
        } else if (state is DataDictError) {
          return RowErrorWidget(
            errorMessage: state.message,
            onReloadTap: () {
              dataDictBloc.add(DataDictLoad());
            },
          );
        } else {
          return RowErrorWidget(
            errorMessage: 'BlocBuilder监听到未知的的状态！state=$state',
            onReloadTap: () {
              dataDictBloc.add(DataDictLoad());
            },
          );
        }
      },
    );
  }
}

/// 带标题的网格布局数据字典控件（通过Bloc获取数据字典的内容）
class DataDictBlocGridWidget extends StatelessWidget {
  final String title;
  final DataDictBloc dataDictBloc;
  final String checkValue;
  final DataDictGridItemTap onItemTap;
  final bool addFirst;
  final DataDict defaultDataDict;

  DataDictBlocGridWidget({
    Key key,
    @required this.title,
    @required this.dataDictBloc,
    this.checkValue,
    this.onItemTap,
    this.addFirst = true,
    this.defaultDataDict,
  })  : assert(dataDictBloc != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        DataDictBlocGrid(
          key: key,
          checkValue: checkValue,
          dataDictBloc: dataDictBloc,
          onItemTap: onItemTap,
          addFirst: addFirst,
          defaultDataDict: defaultDataDict,
        ),
        Gaps.vGap10,
      ],
    );
  }
}

/// [DataDictDialog]点击修改按钮的回调函数
typedef ConfirmCallBack = void Function(List<DataDict> dataDictList);

/// 数据字典多选Dialog
class DataDictDialog extends StatefulWidget {
  final String title;
  final String imagePath;
  final List<DataDict> dataDictList;
  final List<DataDict> checkList;
  final ConfirmCallBack confirmCallBack;

  DataDictDialog({
    this.title = '',
    this.imagePath = '',
    @required this.dataDictList,
    this.checkList = const [],
    this.confirmCallBack,
  });

  @override
  _DataDictDialogState createState() => _DataDictDialogState();
}

class _DataDictDialogState extends State<DataDictDialog> {
  final List<DataDict> checkList = [];

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
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    children: widget.dataDictList.map<Widget>((dataDict) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (checkList.contains(dataDict))
                              checkList.remove(dataDict);
                            else {
                              checkList.add(dataDict);
                            }
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: checkList.contains(dataDict)
                                ? Colors.lightBlueAccent
                                : Colours.divider_color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: Text(
                              '${dataDict.name}',
                              style: TextStyle(
                                fontSize: 14,
                                color: checkList.contains(dataDict)
                                    ? Colors.white
                                    : Colours.secondary_text,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
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
                            (widget.confirmCallBack)(checkList);
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

@Deprecated('暂未使用')
class DataDictBlocDialog extends StatefulWidget {
  final String title;
  final String imagePath;
  final DataDictBloc dataDictBloc;
  final List<DataDict> checkList;
  final ConfirmCallBack confirmCallBack;

  DataDictBlocDialog({
    this.title = '',
    this.imagePath = '',
    @required this.dataDictBloc,
    this.checkList = const [],
    this.confirmCallBack,
  });

  @override
  _DataDictBlocDialogState createState() => _DataDictBlocDialogState();
}

@Deprecated('暂未使用')
class _DataDictBlocDialogState extends State<DataDictBlocDialog> {
  final List<DataDict> checkList = [];

  @override
  void initState() {
    super.initState();
    widget.dataDictBloc.add(DataDictLoad());
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
                BlocBuilder<DataDictBloc, DataDictState>(
                  bloc: widget.dataDictBloc,
                  builder: (context, state) {
                    if (state is DataDictLoading) {
                      return LoadingWidget();
                    } else if (state is DataDictError) {
                      return RowErrorWidget(
                        tipMessage: '${widget.title}加载失败，请重试！',
                        errorMessage: state.message,
                        onReloadTap: () =>
                            widget.dataDictBloc.add(DataDictLoad()),
                      );
                    } else if (state is DataDictLoaded) {
                      return Column(
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
                            child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 2.5,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              shrinkWrap: true,
                              children:
                                  state.dataDictList.map<Widget>((dataDict) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (checkList.contains(dataDict))
                                        checkList.remove(dataDict);
                                      else {
                                        checkList.add(dataDict);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: checkList.contains(dataDict)
                                          ? Colors.lightBlueAccent
                                          : Colours.divider_color,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${dataDict.name}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: checkList.contains(dataDict)
                                              ? Colors.white
                                              : Colours.secondary_text,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
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
                                      (widget.confirmCallBack)(checkList);
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
                      );
                    } else {
                      return RowErrorWidget(
                        errorMessage: 'BlocBuilder监听到未知的的状态!state=$state',
                        onReloadTap: () =>
                            widget.dataDictBloc.add(DataDictLoad()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
