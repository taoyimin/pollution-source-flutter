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

  /// 关注程度数据字典
  attentionLevel,

  /// 企业详情
  enterDetail,

  /// 排口列表
  dischargeList,

  /// 排口详情
  dischargeDetail,

  /// 排口类型数据字典
  outletType,

  /// 监控点列表
  monitorList,

  /// 监控点状态数据字典
  monitorState,

  /// 排放类型数据字典
  outType,

  /// 监控点详情
  monitorDetail,

  /// 监控点历史数据
  monitorHistoryData,

  /// 监控点统计
  monitorStatistics,

  /// 报警管理单列表
  orderList,

  /// 报警管理单状态数据字典
  orderState,

  /// 报警管理单报警类型数据字典
  orderAlarmType,

  /// 报警管理单报警级别数据字典
  orderAlarmLevel,

  /// 报警管理单详情
  orderDetail,

  /// 报警管理单报警原因
  orderAlarmCause,

  /// 报警管理单处理流程上报
  processesUpload,

  /// 排口异常申报列表
  dischargeReportList,

  /// 异常申报是否生效数据字典
  reportValid,

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

  /// 排口异常申报停产类型数据字典
  dischargeReportStopType,

  /// 因子异常申报异常类型数据字典
  factorReportAlarmType,

  /// 因子异常申报异常类型为设备故障时限制时间
  factorReportLimitDay,

  /// 因子异常申报因子列表
  factorReportFactorList,

  /// 异常申报开始时间最多滞后的小时数
  reportStopAdvanceTime,

  /// 常规巡检列表
  routineInspectionList,

  /// 常规巡检详情
  routineInspectionDetail,

  /// 常规巡检上报列表
  routineInspectionUploadList,

  /// 辅助/监测设备巡检上报
  deviceInspectionUpload,

  /// 废水/废气监测设备校验上报
  deviceCheckUpload,

  /// 巡检上报查询设备的某个监测因子
  routineInspectionFactorDetail,

  /// 废气监测设备校准上报
  deviceCorrectUpload,

  /// 废气监测设备校准获取上次校准后测量值
  deviceCorrectLastValue,

  /// 废水监测设备参数巡检上报
  deviceParamUpload,

  /// 废水监测设备参数列表
  deviceParamList,

  /// 检查更新
  checkVersion,

  /// 修改密码
  changePassword,

  /// 消息通知列表
  notificationList,

  /// 移动执法列表
  mobileLawList,

  /// 实时预警单列表
  warnList,

  /// 实时预警单详情
  warnDetail,

  /// 获取区域列表
  areaList,
}

class HttpApiPollution {
  static const String adminToken = 'user/login';
  static const String enterToken = 'user/entpriseLogin';
  static const String adminIndex = 'appIndex/getIndexData';
  static const String enterList = 'enterprise/queryALLEnter';
  static const String attentionLevel =
      'dictionary/getSubListByParent?dicCode=attentionLevel';
  static const String enterDetail = 'enterprise/queryEnterByEntId?enter_id=';
  static const String dischargeList = 'tDisChargeOut/getDisChageOut';
  static const String dischargeDetail =
      'tDisChargeOut/getDisChageOutById?dischargeId=';
  static const String outletType =
      'dictionary/getSubListByParent?dicCode=outletType';
  static const String monitorList = 'tDisChargeOut/getDrainInfo';
  static const String monitorState =
      'dictionary/getSubListByParent?dicCode=monitorRealData';
  static const String outType = 'dictionary/getSubListByParent?dicCode=outType';
  static const String monitorDetail =
      'tDisChargeOut/getDrainInfoById?monitorId=';
  static const String monitorHistoryData = 'monitorRealData/queryDetailHistory';
  static const String monitorStatistics = 'appIndex/getMonitorStatistics';
  static const String orderList = 'Supervise/getReadyRemindDataByStatus';
  static const String orderState =
      'dictionary/getSubListByParent?dicCode=orderStatus';
  static const String orderAlarmType =
      'dictionary/getSubListByParent?dicCode=alarm_type';
  static const String orderAlarmLevel =
      'dictionary/getSubListByParent?dicCode=alarmLevel';
  static const String orderDetail =
      'Supervise/querySuperviseDetailById?id=';
  static const String orderAlarmCause =
      'dictionary/getSubListByParent?dicCode=alarm_cause';
  static const String processesUpload = 'Supervise/dealSupervise';
  static const String dischargeReportList = 'stopApply/getApplyList';
  static const String reportValid =
      'dictionary/getSubListByParent?dicCode=isEffect';
  static const String dischargeReportDetail =
      'stopApply/getStopApply?dataType=S&reportId=';
  static const String dischargeReportUpload = 'stopApply/addAbonrmalInfoS';
  static const String factorReportList = 'stopApply/getApplyList';
  static const String factorReportDetail =
      'stopApply/getStopApply?dataType=A&reportId=';
  static const String factorReportUpload = 'stopApply/addAbonrmalInfoA';
  static const String longStopReportList = 'stopApply/getApplyList';
  static const String longStopReportDetail =
      'stopApply/getStopApply?dataType=L&reportId=';
  static const String longStopReportUpload = 'stopApply/addAbonrmalInfoL';
  static const String licenseList = 'enterprise/getLicenseInfoById';
  static const String dischargeReportStopType =
      'dictionary/getSubListByParent?dicCode=stopType';
  static const String factorReportAlarmType =
      'dictionary/getSubListByParent?dicCode=alarm_type_abnormal';
  static const String factorReportLimitDay =
      'dictionary/getSysDictionary?dicCode=limitDay';
  static const String factorReportFactorList = 'stopApply/getPollutionFactor';
  static const String reportStopAdvanceTime =
      'dictionary/getSysDictionary?dicCode=StopAdvanceTime';
  static const String checkVersion = 'update/update.json';
  static const String changePassword = 'user/changePwd';
  static const String notificationList = 'pushMessage/getPushMessageHistory';
  static const String mobileLawList = 'Supervise/getEnforcementsById';
  static const String warnList = 'pushMessage/realWarnList';
  static const String warnDetail = 'pushMessage/getRealWarnById?id=';
  static const String areaList = 'tree/getAreaList';
}

