import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/list/list_event.dart';
import 'package:pollution_source/module/common/list/list_state.dart';
import 'package:pollution_source/module/common/map_info_page.dart';
import 'package:pollution_source/module/license/list/license_list_model.dart';
import 'package:pollution_source/module/license/list/license_list_repository.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';

import 'package:pollution_source/module/common/common_widget.dart';

/// 排污许可证列表
class LicenseListPage extends StatefulWidget {
  final String enterId;

  LicenseListPage({this.enterId = ''});

  @override
  _LicenseListPageState createState() => _LicenseListPageState();
}

class _LicenseListPageState extends State<LicenseListPage> {
  ListBloc _listBloc;
  int _currentPage = Constant.defaultCurrentPage;
  final EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    // 初始化列表Bloc
    _listBloc = BlocProvider.of<ListBloc>(context);
    // 首次加载
    _listBloc.add(ListLoad(isRefresh: true, params: _getRequestParam()));
  }

  /// 获取请求参数
  Map<String, dynamic> _getRequestParam() {
    return LicenseListRepository.createParams(
      currentPage: _currentPage,
      pageSize: Constant.defaultPageSize,
      enterId: widget.enterId,
    );
  }

  @override
  void dispose() {
    // 释放资源
    _refreshController.dispose();
    // 取消正在进行的请求
    final currentState = _listBloc?.state;
    if (currentState is ListLoading) currentState.cancelToken?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        controller: _refreshController,
        slivers: <Widget>[
          SliverAppBar(
            title: const Text(
              '排污许可证列表',
              style: TextStyle(color: Colours.primary_text),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colours.primary_text),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          BlocBuilder<ListBloc, ListState>(
            condition: (previousState, state) {
              if (state is ListLoading)
                return false;
              else
                return true;
            },
            builder: (context, state) {
              if (state is ListInitial || state is ListLoading) {
                return LoadingSliver();
              } else if (state is ListEmpty) {
                return EmptySliver();
              } else if (state is ListError) {
                return ErrorSliver(
                  errorMessage: state.message,
                  onReloadTap: () => _refreshController.callRefresh(),
                );
              } else if (state is ListLoaded) {
                return _buildPageLoadedList(state.list);
              } else {
                return ErrorSliver(
                  errorMessage: 'BlocBuilder监听到未知的的状态！state=$state',
                  onReloadTap: () => _refreshController.callRefresh(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedList(List<License> licenseList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: InkWellButton(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MapInfoPage(
                    title: '排污许可证详情',
                    mapInfo: licenseList[index].getMapInfo(),
                  );
                }));
              },
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF589FFF), Color(0xFF5865FF)]),
                      boxShadow: [
                        UIUtils.getBoxShadow(),
                      ],
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Gaps.hGap6,
                          Image.asset(
                              'assets/images/license_list_item_logo.png',
                              width: 40),
                          Gaps.hGap10,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '发证单位：${licenseList[index].issueUnitStr}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '发证时间：${licenseList[index].issueTimeStr}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gaps.vGap6,
                      Text(
                        '${licenseList[index].licenseNumber}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Gaps.vGap6,
                      Text(
                        '有效期：${licenseList[index].validTimeStr}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: licenseList.length,
      ),
    );
  }
}
