import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/util/ui_utils.dart';

import 'package:pollution_source/module/common/common_widget.dart';

import 'license_list.dart';

class LicenseListPage extends StatefulWidget {
  final String enterId;

  LicenseListPage({this.enterId = ''});

  @override
  _LicenseListPageState createState() => _LicenseListPageState();
}

class _LicenseListPageState extends State<LicenseListPage>
    with TickerProviderStateMixin {
  LicenseListBloc _licenseListBloc;
  //EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _licenseListBloc = BlocProvider.of<LicenseListBloc>(context);
    //_refreshController = EasyRefreshController();
    //首次加载
    _licenseListBloc.add(LicenseListLoad(
      enterId: widget.enterId,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    //_refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('排污许可证列表'),
          ),
          BlocBuilder<LicenseListBloc, LicenseListState>(
            builder: (context, state) {
              if (state is LicenseListLoading) {
                return PageLoadingWidget();
              } else if (state is LicenseListEmpty) {
                return PageEmptyWidget();
              } else if (state is LicenseListError) {
                return PageErrorWidget(errorMessage: state.errorMessage);
              } else if (state is LicenseListLoaded) {
                return _buildPageLoadedList(state.licenseList);
              } else {
                return PageErrorWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
              }
            },
          ),
        ],
      ),
      /*appBar: AppBar(
        title: const Text('排污许可证列表'),
      ),
      body: Center(
        child: EasyRefresh.custom(
          slivers: <Widget>[
            BlocBuilder<LicenseListBloc, LicenseListState>(
              builder: (context, state) {
                if (state is LicenseListLoading) {
                  return PageLoadingWidget();
                } else if (state is LicenseListEmpty) {
                  return PageEmptyWidget();
                } else if (state is LicenseListError) {
                  return PageErrorWidget(errorMessage: state.errorMessage);
                } else if (state is LicenseListLoaded) {
                  if (!state.hasNextPage)
                    _refreshController.finishLoad(
                        noMore: !state.hasNextPage, success: true);
                  return _buildPageLoadedList(state.licenseList);
                } else {
                  return PageErrorWidget(errorMessage: 'BlocBuilder监听到未知的的状态');
                }
              },
            ),
          ],
        ),
      ),*/
    );
  }

  Widget _buildPageLoadedList(List<License> licenseList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建列表项
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: InkWellButton(
              onTap: () {
                /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BlocProvider(
                    builder: (context) => LicenseDetailBloc(),
                    child: LicenseDetailPage(
                      licenseId: licenseList[index].licenseId,
                    ),
                  );
                }));*/
              },
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      UIUtils.getBoxShadow(),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${licenseList[index].enterName}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Gaps.vGap6,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '发证单位：${licenseList[index].issueUnitStr}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTileWidget(
                                '发证时间：${licenseList[index].issueTimeStr}'),
                          ),
                        ],
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
