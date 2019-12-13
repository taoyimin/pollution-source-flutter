import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/route/route_handlers.dart';

class Routes {
  static String root = "/";
  static String orderDetail = "/orderDetail";
  static String dischargeReportUpload = "/dischargeReportUpload";

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        // ignore: missing_return
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          print("ROUTE WAS NOT FOUND !!!");
        });
    router.define(root, handler: rootHandler);
    router.define(orderDetail, handler: orderDetailHandler);
    router.define(dischargeReportUpload, handler: dischargeReportUploadHandler);
  }
}