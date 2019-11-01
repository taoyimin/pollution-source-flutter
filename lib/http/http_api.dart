class HttpApi{
  //首页接口
  static const String index = 'appIndex/getIndexData';
  //登录接口
  static const String login = 'user/login';
  //报警管理单列表
  static const String orderList = 'Supervise/getReadyRemindDataByStatus';
  //报警管理单详情 TODO
  static const String orderDetail = 'enterprise/queryALLEnter';
  //异常申报单列表
  static const String reportList = 'stopApply/getApplyList';
  //异常申报单详情
  static const String reportDetail = 'stopApply/getStopApply';
  //企业列表
  static const String enterList = 'enterprise/queryALLEnter';
  //企业详情 TODO
  static const String enterDetail = 'enterprise/queryALLEnter';
  //监控点列表
  static const String monitorList = 'tDisChargeOut/getDrainInfo';
  //监控点详情 TODO
  static const String monitorDetail = 'enterprise/queryALLEnter';
  //排污许可证详情
  static const String licenseDetail = 'enterprise/getLicenseInfoById';
}