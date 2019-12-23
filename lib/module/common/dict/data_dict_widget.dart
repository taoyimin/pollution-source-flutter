import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_state.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';

/// 数据字典选择控件
///
/// 通过传入[title]和[content]设置标题和内容，标题居左，内容居右，根据[DataDictBloc]
/// 处于不同的状态以及[content]是否为null或空字符串来判断当前是否有选项被选中，[content]
/// 的点击事件和文字与样式也会有所不同。[tipText]为提示文字，当[DataDictBloc]处于未初始
/// 化状态时，点击[content]将弹出[SnackBarAction]提示用户。通过传入[onSelected]函数，
/// 可以在外部监听选中的选项，控件高度默认46
class DataDictWidget extends StatelessWidget {
  final String title;
  final String content;
  final String tipText;
  final DataDictBloc dataDictBloc;
  final PopupMenuItemSelected<DataDict> onSelected;
  final double height;

  DataDictWidget({
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
              content: Text('$title加载失败！${state.message}'),
              action: SnackBarAction(
                  label: '我知道了',
                  textColor: Colours.primary_color,
                  onPressed: () {}),
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

/// 数据字典多选控件
///
/// [selected]参数为默认已经选中的选项，其他参数项参考[DataDictWidget]单选控件
class DataDictMultiWidget extends StatelessWidget {
  final String title;
  final String content;
  final String tipText;
  final List<DataDict> selected;
  final DataDictBloc dataDictBloc;
  final PopupMenuItemSelected<DataDict> onSelected;
  final double height;

  DataDictMultiWidget({
    Key key,
    @required this.title,
    @required this.content,
    this.tipText = '还未完成初始化，无法选择',
    @required this.selected,
    @required this.dataDictBloc,
    @required this.onSelected,
    this.height = 46,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataDictBloc, DataDictState>(
      bloc: dataDictBloc,
      listener: (context, state) {
        if (state is DataDictError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('$title加载失败！${state.message}'),
              action: SnackBarAction(
                  label: '我知道了',
                  textColor: Colours.primary_color,
                  onPressed: () {}),
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
                        height: height,
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
                          return CheckedPopupMenuItem<DataDict>(
                            value: dataDict,
                            checked: selected?.contains(dataDict) ?? false,
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
