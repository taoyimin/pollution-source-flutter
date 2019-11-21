import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/http.dart';
import 'package:pollution_source/res/constant.dart';

import 'license_list.dart';

class LicenseListBloc extends Bloc<LicenseListEvent, LicenseListState> {
  @override
  LicenseListState get initialState => LicenseListLoading();

  @override
  Stream<LicenseListState> mapEventToState(LicenseListEvent event) async* {
    if (event is LicenseListLoad) {
      //加载排污许可证列表
      yield* _mapLicenseListLoadToState(event);
    }
  }

  Stream<LicenseListState> _mapLicenseListLoadToState(LicenseListLoad event) async* {
    try {
      final currentState = state;
      if (!event.isRefresh && currentState is LicenseListLoaded) {
        //加载更多
        final licenseList = await _getLicenseList(
          currentPage: currentState.currentPage + 1,
          enterId: event.enterId,
        );
        yield LicenseListLoaded(
          licenseList: currentState.licenseList + licenseList,
          currentPage: currentState.currentPage + 1,
          hasNextPage: currentState.pageSize == licenseList.length,
        );
      } else {
        //首次加载或刷新
        final licenseList = await _getLicenseList(
          enterId: event.enterId,
        );
        if (licenseList.length == 0) {
          //没有数据
          yield LicenseListEmpty();
        } else {
          yield LicenseListLoaded(
            licenseList: licenseList,
            hasNextPage: Constant.defaultPageSize == licenseList.length,
          );
        }
      }
    } catch (e) {
      yield LicenseListError(
          errorMessage: ExceptionHandle.handleException(e).msg);
    }
  }

  //获取排污许可证列表数据
  Future<List<License>> _getLicenseList({
    currentPage = Constant.defaultCurrentPage,
    pageSize = Constant.defaultPageSize,
    enterId = '',
  }) async {
    if(SpUtil.getBool(Constant.spJavaApi, defValue: true)){
      Response response = await JavaDioUtils.instance.getDio().get(
        HttpApiJava.licenseList,
        queryParameters: {
          'currentPage': currentPage,
          'pageSize': pageSize,
          'enterId': enterId,
        },
      );
      return response.data[Constant.responseDataKey][Constant.responseListKey]
          .map<License>((json) {
        return License.fromJson(json);
      }).toList();
    }else{
      Response response = await PythonDioUtils.instance.getDio().get(
        HttpApiPython.licenses,
        queryParameters: {
          'currentPage': currentPage,
          'pageSize': pageSize,
          'enterId': '10113',
        },
      );
      return response.data[Constant.responseListKey]
          .map<License>((json) {
        return License.fromJson(json);
      }).toList();
    }
  }
}
