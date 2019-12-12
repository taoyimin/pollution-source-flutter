import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_bloc.dart';
import 'package:pollution_source/module/report/discharge/upload/discharge_report_upload_page.dart';
import 'package:pollution_source/module/report/discharge/upload2/discharge_report_upload_repository.dart';
import 'package:pollution_source/page/login.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage();
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
