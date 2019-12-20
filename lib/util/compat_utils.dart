import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/res/constant.dart';

/// 兼容工具类
///
/// 根据不同用户类型和不同配置返回对应的数据
/// 为了同时兼容污染源系统（Java/Python）和运维系统
class CompatUtils {
  /// 根据不同的用户类型返回不同的dio实例
  static Dio getDio() {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        //环保和企业用户
        if (SpUtil.getBool(Constant.spUseJavaApi,
            defValue: Constant.defaultUseJavaApi))
          return JavaDioUtils.instance.getDio();
        else
          return PythonDioUtils.instance.getDio();
        break;
      case 2:
        //运维用户
        return OperationDioUtils.instance.getDio();
      default:
        throw Exception(
            '获取dio实例失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同用户类型设置请求的token
  static setToken(options) {
    String accessToken = SpUtil.getString(Constant.spToken);
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        //环保和企业用户
        if (SpUtil.getBool(Constant.spUseJavaApi,
            defValue: Constant.defaultUseJavaApi))
          options.headers[Constant.requestHeaderTokenKey] = accessToken;
        else
          options.headers[Constant.requestHeaderAuthorizationKey] =
              'Bearer $accessToken';
        break;
      case 2:
        //TODO 运维用户
        options.headers[Constant.requestHeaderTokenKey] = accessToken;
        break;
      default:
        throw Exception(
            '设置token失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型解析json中的token
  static String getResponseToken(Response response) {
    if (response == null)
      throw DioError(
          error: TokenException('刷新Token失败！response为空！'));
    ;
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        //环保和企业用户
        if (SpUtil.getBool(Constant.spUseJavaApi,
            defValue: Constant.defaultUseJavaApi)) {
          if (response.statusCode == ExceptionHandle.success &&
              response.data[Constant.responseCodeKey] ==
                  ExceptionHandle.success_code) {
            return response.data[Constant.responseDataKey]
                [Constant.responseTokenKey];
          } else {
            throw DioError(
                error: TokenException(
                    '刷新Token失败！response=${response.toString()}'));
          }
        } else {
          if (response.statusCode == ExceptionHandle.success) {
            return response.data[Constant.responseTokenKey];
          } else {
            throw DioError(
                error: TokenException(
                    '刷新Token失败！response=${response.toString()}'));
          }
        }
        break;
      case 2:
        //TODO 运维用户
        if (response.statusCode == ExceptionHandle.success) {
          return response.data[Constant.responseTokenKey];
        } else {
          throw DioError(
              error:
                  TokenException('刷新Token失败！response=${response.toString()}'));
        }
        break;
      default:
        throw Exception(
            '获取数据失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 企业用户登录时，根据不同用户类型解析enterId
  static getResponseEnterId(response) {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 1:
      //企业用户
        if (SpUtil.getBool(Constant.spUseJavaApi,
            defValue: Constant.defaultUseJavaApi))
          return response.data[Constant.responseDataKey][Constant.responseIdKey];
        else
          return response.data[Constant.responseEnterIdKey];
        break;
      default:
        throw Exception(
            '获取企业id失败，当前用户不是企业用户！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型解析json中的data（有的数据最外层包了一层code，message，data）
  static Map<String, dynamic> getResponseData(Response response) {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        //环保和企业用户
        if (SpUtil.getBool(Constant.spUseJavaApi,
            defValue: Constant.defaultUseJavaApi))
          return response.data[Constant.responseDataKey];
        else
          return response.data;
        break;
      case 2:
        //TODO 运维用户
        return response.data;
      default:
        throw Exception(
            '获取数据失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型获取枚举对应的接口
  static String getApi(HttpApi httpApi) {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        //环保和企业用户
        if (SpUtil.getBool(Constant.spUseJavaApi,
            defValue: Constant.defaultUseJavaApi))
          return getJavaApi(httpApi);
        else
          return getPythonApi(httpApi);
        break;
      case 2:
        //运维用户
        return getOperationApi(httpApi);
      default:
        throw Exception(
            '获取接口失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据传入的枚举类型返回对应的Java接口
  static String getJavaApi(httpApi) {
    switch (httpApi) {
      case HttpApi.adminIndex:
        return HttpApiJava.adminIndex;
      case HttpApi.adminToken:
        return HttpApiJava.adminToken;
      case HttpApi.enterToken:
        return HttpApiJava.enterToken;
      case HttpApi.enterList:
        return HttpApiJava.enterList;
      case HttpApi.enterDetail:
        return HttpApiJava.enterDetail;
      case HttpApi.dischargeList:
        return HttpApiJava.dischargeList;
      case HttpApi.dischargeDetail:
        return HttpApiJava.dischargeDetail;
      case HttpApi.monitorList:
        return HttpApiJava.monitorList;
      case HttpApi.monitorDetail:
        return HttpApiJava.monitorDetail;
      case HttpApi.orderList:
        return HttpApiJava.orderList;
      case HttpApi.orderDetail:
        return HttpApiJava.orderDetail;
      case HttpApi.processesUpload:
        return HttpApiJava.processesUpload;
      case HttpApi.dischargeReportList:
        return HttpApiJava.dischargeReportList;
      case HttpApi.dischargeReportDetail:
        return HttpApiJava.dischargeReportDetail;
      case HttpApi.dischargeReportUpload:
        return HttpApiJava.dischargeReportUpload;
      case HttpApi.factorReportList:
        return HttpApiJava.factorReportList;
      case HttpApi.factorReportDetail:
        return HttpApiJava.factorReportDetail;
      case HttpApi.factorReportUpload:
        return HttpApiJava.factorReportUpload;
      case HttpApi.longStopReportList:
        return HttpApiJava.longStopReportList;
      case HttpApi.longStopReportDetail:
        return HttpApiJava.longStopReportDetail;
      case HttpApi.longStopReportUpload:
        return HttpApiJava.longStopReportUpload;
      case HttpApi.licenseList:
        return HttpApiJava.licenseList;
      case HttpApi.licenseDetail:
        return HttpApiJava.licenseDetail;
      case HttpApi.dischargeReportStopTypeList:
        return HttpApiJava.dischargeReportStopTypeList;
      case HttpApi.factorReportAlarmTypeList:
        return HttpApiJava.factorReportAlarmTypeList;
      case HttpApi.factorReportFactorList:
        return HttpApiJava.factorReportFactorList;
      default:
        throw DioError(
            type: DioErrorType.DEFAULT,
            error: NotFoundException('HttpApiJava中没有对应的接口'));
    }
  }

  /// 根据传入的枚举类型返回对应的Python接口
  static String getPythonApi(httpApi) {
    switch (httpApi) {
      case HttpApi.adminIndex:
        return HttpApiPython.adminIndex;
      case HttpApi.adminToken:
        return HttpApiPython.adminToken;
      case HttpApi.enterToken:
        return HttpApiPython.enterToken;
      case HttpApi.enterList:
        return HttpApiPython.enterList;
      case HttpApi.enterDetail:
        return HttpApiPython.enterDetail;
      case HttpApi.dischargeList:
        return HttpApiPython.dischargeList;
      case HttpApi.dischargeDetail:
        return HttpApiPython.dischargeDetail;
      case HttpApi.monitorList:
        return HttpApiPython.monitorList;
      case HttpApi.monitorDetail:
        return HttpApiPython.monitorDetail;
      case HttpApi.orderList:
        return HttpApiPython.orderList;
      case HttpApi.orderDetail:
        return HttpApiPython.orderDetail;
      case HttpApi.processesUpload:
        return HttpApiPython.processesUpload;
      case HttpApi.dischargeReportList:
        return HttpApiPython.dischargeReportList;
      case HttpApi.dischargeReportDetail:
        return HttpApiPython.dischargeReportDetail;
      case HttpApi.dischargeReportUpload:
        return HttpApiPython.dischargeReportUpload;
      case HttpApi.factorReportList:
        return HttpApiPython.factorReportList;
      case HttpApi.factorReportDetail:
        return HttpApiPython.factorReportDetail;
      case HttpApi.factorReportUpload:
        return HttpApiPython.factorReportUpload;
      case HttpApi.longStopReportList:
        return HttpApiPython.longStopReportList;
      case HttpApi.longStopReportDetail:
        return HttpApiPython.longStopReportDetail;
      case HttpApi.longStopReportUpload:
        return HttpApiPython.longStopReportUpload;
      case HttpApi.licenseList:
        return HttpApiPython.licenseList;
      case HttpApi.licenseDetail:
        return HttpApiPython.licenseDetail;
      default:
        throw DioError(
            type: DioErrorType.DEFAULT,
            error: NotFoundException('HttpApiPython中没有对应的接口'));
    }
  }

  /// 根据传入的枚举类型返回对应的运维接口
  static String getOperationApi(httpApi) {
    switch (httpApi) {
      case HttpApi.operationToken:
        return HttpApiOperation.operationToken;
      case HttpApi.operationIndex:
        return HttpApiOperation.operationIndex;
      case HttpApi.enterList:
        return HttpApiOperation.enterList;
      case HttpApi.enterDetail:
        return HttpApiOperation.enterDetail;
      case HttpApi.dischargeList:
        return HttpApiOperation.dischargeList;
      case HttpApi.dischargeDetail:
        return HttpApiOperation.dischargeDetail;
      case HttpApi.monitorList:
        return HttpApiOperation.monitorList;
      case HttpApi.monitorDetail:
        return HttpApiOperation.monitorDetail;
      case HttpApi.orderList:
        return HttpApiOperation.orderList;
      case HttpApi.orderDetail:
        return HttpApiOperation.orderDetail;
      case HttpApi.dischargeReportList:
        return HttpApiOperation.dischargeReportList;
      case HttpApi.dischargeReportDetail:
        return HttpApiOperation.dischargeReportDetail;
      case HttpApi.factorReportList:
        return HttpApiOperation.factorReportList;
      case HttpApi.factorReportDetail:
        return HttpApiOperation.factorReportDetail;
      case HttpApi.longStopReportList:
        return HttpApiOperation.longStopReportList;
      case HttpApi.longStopReportDetail:
        return HttpApiOperation.longStopReportDetail;
      case HttpApi.licenseList:
        return HttpApiOperation.licenseList;
      case HttpApi.licenseDetail:
        return HttpApiOperation.licenseDetail;
      default:
        throw DioError(
            type: DioErrorType.DEFAULT,
            error: NotFoundException('HttpApiOperation中没有对应的接口'));
    }
  }
}
