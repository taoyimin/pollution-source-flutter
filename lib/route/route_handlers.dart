import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pollution_source/module/common/detail/detail_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/order/detail2/order_detail_page2.dart';
import 'package:pollution_source/module/order/detail2/order_detail_repository.dart';
import 'package:pollution_source/module/process/upload/process_upload_repository.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_bloc.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_page.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_repository.dart';
import 'package:pollution_source/page/login.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage();
});

var orderDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String orderId = params["orderId"]?.first;
  return MultiBlocProvider(
    providers: [
      BlocProvider<UploadBloc>(
        create: (BuildContext context) =>
            UploadBloc(uploadRepository: ProcessUploadRepository()),
      ),
      BlocProvider<DetailBloc>(
        create: (BuildContext context) => DetailBloc(detailRepository: OrderDetailRepository()),
      ),
    ],
    child: OrderDetailPage2(orderId: orderId),
  );
});

var dischargeReportUploadHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String enterId = params["enterId"]?.first;
  return MultiBlocProvider(
    providers: [
      BlocProvider<UploadBloc>(
        create: (BuildContext context) =>
            UploadBloc(uploadRepository: DischargeReportUploadRepository()),
      ),
      BlocProvider<DischargeReportUploadBloc>(
        create: (BuildContext context) => DischargeReportUploadBloc(),
      ),
    ],
    child: DischargeReportUploadPage(enterId: enterId),
  );
});
