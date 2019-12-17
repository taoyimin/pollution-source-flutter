class HttpApiJava{
  //首页接口
  static const String index = 'appIndex/getIndexData';
  //登录接口
  static const String login = 'user/login';
  //报警管理单列表
  static const String orderList = 'Supervise/getReadyRemindDataByStatus';
  //报警管理单详情
  static const String orderDetail = 'Supervise/queryAllFlowById';
  //异常申报单列表
  static const String reportList = 'stopApply/getApplyList';
  //异常申报单详情
  static const String reportDetail = 'stopApply/getStopApply';
  //企业列表
  static const String enterList = 'enterprise/queryALLEnter';
  //企业详情
  static const String enterDetail = 'enterprise/queryEnterByEntId';
  //排口列表
  static const String dischargeList = 'tDisChargeOut/getDisChageOut';
  //排口详情
  static const String dischargeDetail = 'tDisChargeOut/getDisChageOutById';
  //监控点列表
  static const String monitorList = 'tDisChargeOut/getDrainInfo';
  //监控点详情
  static const String monitorDetail = 'tDisChargeOut/getDrainInfoById';
  //排污许可证列表
  static const String licenseList = '排污许可证列表接口';
  //排污许可证详情
  static const String licenseDetail = 'enterprise/getLicenseInfoById';
}

class HttpApiPython{
  //首页
  static const String index = 'index';
  //token
  static const String token = 'token';
  //企业
  static const String enters = 'enters';
  //排口
  static const String discharges = 'discharges';
  //监控点
  static const String monitors = 'monitors';
  //报警管理单
  static const String orders = 'orders';
  //报警管理单处理流程
  static const String processes = 'processes';
  //异常申报单
  static const String reports = 'reports';
  //排口异常申报
  static const String dischargeReports = 'dischargeReports';
  //因子异常申报
  static const String factorReports = 'factorReports';
  //长期停产申报
  static const String longStopReports = 'longStopReports';
  //排污许可证
  static const String licenses = 'licenses';
}