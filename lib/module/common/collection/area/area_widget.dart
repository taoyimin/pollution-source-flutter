import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pollution_source/module/common/collection/collection_bloc.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';

import '../../common_widget.dart';
import '../collection_event.dart';
import '../collection_state.dart';

/// [AreaWidget]点击确定按钮的回调函数
typedef ConfirmCallBack = void Function(Result result);

class AreaWidget extends StatelessWidget {
  final double itemHeight;
  final Result initialResult;
  final CollectionBloc collectionBloc;
  final ConfirmCallBack confirmCallBack;

  AreaWidget(
      {this.itemHeight,
      this.initialResult,
      this.collectionBloc,
      this.confirmCallBack});

  ShowType _getShowType(String level) {
    if (level == '0') {
      return ShowType.ca;
    } else if (level == '1') {
      return ShowType.a;
    } else {
      return ShowType.pca;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: collectionBloc,
      builder: (context, state) {
        if (state is CollectionLoaded) {
          return Offstage(
            // 非省厅用户或地市用户则隐藏
            offstage: state.collection[0].level != '0' &&
                state.collection[0].level != '1',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  '选择区域',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.vGap10,
                Row(
                  children: <Widget>[
                    Offstage(
                      // 如果不是省用户，则隐藏选择市
                      offstage: state.collection[0].level != '0',
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              Result result =
                              await CityPickers.showCityPicker(
                                context: context,
                                locationCode: state.collection[0].code,
                                citiesData: state.collection[0]
                                    .citiesData(state.collection[0].level),
                                showType:
                                _getShowType(state.collection[0].level),
                              );
                              if (confirmCallBack != null && result != null) {
                                confirmCallBack(result);
                              }
                            },
                            child: Container(
                              width: itemHeight * 2,
                              height: itemHeight,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: initialResult?.cityId != null
                                      ? Colours.primary_color
                                      : Colours.divider_color,
                                ),
                                color: initialResult?.cityId != null
                                    ? Colours.primary_color.withOpacity(0.3)
                                    : Colours.divider_color,
                              ),
                              child: Center(
                                child: Text(
                                  initialResult?.cityName ?? '选择市',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: initialResult?.cityName != null
                                        ? Colours.primary_color
                                        : Colours.secondary_text,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Gaps.hGap8,
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Result result = await CityPickers.showCityPicker(
                          context: context,
                          locationCode: state.collection[0].code,
                          citiesData: state.collection[0]
                              .citiesData(state.collection[0].level),
                          showType: _getShowType(state.collection[0].level),
                        );
                        if (confirmCallBack != null && result != null) {
                          confirmCallBack(result);
                        }
                      },
                      child: Container(
                        width: itemHeight * 2,
                        height: itemHeight,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                            color: initialResult?.areaId != null
                                ? Colours.primary_color
                                : Colours.divider_color,
                          ),
                          color: initialResult?.areaId != null
                              ? Colours.primary_color.withOpacity(0.3)
                              : Colours.divider_color,
                        ),
                        child: Center(
                          child: Text(
                            initialResult?.areaName ?? '选择区',
                            style: TextStyle(
                              fontSize: 12,
                              color: initialResult?.areaName != null
                                  ? Colours.primary_color
                                  : Colours.secondary_text,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gaps.vGap20,
              ],
            ),
          );
        } else if (state is CollectionLoading) {
          return LoadingWidget();
        } else if (state is CollectionError) {
          return RowErrorWidget(
            tipMessage: '区域信息加载失败，请重试！',
            errorMessage: state.message,
            onReloadTap: () {
              collectionBloc.add(CollectionLoad());
            },
          );
        } else {
          return RowErrorWidget(
            tipMessage: '区域信息加载失败，请重试！',
            errorMessage: 'BlocBuilder监听到未知的的状态！state=$state',
            onReloadTap: () {
              collectionBloc.add(CollectionLoad());
            },
          );
        }
      },
    );
  }
}
