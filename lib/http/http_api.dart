class HttpApi{
  //首页接口
  static const String index = 'appIndex/getIndexData';
  //登录接口
  static const String login = 'user/login';
  //报警管理单列表
  static const String orderList = 'Supervise/getReadyRemindDataByStatus';
  //报警管理单详情
  static const String orderDetail = '报警管理单详情接口';
  //异常申报单列表
  static const String reportList = 'stopApply/getApplyList';
  //异常申报单详情
  static const String reportDetail = 'stopApply/getStopApply';
  //企业列表
  static const String enterList = 'enterprise/queryALLEnter';
  //企业详情
  static const String enterDetail = 'enterprise/queryEnterByEntId';
  //排口列表
  static const String dischargeList = '排口列表接口';
  //监控点列表
  static const String monitorList = 'tDisChargeOut/getDrainInfo';
  //排口详情
  static const String dischargeDetail = '排口详情接口';
  //监控点详情
  static const String monitorDetail = '监控点详情接口';
  //排污许可证详情
  static const String licenseDetail = 'enterprise/getLicenseInfoById';
}