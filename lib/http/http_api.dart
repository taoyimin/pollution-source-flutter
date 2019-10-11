class HttpApi{
  //首页接口
  static const String index = 'appIndex/getIndexData';
  //登录接口
  static const String login = 'user/login';
  //督办单列表
  static const String orderList = 'Supervise/getReadyRemindDataByStatus';
  //企业列表
  static const String enterList = 'Supervise/getReadyRemindDataByStatus?status=1';
  //监控点列表
  static const String monitorList = 'Supervise/getReadyRemindDataByStatus?status=1';
}