class HttpApiOperation {
  static const String operationToken = 'login';
  static const String operationIndex = 'ywmh/tInspectionTask/indexCount';
  static const String enterList = 'ycyd/enterpriseBas/api/enters';
  static const String attentionLevel =
      'dictionary/getSubListAPI?dicCode=attentionLevel';
  static const String enterDetail = 'ycyd/enterpriseBas/api/enters/';
  static const String dischargeList = 'ycyd/disChargeInfo/api/discharges';
  static const String dischargeDetail =
      'ycyd/disChargeInfo/api/getDisChageOutById?dischargeId=';
  static const String outletType =
      'dictionary/getSubListAPI?dicCode=outletType';
  static const String monitorList =
      'ycyd/disChargeMonitorYcyd/api/getDrainInfo';
  static const String monitorState =
      'dictionary/getSubListAPI?dicCode=monitorRealData';
  static const String outType = 'dictionary/getSubListAPI?dicCode=outType';
  static const String monitorDetail =
      'ycyd/disChargeMonitorYcyd/api/getDrainInfoById?monitorId=';
  static const String monitorHistoryData =
      'pollutantsource/tMonitorRealDataView/queryDetailHistoryAPI';
  static const String monitorStatistics =
      'statistics/queryMonitorRealDataCountByCondition';
  static const String orderList = 'commonSupervise/list';
  static const String orderState =
      'dictionary/getSubListAPI?dicCode=orderStatus';
  static const String orderAlarmType =
      'dictionary/getSubListAPI?dicCode=alarm_type';
  static const String orderAlarmLevel =
      'dictionary/getSubListAPI?dicCode=alarmLevel';
  static const String orderDetail =
      'commonSupervise/querySuperviseDetailByIdAPI?id=';
  static const String orderAlarmCause =
      'dictionary/getSubListAPI?dicCode=alarm_cause';
  static const String processesUpload = 'commonSupervise/dealSuperviseAPI';
  static const String dischargeReportList =
      'pollutantsource/stopApply/queryPage';
  static const String reportValid = 'dictionary/getSubListAPI?dicCode=isEffect';
  static const String dischargeReportDetail =
      'pollutantsource/stopApply/getDetailApi?stopApplyId=';
  static const String dischargeReportUpload =
      'pollutantsource/stopApply/addStopApply';
  static const String factorReportList = 'archives/abnormalApply/list';
  static const String factorReportDetail =
      'archives/abnormalApply/detailInterAPI?id=';
  static const String factorReportUpload =
      'archives/abnormalApply/addAbonrmalAPI';
  static const String licenseList = 'ycyd/enterpriseBas/getLicenseInfoById';
  static const String dischargeReportStopType =
      'dictionary/getSubListAPI?dicCode=stopType';
  static const String factorReportAlarmType =
      'dictionary/getSubListAPI?dicCode=alarm_type_abnormal';
  static const String factorReportLimitDay =
      'dictionary/getSysDictionary?dicCode=limitDay';
  static const String factorReportFactorList =
      'archives/abnormalApply/selectFactorCodeByMonitorId';
  static const String reportStopAdvanceTime =
      'dictionary/getSysDictionary?dicCode=StopAdvanceTime';
  static const String routineInspectionList =
      'ywmh/tInspectionTask/queryStatTasksPage';
  static const String routineInspectionDetail =
      'ywmh/tInspectionTask/selectTaskCount';
  static const String routineInspectionUploadList =
      'ywmh/tInspectionTask/doMonitorTasksForJson';
  static const String deviceInspectionUpload = 'ywmh/tInspectionTask/submit';
  static const String deviceCheckUpload =
      'ywmh/tInspectionTask/submitGasOrWatCheckAPI';
  static const String routineInspectionFactorDetail =
      'ywmh/tInspectionTask/selectMonitorPoint';
  static const String deviceCorrectUpload =
      'ywmh/tInspectionTask/submitGasCmesCorrect';
  static const String deviceCorrectLastValue =
      'ywmh/tInspectionGasCmesCorrectRecord/selectPreviousByinspectionTaskId?inspectionTaskId=';
  static const String deviceParamUpload =
      'ywmh/tInspectionTask/submitWatParameter';
  static const String deviceParamList =
      'ywmh/tInspectionTask/selectThreeListByParent?dic_code=watParameterSet';
  static const String checkVersion = 'app/update.json';
  static const String changePassword = 'ywyh/updatePassword';
  static const String notificationList = 'pushMessage/getPushMessageHistory';
  static const String mobileLawList = '暂无';
  static const String warnList = 'pushMessage/realWarnList';
  static const String warnDetail = 'pushMessage/getRealWarnById?id=';
}
