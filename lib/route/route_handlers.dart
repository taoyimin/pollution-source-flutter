import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/device/list/device_list_page.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_page.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_page.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_page.dart';
import 'package:pollution_source/module/enter/list/enter_list_page.dart';
import 'package:pollution_source/module/inspection/check/air/upload/air_device_check_upload_page.dart';
import 'package:pollution_source/module/inspection/check/water/upload/water_device_check_upload_page.dart';
import 'package:pollution_source/module/inspection/consumable/upload/consumable_replace_upload_page.dart';
import 'package:pollution_source/module/inspection/correct/air/upload/air_device_correct_upload_page.dart';
import 'package:pollution_source/module/inspection/correct/water/upload/water_device_correct_upload_page.dart';
import 'package:pollution_source/module/inspection/param/water/device/water_device_list_page.dart';
import 'package:pollution_source/module/inspection/param/water/upload/water_device_param_upload_page.dart';
import 'package:pollution_source/module/inspection/repair/upload/device_repair_upload_page.dart';
import 'package:pollution_source/module/inspection/routine/detail/routine_inspection_detail_page.dart';
import 'package:pollution_source/module/inspection/routine/detail/routine_inspection_detail_repository.dart';
import 'package:pollution_source/module/inspection/routine/list/routine_inspection_list_page.dart';
import 'package:pollution_source/module/inspection/standard/upload/standard_replace_upload_page.dart';
import 'package:pollution_source/module/license/list/license_list_page.dart';
import 'package:pollution_source/module/map/map_page.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_page.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_page.dart';
import 'package:pollution_source/module/monitor/table/monitor_table_page.dart';
import 'package:pollution_source/module/notice/list/notice_list_page.dart';
import 'package:pollution_source/module/order/detail/order_detail_page.dart';
import 'package:pollution_source/module/order/list/order_list_page.dart';
import 'package:pollution_source/module/report/discharge/detail/discharge_report_detail_page.dart';
import 'package:pollution_source/module/report/discharge/list/discharge_report_list_page.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_page.dart';
import 'package:pollution_source/module/report/factor/detail/factor_report_detail_page.dart';
import 'package:pollution_source/module/report/factor/list/factor_report_list_page.dart';
import 'package:pollution_source/module/report/factor/upload/factor_report_upload_page.dart';
import 'package:pollution_source/module/report/longstop/detail/long_stop_report_detail_page.dart';
import 'package:pollution_source/module/report/longstop/list/long_stop_report_list_page.dart';
import 'package:pollution_source/module/report/longstop/upload/long_stop_report_upload_page.dart';
import 'package:pollution_source/module/warn/detail/warn_detail_page.dart';
import 'package:pollution_source/module/warn/list/warn_list_page.dart';
import 'package:pollution_source/page/admin_home.dart';
import 'package:pollution_source/page/change_password_page.dart';
import 'package:pollution_source/page/enter_home.dart';
import 'package:pollution_source/page/operation_home.dart';
import 'package:pollution_source/page/share_product_page.dart';
import 'package:pollution_source/util/config_utils.dart';
import 'package:pollution_source/module/monitor/standard/emission_standard_page.dart';
import 'package:pollution_source/module/monitor/sampler/sampler_info_page.dart';

var rootHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ConfigUtils.getLoginPage();
  },
);

var adminHomeHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AdminHomePage();
  },
);

var enterHomeHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String enterId = params['id']?.first;
    return EnterHomePage(enterId: enterId);
  },
);

var operationHomeHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return OperationHomePage();
  },
);

var enterListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    bool automaticallyImplyLeading =
        params['automaticallyImplyLeading']?.first?.toLowerCase() ??
            'true' == 'true';
    String state = params['state']?.first ?? '';
    String enterType = params['enterType']?.first ?? '';
    String attentionLevel = params['attentionLevel']?.first ?? '';
    int type = int.parse(params['type']?.first ?? '0');
    return EnterListPage(
      automaticallyImplyLeading: automaticallyImplyLeading,
      state: state,
      enterType: enterType,
      attentionLevel: attentionLevel,
      type: type,
    );
  },
);

var enterDetailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String enterId = params['id']?.first;
    return EnterDetailPage(enterId: enterId);
  },
);

var dischargeListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String enterId = params['enterId']?.first ?? '';
    String state = params['state']?.first ?? '';
    int type = int.parse(params['type']?.first ?? '0');
    String dischargeType = params['dischargeType']?.first ?? '';
    String attentionLevel = params['attentionLevel']?.first ?? '';
    return DischargeListPage(
      enterId: enterId,
      state: state,
      type: type,
      dischargeType: dischargeType,
      attentionLevel: attentionLevel,
    );
  },
);

var dischargeDetailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String dischargeId = params['id']?.first;
    return DischargeDetailPage(dischargeId: dischargeId);
  },
);

var monitorListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String enterId = params['enterId']?.first ?? '';
    String dischargeId = params['dischargeId']?.first ?? '';
    int type = int.parse(params['type']?.first ?? '0');
    // 状态默认查询全部
    String state = params['state']?.first ?? 'all';
    String outType = params['outType']?.first ?? '';
    String monitorType = params['monitorType']?.first ?? '';
    String attentionLevel = params['attentionLevel']?.first ?? '';
    return MonitorListPage(
      enterId: enterId,
      dischargeId: dischargeId,
      type: type,
      state: state,
      outType: outType,
      monitorType: monitorType,
      attentionLevel: attentionLevel,
    );
  },
);

var monitorDetailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String monitorId = params['id']?.first;
    return MonitorDetailPage(monitorId: monitorId);
  },
);

var monitorHistoryDataHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String monitorId = params['monitorId']?.first;
    // 均值类型默认为小时数据
    String dataType = params['dataType']?.first ?? 'hour';
    DateTime startTime = TextUtil.isEmpty(params['startTime']?.first)
        ? null
        : DateUtil.getDateTime(params['startTime']?.first);
    DateTime endTime = TextUtil.isEmpty(params['endTime']?.first)
        ? null
        : DateUtil.getDateTime(params['endTime']?.first);
    return MonitorTablePage(
      monitorId: monitorId,
      dataType: dataType,
      startTime: startTime,
      endTime: endTime,
    );
  },
);

var deviceListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String monitorId = params['monitorId']?.first ?? '';
    int type = int.parse(params['type']?.first ?? '1');
    return DeviceListPage(
      monitorId: monitorId,
      type: type,
    );
  },
);

var orderListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    int type = int.parse(params['type']?.first ?? '0');
    String enterId = params['enterId']?.first ?? '';
    String monitorId = params['monitorId']?.first ?? '';
    String alarmState = params['alarmState']?.first ?? '';
    String alarmLevel = params['alarmLevel']?.first ?? '';
    String attentionLevel = params['attentionLevel']?.first ?? '';
    DateTime startTime = DateUtil.getDateTime(params['startTime']?.first ?? '');
    DateTime endTime = DateUtil.getDateTime(params['endTime']?.first ?? '');
    return OrderListPage(
      type: type,
      enterId: enterId,
      monitorId: monitorId,
      alarmState: alarmState,
      alarmLevel: alarmLevel,
      attentionLevel: attentionLevel,
      startTime: startTime,
      endTime: endTime,
    );
  },
);

var orderDetailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String orderId = params['id']?.first;
    int type = int.parse(params['type']?.first ?? '0');
    return OrderDetailPage(orderId: orderId, type: type);
  },
);

var dischargeReportListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String enterId = params['enterId']?.first ?? '';
    String dischargeId = params['dischargeId']?.first ?? '';
    String monitorId = params['monitorId']?.first ?? '';
    DateTime startTime = DateUtil.getDateTime(params['startTime']?.first ?? '');
    DateTime endTime = DateUtil.getDateTime(params['endTime']?.first ?? '');
    String state = params['state']?.first ?? '';
    String valid = params['valid']?.first ?? '';
    String attentionLevel = params['attentionLevel']?.first ?? '';
    return DischargeReportListPage(
      enterId: enterId,
      dischargeId: dischargeId,
      monitorId: monitorId,
      startTime: startTime,
      endTime: endTime,
      state: state,
      valid: valid,
      attentionLevel: attentionLevel,
    );
  },
);

var dischargeReportDetailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String reportId = params['id']?.first;
    return DischargeReportDetailPage(reportId: reportId);
  },
);

var factorReportListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String enterId = params['enterId']?.first ?? '';
    String dischargeId = params['dischargeId']?.first ?? '';
    String monitorId = params['monitorId']?.first ?? '';
    DateTime startTime = DateUtil.getDateTime(params['startTime']?.first ?? '');
    DateTime endTime = DateUtil.getDateTime(params['endTime']?.first ?? '');
    String state = params['state']?.first ?? '';
    String valid = params['valid']?.first ?? '';
    String attentionLevel = params['attentionLevel']?.first ?? '';
    return FactorReportListPage(
      enterId: enterId,
      dischargeId: dischargeId,
      monitorId: monitorId,
      startTime: startTime,
      endTime: endTime,
      state: state,
      valid: valid,
      attentionLevel: attentionLevel,
    );
  },
);

var factorReportDetailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String reportId = params['id']?.first;
    return FactorReportDetailPage(reportId: reportId);
  },
);

var longStopReportListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String enterId = params['enterId']?.first ?? '';
    DateTime startTime = DateUtil.getDateTime(params['startTime']?.first ?? '');
    DateTime endTime = DateUtil.getDateTime(params['endTime']?.first ?? '');
    String state = params['state']?.first ?? '';
    String valid = params['valid']?.first ?? '';
    String attentionLevel = params['attentionLevel']?.first ?? '';
    return LongStopReportListPage(
      enterId: enterId,
      startTime: startTime,
      endTime: endTime,
      state: state,
      valid: valid,
      attentionLevel: attentionLevel,
    );
  },
);

var longStopReportDetailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String reportId = params['id']?.first;
    return LongStopReportDetailPage(reportId: reportId);
  },
);

var dischargeReportUploadHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String enterId = params['enterId']?.first;
    return DischargeReportUploadPage(enterId: enterId);
  },
);

var factorReportUploadHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String enterId = params['enterId']?.first;
    return FactorReportUploadPage(enterId: enterId);
  },
);

var longStopReportUploadHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String enterId = params['enterId']?.first;
    return LongStopReportUploadPage(enterId: enterId);
  },
);

var licenseListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String enterId = params['enterId']?.first ?? '';
    return LicenseListPage(enterId: enterId);
  },
);

var routineInspectionListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String enterId = params['enterId']?.first ?? '';
    String monitorId = params['monitorId']?.first ?? '';
    String state = params['state']?.first ?? '';
    return RoutineInspectionListPage(
      enterId: enterId,
      monitorId: monitorId,
      state: state,
    );
  },
);

var routineInspectionDetailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String id = params['id']?.first;
    String monitorType = params['monitorType']?.first;
    String state = params['state']?.first ?? '';

    /// 使用全局Bloc，因为子页面中需要使用该Bloc刷新数据
    return BlocProvider<DetailBloc>(
      create: (BuildContext context) =>
          DetailBloc(detailRepository: RoutineInspectionDetailRepository()),
      child: RoutineInspectionDetailPage(
        monitorId: id,
        monitorType: monitorType,
        state: state,
      ),
    );
  },
);

var waterDeviceCheckUploadHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String json = params['json']?.first;
    return WaterDeviceCheckUploadPage(taskJson: json);
  },
);

var airDeviceCheckUploadHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String json = params['json']?.first;
    return AirDeviceCheckUploadPage(taskJson: json);
  },
);

var waterDeviceCorrectUploadHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String json = params['json']?.first;
    return WaterDeviceCorrectUploadPage(taskJson: json);
  },
);

var airDeviceCorrectUploadHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String json = params['json']?.first;
    return AirDeviceCorrectUploadPage(taskJson: json);
  },
);

var waterDeviceParamUploadHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return WaterDeviceParamUploadPage();
  },
);

var waterDeviceListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String monitorId = params['monitorId']?.first ?? '';
    int type = int.parse(params['type']?.first ?? '1');
    return WaterDeviceListPage(
      monitorId: monitorId,
      type: type,
    );
  },
);

var consumableReplaceUploadHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ConsumableReplaceUploadPage();
  },
);

var deviceRepairUploadHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return DeviceRepairUploadPage();
  },
);

var standardReplaceUploadHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return StandardReplaceUploadPage();
  },
);

var changePasswordHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ChangePasswordPage();
  },
);

var shareProductHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ShareProductPage();
  },
);

var noticeListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return NoticeListPage();
  },
);

var warnListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return WarnListPage();
  },
);

var warnDetailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String warnId = params['id']?.first;
    return WarnDetailPage(warnId: warnId);
  },
);

var mapHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return MapPage();
  },
);

var emissionStandardHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String monitorId = params['monitorId']?.first;
    String enterName = params['enterName']?.first;
    String monitorName = params['monitorName']?.first;
    return EmissionStandardPage(monitorId: monitorId, enterName: enterName, monitorName: monitorName);
  },
);

var samplerInfoHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String monitorId = params['monitorId']?.first;
    String enterName = params['enterName']?.first;
    String monitorName = params['monitorName']?.first;
    return SamplerInfoPage(monitorId: monitorId, enterName: enterName, monitorName: monitorName);
  },
);
