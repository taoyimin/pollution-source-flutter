import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/map_info_page.dart';
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
            title: Text('排污许可证列表', style: TextStyle(color: Colours.primary_text),),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colours.primary_text),
            backgroundColor: Colors.transparent,
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
    );
  }

  Widget _buildPageLoadedList(List<License> licenseList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建列表项
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
                    gradient: LinearGradient(colors: [Color(0xFF589FFF), Color(0xFF5865FF)]),
                    //image: DecorationImage(image: AssetImage('assets/images/button_bg_lightblue.png'), fit: BoxFit.fill),
                    boxShadow: [
                      UIUtils.getBoxShadow(),
                    ],
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Gaps.hGap6,
                          Image.asset('assets/images/license_list_item_logo.png', width: 40),
                          /*CircleAvatar(
                            backgroundImage: AssetImage('assets/images/license_list_logo.png'),
                          ),*/
                          Gaps.hGap10,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('发证单位：${licenseList[index].issueUnitStr}', style: TextStyle(color: Colors.white),),
                              Text('发证时间：${licenseList[index].issueTimeStr}', style: TextStyle(color: Colors.white, fontSize: 12),),
                            ],
                          ),
                        ],
                      ),
                      Gaps.vGap6,
                      Text('${licenseList[index].licenseNumber}',style: TextStyle(color: Colors.white, fontSize: 18),),
                      Gaps.vGap6,
                      Text('有效期：${licenseList[index].validTimeStr}', style: TextStyle(color: Colors.white, fontSize: 12),),
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
