/// 网络请求接口枚举类
enum HttpApi {
  /// 管理员首页
  adminIndex,

  /// 运维首页
  operationIndex,

  /// 管理员登录
  adminToken,

  /// 企业登录
  enterToken,

  /// 运维登录
  operationToken,

  /// 企业列表
  enterList,

  /// 企业详情
  enterDetail,

  /// 排口列表
  dischargeList,

  /// 排口详情
  dischargeDetail,

  /// 监控点列表
  monitorList,

  /// 监控点详情
  monitorDetail,

  /// 报警管理单列表
  orderList,

  /// 报警管理单详情
  orderDetail,

  /// 报警管理单处理流程上报
  processesUpload,

  /// 排口异常申报列表
  dischargeReportList,

  /// 排口异常申报详情
  dischargeReportDetail,

  /// 排口异常申报上报
  dischargeReportUpload,

  /// 因子异常申报列表
  factorReportList,

  /// 因子异常申报详情
  factorReportDetail,

  /// 因子异常申报上报
  factorReportUpload,

  /// 长期停产列表
  longStopReportList,

  /// 长期停产详情
  longStopReportDetail,

  /// 长期停产上报
  longStopReportUpload,

  /// 排污许可证列表
  licenseList,

  /// 排污许可证详情
  licenseDetail,

  /// 排口异常申报停产类型列表
  dischargeReportStopTypeList,

  /// 因子异常申报异常类型列表
  factorReportAlarmTypeList,

  /// 因子异常申报因子列表
  factorReportFactorList,
}

class HttpApiJava {
  static const String adminIndex = 'appIndex/getIndexData';
  @deprecated
  static const String login = 'user/login';
  static const String adminToken = 'user/login';
  static const String enterToken = 'user/login';
  static const String enterList = 'enterprise/queryALLEnter';
  static const String enterDetail = 'enterprise/queryEnterByEntId?enter_id=';
  static const String dischargeList = 'tDisChargeOut/getDisChageOut';
  static const String dischargeDetail = 'tDisChargeOut/getDisChageOutById?dischargeId=';
  static const String monitorList = 'tDisChargeOut/getDrainInfo';
  static const String monitorDetail = 'tDisChargeOut/getDrainInfoById?monitorId=';
  static const String orderList = 'Supervise/getReadyRemindDataByStatus';
  static const String orderDetail = 'Supervise/querySuperviseDetailById?orderId=';
  static const String processesUpload = '暂无';
  static const String dischargeReportList = 'stopApply/getApplyList?dataType=S';
  static const String dischargeReportDetail =
      'stopApply/getStopApply?dataType=S&reportId=';
  static const String dischargeReportUpload = 'stopApply/addAbonrmalInfoS';
  static const String factorReportList = 'stopApply/getApplyList?dataType=A';
  static const String factorReportDetail =
      'stopApply/getStopApply?dataType=A&reportId=';
  static const String factorReportUpload = 'stopApply/addAbonrmalInfoA';
  static const String longStopReportList = 'stopApply/getApplyList?dataType=L';
  static const String longStopReportDetail =
      'stopApply/getStopApply?dataType=L&reportId=';
  static const String longStopReportUpload = 'stopApply/addAbonrmalInfoL';

  static const String licenseList = '暂无';
  static const String licenseDetail = 'enterprise/getLicenseInfoById';
  static const String dischargeReportStopTypeList = 'dictionary/getSubListByParent?dicCode=stopType';
  static const String factorReportAlarmTypeList = 'dictionary/getSubListByParent?dicCode=alarm_type';
  static const String factorReportFactorList = 'stopApply/getPollutionFactor?monitorType=outletType2';
}

class HttpApiPython {
  static const String adminIndex = 'index';
  @deprecated
  static const String token = 'token';
  static const String adminToken = 'admin/token';
  static const String enterToken = 'enter/token';
  static const String enterList = 'enters';
  static const String enterDetail = 'enters/';
  static const String dischargeList = 'discharges';
  static const String dischargeDetail = 'discharges/';
  static const String monitorList = 'monitors';
  static const String monitorDetail = 'monitors/';
  static const String orderList = 'orders';
  static const String orderDetail = 'orders/';
  static const String processesUpload = 'processes';
  static const String dischargeReportList = 'dischargeReports';
  static const String dischargeReportDetail = 'dischargeReports/';
  static const String dischargeReportUpload = 'dischargeReports';
  static const String factorReportList = 'factorReports';
  static const String factorReportDetail = 'factorReports/';
  static const String factorReportUpload = 'factorReports';
  static const String longStopReportList = 'longStopReports';
  static const String longStopReportDetail = 'longStopReports/';
  static const String longStopReportUpload = 'longStopReports';
  static const String licenseList = 'licenses';
  static const String licenseDetail = 'licenses/';
}

class HttpApiOperation {
  static const String operationToken = '暂无';
  static const String operationIndex = '暂无';
  static const String enterList = '暂无';
  static const String enterDetail = '暂无';
  static const String dischargeList = '暂无';
  static const String dischargeDetail = '暂无';
  static const String monitorList = '暂无';
  static const String monitorDetail = '暂无';
  static const String orderList = '暂无';
  static const String orderDetail = '暂无';
  static const String dischargeReportList = '暂无';
  static const String dischargeReportDetail = '暂无';
  static const String factorReportList = '暂无';
  static const String factorReportDetail = '暂无';
  static const String longStopReportList = '暂无';
  static const String longStopReportDetail = '暂无';
  static const String licenseList = '暂无';
  static const String licenseDetail = '暂无';
}
