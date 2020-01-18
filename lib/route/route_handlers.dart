import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/list/list_bloc.dart';
import 'package:pollution_source/module/common/page/page_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_page.dart';
import 'package:pollution_source/module/discharge/detail/discharge_detail_repository.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_page.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_repository.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_page.dart';
import 'package:pollution_source/module/enter/detail/enter_detail_repository.dart';
import 'package:pollution_source/module/enter/list/enter_list_page.dart';
import 'package:pollution_source/module/enter/list/enter_list_repository.dart';
import 'package:pollution_source/module/inspection/check/air/upload/air_device_check_upload_page.dart';
import 'package:pollution_source/module/inspection/check/air/upload/air_device_check_upload_repository.dart';
import 'package:pollution_source/module/inspection/check/water/upload/water_device_check_upload_page.dart';
import 'package:pollution_source/module/inspection/check/water/upload/water_device_check_upload_repository.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_factor_repository.dart';
import 'package:pollution_source/module/inspection/common/water_device_param_list_repository.dart';
import 'package:pollution_source/module/inspection/correct/air/upload/air_device_correct_upload_page.dart';
import 'package:pollution_source/module/inspection/correct/air/upload/air_device_correct_upload_repository.dart';
import 'package:pollution_source/module/inspection/param/water/upload/water_device_param_upload_page.dart';
import 'package:pollution_source/module/inspection/param/water/upload/water_device_param_upload_repository.dart';
import 'package:pollution_source/module/inspection/routine/detail/routine_inspection_detail_page.dart';
import 'package:pollution_source/module/inspection/routine/detail/routine_inspection_detail_repository.dart';
import 'package:pollution_source/module/inspection/routine/list/routine_inspection_list_page.dart';
import 'package:pollution_source/module/inspection/routine/list/routine_inspection_list_repository.dart';
import 'package:pollution_source/module/license/list/license_list_page.dart';
import 'package:pollution_source/module/license/list/license_list_repository.dart';
import 'package:pollution_source/module/login/login_page.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_bloc.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_page.dart';
import 'package:pollution_source/module/monitor/detail/monitor_detail_repository.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_page.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_repository.dart';
import 'package:pollution_source/module/monitor/table/monitor_table_page.dart';
import 'package:pollution_source/module/monitor/table/monitor_table_repository.dart';
import 'package:pollution_source/module/order/detail/order_detail_page.dart';
import 'package:pollution_source/module/order/detail/order_detail_repository.dart';
import 'package:pollution_source/module/order/list/order_list_page.dart';
import 'package:pollution_source/module/order/list/order_list_repository.dart';
import 'package:pollution_source/module/process/upload/process_upload_repository.dart';
import 'package:pollution_source/module/report/discharge/detail/discharge_report_detail_page.dart';
import 'package:pollution_source/module/report/discharge/detail/discharge_report_detail_repository.dart';
import 'package:pollution_source/module/report/discharge/list/discharge_report_list_page.dart';
import 'package:pollution_source/module/report/discharge/list/discharge_report_list_repository.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_page.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_repository.dart';
import 'package:pollution_source/module/report/factor/detail/factor_report_detail_page.dart';
import 'package:pollution_source/module/report/factor/detail/factor_report_detail_repository.dart';
import 'package:pollution_source/module/report/factor/list/factor_report_list_page.dart';
import 'package:pollution_source/module/report/factor/list/factor_report_list_repository.dart';
import 'package:pollution_source/module/report/factor/upload/factor_report_upload_page.dart';
import 'package:pollution_source/module/report/factor/upload/factor_report_upload_repository.dart';
import 'package:pollution_source/module/report/longstop/detail/long_stop_report_detail_page.dart';
import 'package:pollution_source/module/report/longstop/detail/long_stop_report_detail_repository.dart';
import 'package:pollution_source/module/report/longstop/list/long_stop_report_list_page.dart';
import 'package:pollution_source/module/report/longstop/list/long_stop_report_list_repository.dart';
import 'package:pollution_source/module/report/longstop/upload/long_stop_report_upload_page.dart';
import 'package:pollution_source/module/report/longstop/upload/long_stop_report_upload_repository.dart';
import 'package:pollution_source/page/admin_home.dart';
import 'package:pollution_source/page/enter_home.dart';
import 'package:pollution_source/page/operation_home.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage();
});

var adminHomeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AdminHomePage();
});

var enterHomeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['id']?.first;
  return EnterHomePage(enterId: enterId);
});

var operationHomeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return OperationHomePage();
});

var enterListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  bool automaticallyImplyLeading =
      params['automaticallyImplyLeading']?.first?.toLowerCase() ??
          'true' == 'true';
  String state = params['state']?.first ?? '';
  String enterType = params['enterType']?.first ?? '';
  String attentionLevel = params['attentionLevel']?.first ?? '';
  int type = int.parse(params['type']?.first ?? '0');
  return BlocProvider<ListBloc>(
    create: (BuildContext context) =>
        ListBloc(listRepository: EnterListRepository()),
    child: EnterListPage(
      automaticallyImplyLeading: automaticallyImplyLeading,
      state: state,
      enterType: enterType,
      attentionLevel: attentionLevel,
      type: type,
    ),
  );
});

var enterDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['id']?.first;
  return BlocProvider<DetailBloc>(
    create: (BuildContext context) =>
        DetailBloc(detailRepository: EnterDetailRepository()),
    child: EnterDetailPage(enterId: enterId),
  );
});

var dischargeListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['enterId']?.first ?? '';
  String state = params['state']?.first ?? '';
  int type = int.parse(params['type']?.first ?? '0');
  String dischargeType = params['dischargeType']?.first ?? '';
  return BlocProvider<ListBloc>(
    create: (BuildContext context) =>
        ListBloc(listRepository: DischargeListRepository()),
    child: DischargeListPage(
      enterId: enterId,
      state: state,
      type: type,
      dischargeType: dischargeType,
    ),
  );
});

var dischargeDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String dischargeId = params['id']?.first;
  return BlocProvider<DetailBloc>(
    create: (BuildContext context) =>
        DetailBloc(detailRepository: DischargeDetailRepository()),
    child: DischargeDetailPage(dischargeId: dischargeId),
  );
});

var monitorListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['enterId']?.first ?? '';
  String dischargeId = params['dischargeId']?.first ?? '';
  int type = int.parse(params['type']?.first ?? '0');
  String state = params['state']?.first ?? '';
  String monitorType = params['monitorType']?.first ?? '';
  return BlocProvider<ListBloc>(
    create: (BuildContext context) =>
        ListBloc(listRepository: MonitorListRepository()),
    child: MonitorListPage(
      enterId: enterId,
      dischargeId: dischargeId,
      type: type,
      state: state,
      monitorType: monitorType,
    ),
  );
});

var monitorDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String monitorId = params['id']?.first;
  return BlocProvider<MonitorDetailBloc>(
    create: (BuildContext context) =>
        MonitorDetailBloc(detailRepository: MonitorDetailRepository()),
    child: MonitorDetailPage(monitorId: monitorId),
  );
});

var monitorHistoryDataHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String monitorId = params['monitorId']?.first;
  return BlocProvider<DetailBloc>(
    create: (BuildContext context) =>
        DetailBloc(detailRepository: MonitorHistoryDataRepository()),
    child: MonitorTablePage(monitorId: monitorId),
  );
});

var orderListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['enterId']?.first ?? '';
  String monitorId = params['monitorId']?.first ?? '';
  String state = params['state']?.first ?? '';
  return BlocProvider<ListBloc>(
    create: (BuildContext context) =>
        ListBloc(listRepository: OrderListRepository()),
    child: OrderListPage(
      enterId: enterId,
      monitorId: monitorId,
      state: state,
    ),
  );
});

var orderDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String orderId = params['id']?.first;
  return MultiBlocProvider(
    providers: [
      BlocProvider<UploadBloc>(
        create: (BuildContext context) =>
            UploadBloc(uploadRepository: ProcessUploadRepository()),
      ),
      BlocProvider<DetailBloc>(
        create: (BuildContext context) =>
            DetailBloc(detailRepository: OrderDetailRepository()),
      ),
    ],
    child: OrderDetailPage2(orderId: orderId),
  );
});

var dischargeReportListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['enterId']?.first ?? '';
  String dischargeId = params['dischargeId']?.first ?? '';
  String monitorId = params['monitorId']?.first ?? '';
  String state = params['state']?.first ?? '';
  return BlocProvider<ListBloc>(
    create: (BuildContext context) =>
        ListBloc(listRepository: DischargeReportListRepository()),
    child: DischargeReportListPage(
      enterId: enterId,
      dischargeId: dischargeId,
      monitorId: monitorId,
      state: state,
    ),
  );
});

var dischargeReportDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reportId = params['id']?.first;
  return BlocProvider<DetailBloc>(
    create: (BuildContext context) =>
        DetailBloc(detailRepository: DischargeReportDetailRepository()),
    child: DischargeReportDetailPage(reportId: reportId),
  );
});

var factorReportListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['enterId']?.first ?? '';
  String dischargeId = params['dischargeId']?.first ?? '';
  String monitorId = params['monitorId']?.first ?? '';
  String state = params['state']?.first ?? '';
  return BlocProvider<ListBloc>(
    create: (BuildContext context) =>
        ListBloc(listRepository: FactorReportListRepository()),
    child: FactorReportListPage(
      enterId: enterId,
      dischargeId: dischargeId,
      monitorId: monitorId,
      state: state,
    ),
  );
});

var factorReportDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reportId = params['id']?.first;
  return BlocProvider<DetailBloc>(
    create: (BuildContext context) =>
        DetailBloc(detailRepository: FactorReportDetailRepository()),
    child: FactorReportDetailPage(reportId: reportId),
  );
});

var longStopReportListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['enterId']?.first ?? '';
  String state = params['state']?.first ?? '';
  return BlocProvider<ListBloc>(
    create: (BuildContext context) =>
        ListBloc(listRepository: LongStopReportListRepository()),
    child: LongStopReportListPage(
      enterId: enterId,
      state: state,
    ),
  );
});

var longStopReportDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String reportId = params['id']?.first;
  return BlocProvider<DetailBloc>(
    create: (BuildContext context) =>
        DetailBloc(detailRepository: LongStopReportDetailRepository()),
    child: LongStopReportDetailPage(reportId: reportId),
  );
});

var dischargeReportUploadHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['enterId']?.first;
  return MultiBlocProvider(
    providers: [
      BlocProvider<UploadBloc>(
        create: (BuildContext context) =>
            UploadBloc(uploadRepository: DischargeReportUploadRepository()),
      ),
      BlocProvider<PageBloc>(
        create: (BuildContext context) => PageBloc(),
      ),
    ],
    child: DischargeReportUploadPage(enterId: enterId),
  );
});

var factorReportUploadHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['enterId']?.first;
  return MultiBlocProvider(
    providers: [
      BlocProvider<UploadBloc>(
        create: (BuildContext context) =>
            UploadBloc(uploadRepository: FactorReportUploadRepository()),
      ),
      BlocProvider<PageBloc>(
        create: (BuildContext context) => PageBloc(),
      ),
    ],
    child: FactorReportUploadPage(enterId: enterId),
  );
});

var longStopReportUploadHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['enterId']?.first;
  return MultiBlocProvider(
    providers: [
      BlocProvider<UploadBloc>(
        create: (BuildContext context) =>
            UploadBloc(uploadRepository: LongStopReportUploadRepository()),
      ),
      BlocProvider<PageBloc>(
        create: (BuildContext context) => PageBloc(),
      ),
    ],
    child: LongStopReportUploadPage(enterId: enterId),
  );
});

var licenseListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['enterId']?.first ?? '';
  return BlocProvider<ListBloc>(
    create: (BuildContext context) =>
        ListBloc(listRepository: LicenseListRepository()),
    child: LicenseListPage(
      enterId: enterId,
    ),
  );
});

var routineInspectionListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params['enterId']?.first ?? '';
  String monitorId = params['monitorId']?.first ?? '';
  String state = params['state']?.first ?? '';
  return BlocProvider<ListBloc>(
    create: (BuildContext context) =>
        ListBloc(listRepository: RoutineInspectionListRepository()),
    child: RoutineInspectionListPage(
      enterId: enterId,
      monitorId: monitorId,
      state: state,
    ),
  );
});

var routineInspectionDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id']?.first;
  String monitorType = params['monitorType']?.first;
  return BlocProvider<DetailBloc>(
    create: (BuildContext context) =>
        DetailBloc(detailRepository: RoutineInspectionDetailRepository()),
    child: RoutineInspectionDetailPage(
      monitorId: id,
      monitorType: monitorType,
    ),
  );
});

var waterDeviceCheckUploadHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String json = params['json']?.first;
  return MultiBlocProvider(
    providers: [
      BlocProvider<UploadBloc>(
        create: (BuildContext context) =>
            UploadBloc(uploadRepository: WaterDeviceUploadRepository()),
      ),
      BlocProvider<PageBloc>(
        create: (BuildContext context) => PageBloc(),
      ),
    ],
    child: WaterDeviceCheckUploadPage(
      json: json,
    ),
  );
});

var airDeviceCheckUploadHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String json = params['json']?.first;
  return MultiBlocProvider(
    providers: [
      BlocProvider<UploadBloc>(
        create: (BuildContext context) =>
            UploadBloc(uploadRepository: AirDeviceCheckUploadRepository()),
      ),
      BlocProvider<DetailBloc>(
        create: (BuildContext context) => DetailBloc(
            detailRepository: RoutineInspectionUploadFactorRepository()),
      ),
      BlocProvider<PageBloc>(
        create: (BuildContext context) => PageBloc(),
      ),
    ],
    child: AirDeviceCheckUploadPage(
      json: json,
    ),
  );
});

var airDeviceCorrectUploadHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String json = params['json']?.first;
  return MultiBlocProvider(
    providers: [
      BlocProvider<UploadBloc>(
        create: (BuildContext context) =>
            UploadBloc(uploadRepository: AirDeviceCorrectUploadRepository()),
      ),
      BlocProvider<DetailBloc>(
        create: (BuildContext context) => DetailBloc(
            detailRepository: RoutineInspectionUploadFactorRepository()),
      ),
      BlocProvider<PageBloc>(
        create: (BuildContext context) => PageBloc(),
      ),
    ],
    child: AirDeviceCorrectUploadPage(
      json: json,
    ),
  );
});

var waterDeviceParamUploadHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String json = params['json']?.first;
  return MultiBlocProvider(
    providers: [
      BlocProvider<UploadBloc>(
        create: (BuildContext context) =>
            UploadBloc(uploadRepository: WaterDeviceParamUploadRepository()),
      ),
      BlocProvider<ListBloc>(
        create: (BuildContext context) =>
            ListBloc(listRepository: WaterDeviceParamListRepository()),
      ),
      BlocProvider<PageBloc>(
        create: (BuildContext context) => PageBloc(),
      ),
    ],
    child: WaterDeviceParamUploadPage(
      json: json,
    ),
  );
});
