import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/http/dio_utils.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/res/constant.dart';

/// 兼容工具类
///
/// 根据不同用户类型和不同配置返回对应的数据
/// 为了同时兼容污染源系统和运维系统
class CompatUtils {
  /// 根据不同的用户类型返回不同的dio实例
  static Dio getDio() {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        //环保和企业用户
        return PollutionDioUtils.instance.getDio();
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
  static setToken(Options options) {
    String accessToken = SpUtil.getString(Constant.spToken);
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        //环保和企业用户
        options.headers[Constant.requestHeaderTokenKey] = accessToken;
        break;
      case 2:
        // 运维用户
        options.headers[Constant.requestHeaderAuthorizationKey] =
            '$accessToken';
        break;
      default:
        throw Exception(
            '设置token失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型解析json中的token
  static String getResponseToken(Response response) {
    if (response == null)
      throw DioError(error: TokenException('刷新Token失败！response为空！'));
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        //环保和企业用户登录后去返回数据中取token
        if (response.statusCode == ExceptionHandle.success &&
            response.data[Constant.responseCodeKey] ==
                ExceptionHandle.success_code) {
          return response.data[Constant.responseDataKey]
              [Constant.responseTokenKey];
        }
        break;
      case 2:
        // 运维用户登录后去header中取token
        if (response.data[Constant.responseSuccessKey]) {
          return response.headers.map[Constant.requestHeaderauthorizationKey]
              [0];
        }
        break;
      default:
        throw Exception(
            '获取Token失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
    throw DioError(
        error: TokenException('获取Token失败！response=${response.toString()}'));
  }

  /// 根据不同的用户类型解析json中的realName
  static String getResponseRealName(Response response) {
    if (response == null)
      throw DioError(error: TokenException('获取RealName失败！response为空！'));
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        //环保和企业用户
        if (response.statusCode == ExceptionHandle.success &&
            response.data[Constant.responseCodeKey] ==
                ExceptionHandle.success_code) {
          return response.data[Constant.responseDataKey]
              [Constant.responseRealNameKey];
        }
        break;
      case 2:
        // 运维用户
        if (response.data[Constant.responseSuccessKey]) {
          return response.data[Constant.responsePrincipalKey]
              [Constant.responseChineseNameKey];
        }
        break;
      default:
        throw Exception(
            '获取RealName失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
    throw DioError(
        error: TokenException('获取RealName失败！response=${response.toString()}'));
  }

  /// 根据不同的用户类型解析json中的attentionLevel
  static String getResponseAttentionLevel(Response response) {
    if (response == null)
      throw DioError(error: TokenException('获取AttentionLevel失败！response为空！'));
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        //环保和企业用户
        if (response.statusCode == ExceptionHandle.success &&
            response.data[Constant.responseCodeKey] ==
                ExceptionHandle.success_code) {
          return response.data[Constant.responseDataKey]
              [Constant.responseAttentionLevelKey];
        }
        break;
      case 2:
        // 运维用户
        if (response.data[Constant.responseSuccessKey]) {
          // 运维用户的关注程度默认就是全部
          return '';
        }
        break;
      default:
        throw Exception(
            '获取AttentionLevel失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
    throw DioError(
        error: TokenException(
            '获取AttentionLevel失败！response=${response.toString()}'));
  }

  /// 用户登录时，根据不同用户类型解析response中的userId
  static getResponseUserId(response) {
    if (response == null)
      throw DioError(error: TokenException('获取UserId失败！response为空！'));
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        // 环保与企业用户
        if (response.statusCode == ExceptionHandle.success &&
            response.data[Constant.responseCodeKey] ==
                ExceptionHandle.success_code) {
          return response.data[Constant.responseDataKey]
              [Constant.responseIdKey];
        }
        break;
      case 2:
        // 运维用户
        if (response.data[Constant.responseSuccessKey]) {
          return response.data[Constant.responsePrincipalKey]
              [Constant.responseIdKey];
        }
        break;
      default:
        throw Exception(
            '获取userId失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
    throw DioError(
        error: TokenException('获取UserId失败！response=${response.toString()}'));
  }

  /// 根据不同的用户类型解析json中的data（有的数据最外层包了一层code，message，data）
  static dynamic getResponseData(Response response) {
    // 如果是List则直接返回
    if (response.data is List<dynamic>)
      return response.data;
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
      case 2:
        return response.data[Constant.responseDataKey];
      default:
        throw Exception(
            '获取数据失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型解析json中的message
  static dynamic getResponseMessage(Response response) {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        //环保和企业用户
        return response.data[Constant.responseMessageKey];
      case 2:
        if (response.data.containsKey(Constant.responseMsgKey))
          return response.data[Constant.responseMsgKey];
        else if (response.data.containsKey(Constant.responseMessageKey))
          return response.data[Constant.responseMessageKey];
        else
          return response.toString();
        break;
      default:
        throw Exception(
            '获取数据失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型解析json中list的json数组
  static dynamic getList(Map<String, dynamic> json) {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        // 环保和企业用户
        return json[Constant.responseListKey];
      case 2:
        // 运维用户
        return json[Constant.responseDataKey];
      default:
        throw Exception(
            '获取List失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型解析json中list的total
  static int getTotal(Map<String, dynamic> json) {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        // 环保和企业用户
        return json[Constant.responseTotalKey];
      case 2:
        // 运维用户
        return json[Constant.responseRecordsTotalKey];
      default:
        throw Exception(
            '获取Total失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型解析json中list的pageSize
  static int getPageSize(Map<String, dynamic> json) {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        // 环保和企业用户
        return json[Constant.responsePageSizeKey];
      case 2:
        // 运维用户
        return json[Constant.responseLengthKey];
      default:
        throw Exception(
            '获取PageSize失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型解析json中list的hasNextPage
  static bool getHasNextPage(Map<String, dynamic> json) {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        // 环保和企业用户
        return json[Constant.responseHasNextPageKey];
      case 2:
        return json[Constant.responseStartKey] +
                json[Constant.responseLengthKey] <
            json[Constant.responseRecordsTotalKey];
      default:
        throw Exception(
            '获取HasNextPage失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型解析json中list的currentPage
  static int getCurrentPage(Map<String, dynamic> json) {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        // 环保和企业用户
        return json[Constant.responsePageNumKey];
      case 2:
        // 运维用户（向下取整加1）
        return json[Constant.responseStartKey] ~/
                json[Constant.responseLengthKey] +
            1;
      default:
        throw Exception(
            '获取CurrentPage失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型获取对应的下载地址二维码
  static String getDownloadQRcode() {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        // 环保和企业用户
        return 'assets/images/image_pollution_download_QRcode.png';
      case 2:
        // 运维用户
        return 'assets/images/iamge_operation_download_QRcode.png';
      default:
        throw Exception(
            '获取下载地址二维码失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型获取对应的下载地址
  static String getDownloadUrl() {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        // 环保和企业用户
        return 'http://111.75.227.207:19551/dowload/pollution-source.apk';
      case 2:
        // 运维用户
        return 'http://111.75.227.207:19550/app/pollution-source.apk';
      default:
        throw Exception(
            '获取下载地址失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据不同的用户类型获取枚举对应的接口
  static String getApi(HttpApi httpApi) {
    switch (SpUtil.getInt(Constant.spUserType)) {
      case 0:
      case 1:
        //环保和企业用户
        return getPollutionApi(httpApi);
      case 2:
        //运维用户
        return getOperationApi(httpApi);
      default:
        throw Exception(
            '获取接口失败，未知的用户类型！userType=${SpUtil.getInt(Constant.spUserType)}');
    }
  }

  /// 根据传入的枚举类型返回对应的污染源接口
  static String getPollutionApi(httpApi) {
    switch (httpApi) {
      case HttpApi.adminIndex:
        return HttpApiPollution.adminIndex;
      case HttpApi.adminToken:
        return HttpApiPollution.adminToken;
      case HttpApi.enterToken:
        return HttpApiPollution.enterToken;
      case HttpApi.enterList:
        return HttpApiPollution.enterList;
      case HttpApi.attentionLevel:
        return HttpApiPollution.attentionLevel;
      case HttpApi.enterDetail:
        return HttpApiPollution.enterDetail;
      case HttpApi.dischargeList:
        return HttpApiPollution.dischargeList;
      case HttpApi.dischargeDetail:
        return HttpApiPollution.dischargeDetail;
      case HttpApi.outletType:
        return HttpApiPollution.outletType;
      case HttpApi.monitorList:
        return HttpApiPollution.monitorList;
      case HttpApi.monitorState:
        return HttpApiPollution.monitorState;
      case HttpApi.outType:
        return HttpApiPollution.outType;
      case HttpApi.monitorDetail:
        return HttpApiPollution.monitorDetail;
      case HttpApi.monitorHistoryData:
        return HttpApiPollution.monitorHistoryData;
      case HttpApi.monitorStatistics:
        return HttpApiPollution.monitorStatistics;
      case HttpApi.orderList:
        return HttpApiPollution.orderList;
      case HttpApi.orderState:
        return HttpApiPollution.orderState;
      case HttpApi.orderAlarmType:
        return HttpApiPollution.orderAlarmType;
      case HttpApi.orderAlarmLevel:
        return HttpApiPollution.orderAlarmLevel;
      case HttpApi.orderDetail:
        return HttpApiPollution.orderDetail;
      case HttpApi.orderAlarmCause:
        return HttpApiPollution.orderAlarmCause;
      case HttpApi.processesUpload:
        return HttpApiPollution.processesUpload;
      case HttpApi.dischargeReportList:
        return HttpApiPollution.dischargeReportList;
      case HttpApi.reportValid:
        return HttpApiPollution.reportValid;
      case HttpApi.dischargeReportDetail:
        return HttpApiPollution.dischargeReportDetail;
      case HttpApi.dischargeReportUpload:
        return HttpApiPollution.dischargeReportUpload;
      case HttpApi.factorReportList:
        return HttpApiPollution.factorReportList;
      case HttpApi.factorReportDetail:
        return HttpApiPollution.factorReportDetail;
      case HttpApi.factorReportUpload:
        return HttpApiPollution.factorReportUpload;
      case HttpApi.longStopReportList:
        return HttpApiPollution.longStopReportList;
      case HttpApi.longStopReportDetail:
        return HttpApiPollution.longStopReportDetail;
      case HttpApi.longStopReportUpload:
        return HttpApiPollution.longStopReportUpload;
      case HttpApi.licenseList:
        return HttpApiPollution.licenseList;
      case HttpApi.dischargeReportStopType:
        return HttpApiPollution.dischargeReportStopType;
      case HttpApi.factorReportAlarmType:
        return HttpApiPollution.factorReportAlarmType;
      case HttpApi.factorReportLimitDay:
        return HttpApiPollution.factorReportLimitDay;
      case HttpApi.factorReportFactorList:
        return HttpApiPollution.factorReportFactorList;
      case HttpApi.reportStopAdvanceTime:
        return HttpApiPollution.reportStopAdvanceTime;
      case HttpApi.routineInspectionList:
        return HttpApiPollution.routineInspectionList;
      case HttpApi.routineInspectionDetail:
        return HttpApiPollution.routineInspectionDetail;
      case HttpApi.routineInspectionUploadList:
        return HttpApiPollution.routineInspectionUploadList;
      case HttpApi.deviceInspectionUpload:
        return HttpApiPollution.deviceInspectionUpload;
      case HttpApi.airDeviceCheckUpload:
        return HttpApiPollution.airDeviceCheckUpload;
      case HttpApi.waterDeviceCheckUpload:
        return HttpApiPollution.waterDeviceCheckUpload;
      case HttpApi.airDeviceCorrectUpload:
        return HttpApiPollution.airDeviceCorrectUpload;
      case HttpApi.waterDeviceCorrectUpload:
        return HttpApiPollution.waterDeviceCorrectUpload;
      case HttpApi.deviceCorrectLastValue:
        return HttpApiPollution.deviceCorrectLastValue;
      case HttpApi.deviceParamUpload:
        return HttpApiPollution.deviceParamUpload;
      case HttpApi.deviceParamList:
        return HttpApiPollution.deviceParamList;
      case HttpApi.checkVersion:
        return HttpApiPollution.checkVersion;
      case HttpApi.changePassword:
        return HttpApiPollution.changePassword;
      case HttpApi.notificationList:
        return HttpApiPollution.notificationList;
      case HttpApi.mobileLawList:
        return HttpApiPollution.mobileLawList;
      case HttpApi.warnList:
        return HttpApiPollution.warnList;
      case HttpApi.warnDetail:
        return HttpApiPollution.warnDetail;
      case HttpApi.areaList:
        return HttpApiPollution.areaList;
      default:
        throw DioError(
            type: DioErrorType.DEFAULT,
            error: NotFoundException('HttpApiPollution中没有对应的接口'));
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
      case HttpApi.attentionLevel:
        return HttpApiOperation.attentionLevel;
      case HttpApi.enterDetail:
        return HttpApiOperation.enterDetail;
      case HttpApi.dischargeList:
        return HttpApiOperation.dischargeList;
      case HttpApi.dischargeDetail:
        return HttpApiOperation.dischargeDetail;
      case HttpApi.outletType:
        return HttpApiOperation.outletType;
      case HttpApi.monitorList:
        return HttpApiOperation.monitorList;
      case HttpApi.monitorState:
        return HttpApiOperation.monitorState;
      case HttpApi.outType:
        return HttpApiOperation.outType;
      case HttpApi.monitorDetail:
        return HttpApiOperation.monitorDetail;
      case HttpApi.monitorHistoryData:
        return HttpApiOperation.monitorHistoryData;
      case HttpApi.monitorStatistics:
        return HttpApiOperation.monitorStatistics;
      case HttpApi.orderList:
        return HttpApiOperation.orderList;
      case HttpApi.orderState:
        return HttpApiOperation.orderState;
      case HttpApi.orderAlarmType:
        return HttpApiOperation.orderAlarmType;
      case HttpApi.orderAlarmLevel:
        return HttpApiOperation.orderAlarmLevel;
      case HttpApi.orderDetail:
        return HttpApiOperation.orderDetail;
      case HttpApi.orderAlarmCause:
        return HttpApiOperation.orderAlarmCause;
      case HttpApi.processesUpload:
        return HttpApiOperation.processesUpload;
      case HttpApi.dischargeReportList:
        return HttpApiOperation.dischargeReportList;
      case HttpApi.reportValid:
        return HttpApiOperation.reportValid;
      case HttpApi.dischargeReportDetail:
        return HttpApiOperation.dischargeReportDetail;
      case HttpApi.dischargeReportUpload:
        return HttpApiOperation.dischargeReportUpload;
      case HttpApi.factorReportList:
        return HttpApiOperation.factorReportList;
      case HttpApi.factorReportDetail:
        return HttpApiOperation.factorReportDetail;
      case HttpApi.factorReportUpload:
        return HttpApiOperation.factorReportUpload;
      case HttpApi.licenseList:
        return HttpApiOperation.licenseList;
      case HttpApi.dischargeReportStopType:
        return HttpApiOperation.dischargeReportStopType;
      case HttpApi.factorReportAlarmType:
        return HttpApiOperation.factorReportAlarmType;
      case HttpApi.factorReportLimitDay:
        return HttpApiOperation.factorReportLimitDay;
      case HttpApi.factorReportFactorList:
        return HttpApiOperation.factorReportFactorList;
      case HttpApi.reportStopAdvanceTime:
        return HttpApiOperation.reportStopAdvanceTime;
      case HttpApi.routineInspectionList:
        return HttpApiOperation.routineInspectionList;
      case HttpApi.routineInspectionDetail:
        return HttpApiOperation.routineInspectionDetail;
      case HttpApi.routineInspectionUploadList:
        return HttpApiOperation.routineInspectionUploadList;
      case HttpApi.deviceInspectionUpload:
        return HttpApiOperation.deviceInspectionUpload;
      case HttpApi.airDeviceCheckUpload:
        return HttpApiOperation.airDeviceCheckUpload;
      case HttpApi.waterDeviceCheckUpload:
        return HttpApiOperation.waterDeviceCheckUpload;
      case HttpApi.airDeviceCorrectUpload:
        return HttpApiOperation.airDeviceCorrectUpload;
      case HttpApi.waterDeviceCorrectUpload:
        return HttpApiPollution.waterDeviceCorrectUpload;
      case HttpApi.deviceCorrectLastValue:
        return HttpApiOperation.deviceCorrectLastValue;
      case HttpApi.deviceParamUpload:
        return HttpApiOperation.deviceParamUpload;
      case HttpApi.deviceParamList:
        return HttpApiOperation.deviceParamList;
      case HttpApi.checkVersion:
        return HttpApiOperation.checkVersion;
      case HttpApi.changePassword:
        return HttpApiOperation.changePassword;
      case HttpApi.notificationList:
        return HttpApiOperation.notificationList;
      case HttpApi.mobileLawList:
        return HttpApiOperation.mobileLawList;
      case HttpApi.warnList:
        return HttpApiOperation.warnList;
      case HttpApi.warnDetail:
        return HttpApiOperation.warnDetail;
      default:
        throw DioError(
            type: DioErrorType.DEFAULT,
            error: NotFoundException('HttpApiOperation中没有对应的接口'));
    }
  }
}
