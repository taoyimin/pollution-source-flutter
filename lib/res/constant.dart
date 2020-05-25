import 'package:pollution_source/http/http_api.dart';

/// 常量类
class Constant {
  /// debug开关，上线需要关闭
  /// App运行在Release环境时，inProduction为true；
  /// 当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction =
      const bool.fromEnvironment("dart.vm.product");

  /// ****************app的一些默认配置***************

  /// 请求列表时默认页数
  static const int defaultCurrentPage = 1;

  /// 请求列表时默认每页数据量
  static const int defaultPageSize = 20;

  /// 异常申报开始时间允许的滞后小时数
  static const int defaultStopAdvanceTime = 48;

  /// 推送用TAG标签
  static const List<String> userTags = ['hb', 'qy', 'yw'];

  /// ****************网络请求用的key***************
  /// 污染源接口header中token的key
  static const String requestHeaderTokenKey = 'token';

  /// 运维接口header中token的key
  static const String requestHeaderAuthorizationKey = 'Authorization';

  /// 运维登录接口中取token的key
  static const String requestHeaderauthorizationKey = 'authorization';

  /// ****************解析接口数据用的key***************

  /// 解析返回数据用的key
  static const String responseCodeKey = 'code';
  static const String responseMessageKey = 'message';
  static const String responseMsgKey = 'msg';
  static const String responseSuccessKey = 'success';
  static const String responseDataKey = 'data';
  static const String responseIdKey = 'id';
  static const String responseEnterIdKey = 'enterId';
  static const String responsePrincipalKey = 'principal';

  /// 解析list用的key
  static const String responseListKey = 'list';
  static const String responseTotalKey = 'total';
  static const String responsePageSizeKey = 'pageSize';

  /// 解析污染源后台返回的list用这个key
  static const String responsePageNumKey = 'pageNum';
  static const String responseHasNextPageKey = 'hasNextPage';

  /// 解析运维后台返回的list用这个key
  static const String responseRecordsTotalKey = 'recordsTotal';
  static const String responseStartKey = 'start';
  static const String responseLengthKey = 'length';

  /// 解析返回数据中token用的key
  static const String responseTokenKey = 'token';

  /// 解析污染源返回数据中realName用的key
  static const String responseRealNameKey = 'realName';

  /// 解析运维返回数据中realName用的key
  static const String responseChineseNameKey = 'chineseName';

  /// 解析返回数据中attentionLevel用的key
  static const String responseAttentionLevelKey = 'attentionLevel';

  /// *********SharedPreferences存取数据用的key*********

  /// 是否开启debug模式
  static const String spDebug = 'debug';

  /// 存取环保用户登录用户名的key
  static const String spAdminUsername = 'adminUsername';

  /// 存取环保用户登录密码的key
  static const String spAdminPassword = 'adminPassword';

  /// 存取企业用户登录用户名的key
  static const String spEnterUsername = 'enterUsername';

  /// 存取企业用户登录密码的key
  static const String spEnterPassword = 'enterPassword';

  /// 存取运维用户登录用户名的key
  static const String spOperationUsername = 'operationUsername';

  /// 存取运维用户登录密码的key
  static const String spOperationPassword = 'operationPassword';

  /// 当前登陆用户的真实姓名
  static const String spRealName = 'realName';

  /// 当前登录用户的关注程度
  static const String spAttentionLevel = 'attentionLevel';

  /// 登录时间
  static const String spLoginTime = 'loginTime';

  /// 存取登录用户类型的key
  static const String spUserType = 'userType';

  /// 存取用户的id
  static const String spUserId = 'userId';

  /// 存取登录用户token的key
  static const String spToken = 'token';

  /// 存取在线数据图表是否为曲线的key
  static const String spIsCurved = 'isCurved';

  /// 存取在线数据图表是否显示数据点的key
  static const String spShowDotData = 'showDotData';

  /// 申请通知权限是否不再提示
  static const String spNotificationNoLonger = 'spNotificationNoLonger';

  /// 设别别名
  static const String spAlias = 'spAlias';

  /// 历史数据列表是否显示接收时间
  static const String spShowReceiveTime = 'showReceiveTime';

  /// 登录接口集合
  static const List<HttpApi> loginApis = [
    HttpApi.adminToken,
    HttpApi.enterToken,
    HttpApi.operationToken
  ];

  /// 登录用户名key集合
  static const List<String> spUsernameList = [
    Constant.spAdminUsername,
    Constant.spEnterUsername,
    Constant.spOperationUsername
  ];

  /// 登录密码key集合
  static const List<String> spPasswordList = [
    Constant.spAdminPassword,
    Constant.spEnterPassword,
    Constant.spOperationPassword
  ];

  /// *********环保用户首页取数据用的key*********

  /// aqi统计
  static const String aqiStatisticsKey = '10';

  /// pm2.5考核
  static const String pm25ExamineKey = '20';

  /// api考核
  static const String aqiExamineKey = '21';

  /// 国控断面地表水统计
  static const String stateWaterKey = '30';

  /// 省控断面地表水统计
  static const String provinceWaterKey = '31';

  /// 市控断面地表水统计
  static const String countyWaterKey = '32';

  /// 饮用水断面地表水统计
  static const String waterWaterKey = '33';

  /// 金属断面地表水统计
  static const String metalWaterKey = '34';

  /// 污染源企业概况
  static const String pollutionEnterStatisticsKey = '40';

  /// 雨水企业概况
  static const String rainEnterStatisticsKey = '50';

  /// 综合统计信息
  static const String comprehensiveStatisticsKey = '60';

  /// 在线监控点概况
  static const String onlineMonitorStatisticsKey = '70';

  /// 报警管理单统计
  static const String todoTaskStatisticsKey = '90';

  /// 异常申报统计
  static const String reportStatisticsKey = '100';
}

const Map<String, String> provincesData = {
  "360000": "江西省",
};

const Map<String, dynamic> citiesData = {
  "360000": {
    "360100": {"name": "南昌市"},
    "360200": {"name": "赣州市"},
    "360300": {"name": "九江市"}
  },
  "360100": {
    "360101": {"name": "东湖区"},
    "360102": {"name": "西湖区"},
    "360103": {"name": "新建区"}
  },
  "360200": {
    "360201": {"name": "大余县"}
  },
  "360300": {
    "360301": {"name": "武宁县"},
    "360302": {"name": "都昌县"},
    "360303": {"name": "修水县"}
  }
};
