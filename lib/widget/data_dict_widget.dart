import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_state.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';

/// 数据字典选择控件
class DataDictWidget extends StatelessWidget {
  final String title;
  final String content;
  final DataDictBloc dataDictBloc;
  final PopupMenuItemSelected<DataDict> onSelected;
  final double height;

  DataDictWidget({
    Key key,
    @required this.title,
    @required this.content,
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
                  style: TextStyle(fontSize: 15),
                ),
                Gaps.hGap20,
                Expanded(
                  flex: 1,
                  child: PopupMenuButton<DataDict>(
                    child: InkWell(
                      onTap: state is DataDictError
                          ? () => dataDictBloc.add(DataDictLoad())
                          : null,
                      child: Container(
                        height: height,
                        alignment: Alignment.centerRight,
                        child: Text(
                          content ??
                              () {
                                if (state is DataDictLoading) {
                                  return '$title加载中';
                                } else if (state is DataDictError) {
                                  return '$title加载失败';
                                } else {
                                  return '请选择$title';
                                }
                              }(),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 15,
                            color: content == null
                                ? Colours.secondary_text
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

class DataDictMultiWidget extends StatelessWidget {
  final String title;
  final String content;
  final DataDictBloc dataDictBloc;
  final PopupMenuItemSelected<List<DataDict>> onMultiSelected;
  final double height;

  DataDictMultiWidget({
    Key key,
    @required this.title,
    @required this.content,
    @required this.dataDictBloc,
    @required this.onMultiSelected,
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
                  style: TextStyle(fontSize: 15),
                ),
                Gaps.hGap20,
                Expanded(
                  flex: 1,
                  child: PopupMenuButton<DataDict>(
                    child: InkWell(
                      onTap: state is DataDictError
                          ? () => dataDictBloc.add(DataDictLoad())
                          : null,
                      child: Container(
                        height: height,
                        alignment: Alignment.centerRight,
                        child: Text(
                          content ??
                              () {
                                if (state is DataDictLoading) {
                                  return '$title加载中';
                                } else if (state is DataDictError) {
                                  return '$title加载失败';
                                } else {
                                  return '请选择$title';
                                }
                              }(),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 15,
                            color: content == null
                                ? Colours.secondary_text
                                : Colours.primary_text,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    onSelected: (DataDict result) {
                      if (state is DataDictLoaded) {
                        onMultiSelected(state.dataDictList
                            .where((dataDict) => dataDict.checked)
                            .toList());
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      if (state is DataDictLoaded) {
                        List<PopupMenuItem<DataDict>> list = state.dataDictList
                            .map<PopupMenuItem<DataDict>>((dataDict){
                          return PopupMenuItem<DataDict>(
                            value: dataDict,
                            child: CheckboxListTile(
                              title: Text('${dataDict.name}'),
                              value: dataDict.checked,
                              dense: false,
                              activeColor: Colors.orangeAccent,
                              checkColor: Colors.pink,
                              controlAffinity: ListTileControlAffinity.leading,
                              //selected: dataDict.checked,
                              onChanged: (checked) {
                                int index=state.dataDictList.indexOf(dataDict);
                                DataDict checkedDataDict = state.dataDictList[index].copyWith(checked: checked);
                                dataDictBloc.add(DataDictUpdate(index: index, dataDict: checkedDataDict));
                                print(index);
                              },
                            ),
                          );
                        }).toList();
                        list.add(
                          PopupMenuItem<DataDict>(
                              value: DataDict(code: '-1', name: '确定'),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 6),
                                  child: Text('确定'),
                                  color: Colors.lightBlue,
                                ),
                              )),
                        );
                        return list;
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
