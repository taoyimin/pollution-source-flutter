import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/route/route_handlers.dart';

class Routes {
  static String root = "/";
  static String adminHome = "/adminHome";
  static String enterHome = "/enterHome";
  static String operationHome = "/operationHome";
  static String enterList = "/enterList";
  static String enterDetail = "/enterDetail";
  static String dischargeList = "/dischargeList";
  static String dischargeDetail = "/dischargeDetail";
  static String monitorList = "/monitorList";
  static String monitorDetail = "/monitorDetail";
  static String orderList = "/orderList";
  static String orderDetail = "/orderDetail";
  static String dischargeReportList = "/dischargeReportList";
  static String dischargeReportDetail = "/dischargeReportDetail";
  static String factorReportList = "/factorReportList";
  static String factorReportDetail = "/factorReportDetail";
  static String longStopReportList = "/longStopReportList";
  static String longStopReportDetail = "/longStopReportDetail";
  static String dischargeReportUpload = "/dischargeReportUpload";
  static String factorReportUpload = "/factorReportUpload";
  static String longStopReportUpload = "/longStopReportUpload";
  static String licenseList = "/licenseList";

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        // ignore: missing_return
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          print("ROUTE WAS NOT FOUND !!!");
        });
    router.define(root, handler: rootHandler);
    router.define(adminHome, handler: adminHomeHandler, transitionType: TransitionType.native);
    router.define('$enterHome/:id', handler: enterHomeHandler, transitionType: TransitionType.native);
    router.define(operationHome, handler: operationHomeHandler, transitionType: TransitionType.native);
    router.define(enterList, handler: enterListHandler, transitionType: TransitionType.native);
    router.define('$enterDetail/:id', handler: enterDetailHandler, transitionType: TransitionType.native);
    router.define(dischargeList, handler: dischargeListHandler, transitionType: TransitionType.native);
    router.define('$dischargeDetail/:id', handler: dischargeDetailHandler, transitionType: TransitionType.native);
    router.define(monitorList, handler: monitorListHandler, transitionType: TransitionType.native);
    router.define('$monitorDetail/:id', handler: monitorDetailHandler, transitionType: TransitionType.native);
    router.define(orderList, handler: orderListHandler, transitionType: TransitionType.native);
    router.define('$orderDetail/:id', handler: orderDetailHandler, transitionType: TransitionType.native);
    router.define(dischargeReportList, handler: dischargeReportListHandler, transitionType: TransitionType.native);
    router.define('$dischargeReportDetail/:id', handler: dischargeReportDetailHandler, transitionType: TransitionType.native);
    router.define(factorReportList, handler: factorReportListHandler, transitionType: TransitionType.native);
    router.define('$factorReportDetail/:id', handler: factorReportDetailHandler, transitionType: TransitionType.native);
    router.define(longStopReportList, handler: longStopReportListHandler, transitionType: TransitionType.native);
    router.define('$longStopReportDetail/:id', handler: longStopReportDetailHandler, transitionType: TransitionType.native);
    router.define('$dischargeReportUpload', handler: dischargeReportUploadHandler, transitionType: TransitionType.native);
    router.define('$factorReportUpload', handler: factorReportUploadHandler, transitionType: TransitionType.native);
    router.define('$longStopReportUpload/:id', handler: longStopReportUploadHandler, transitionType: TransitionType.native);
    router.define(licenseList, handler: licenseListHandler, transitionType: TransitionType.native);
  }
}