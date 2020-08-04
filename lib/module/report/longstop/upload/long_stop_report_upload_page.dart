import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/common_widget.dart';
import 'package:pollution_source/module/common/dict/data_dict_bloc.dart';
import 'package:pollution_source/module/common/dict/data_dict_event.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_state.dart';
import 'package:pollution_source/module/common/dict/system/system_config_repository.dart';
import 'package:pollution_source/module/common/upload/upload_bloc.dart';
import 'package:pollution_source/module/common/upload/upload_event.dart';
import 'package:pollution_source/module/common/upload/upload_state.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/report/longstop/upload/long_stop_report_upload_model.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/res/gaps.dart';
import 'package:pollution_source/route/application.dart';
import 'package:pollution_source/route/routes.dart';
import 'package:pollution_source/util/common_utils.dart';
import 'package:pollution_source/util/system_utils.dart';
import 'package:pollution_source/widget/custom_header.dart';

import 'long_stop_report_upload_repository.dart';

/// 长期停产申报上报界面
class LongStopReportUploadPage extends StatefulWidget {
  final String enterId;

  LongStopReportUploadPage({this.enterId});

  @override
  _LongStopReportUploadPageState createState() =>
      _LongStopReportUploadPageState();
}

class _LongStopReportUploadPageState extends State<LongStopReportUploadPage> {
  /// 上报Bloc
  final UploadBloc _uploadBloc = UploadBloc(
    uploadRepository: LongStopReportUploadRepository(),
  );

  /// 开始时间最多滞后的小时数Bloc
  final DataDictBloc _stopAdvanceTimeBloc = DataDictBloc(
    dataDictRepository: SystemConfigRepository(HttpApi.reportStopAdvanceTime),
  );

  /// 长期停产申报上报类
  final LongStopReportUpload _longStopReportUpload = LongStopReportUpload();

  @override
  void initState() {
    super.initState();
    // 设置默认企业，企业用户上报时，默认选中的企业为自己，无需选择
    _longStopReportUpload.enter = TextUtil.isEmpty(widget.enterId)
        ? null
        : Enter(enterId: int.parse(widget.enterId));
    // 加载异常申报开始时间最多滞后的小时数
    _stopAdvanceTimeBloc.add(DataDictLoad());
  }

  @override
  void dispose() {
    // 释放资源
    _longStopReportUpload.remark.dispose();
    if (_stopAdvanceTimeBloc?.state is DataDictLoading)
      (_stopAdvanceTimeBloc?.state as DataDictLoading).cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          UploadHeaderWidget(
            title: '企业长期停产申报上报',
            subTitle: '''1、停产申报一天，起止时间写同一天；
2、停产申报两天（如2号、3号），开始写2号，结束写3号；
3、在尊重事实的情况下，尽量将预计结束时间设置大的范围；''',
            imagePath: 'assets/images/upload_header_image3.png',
            backgroundColor: Colours.primary_color,
          ),
          MultiBlocListener(
            listeners: [
              BlocListener<UploadBloc, UploadState>(
                bloc: _uploadBloc,
                listener: uploadListener,
              ),
              BlocListener<UploadBloc, UploadState>(
                bloc: _uploadBloc,
                listener: (context, state) {
                  if (state is UploadSuccess) {
                    setState(() {
                      // 重置界面
                      if (widget.enterId == null)
                        _longStopReportUpload.enter = null;
                      _longStopReportUpload.startTime = null;
                      _longStopReportUpload.endTime = null;
                      _longStopReportUpload.remark.text = '';
                      _longStopReportUpload.attachments.clear();
                    });
                  }
                },
              ),
              BlocListener<DataDictBloc, DataDictState>(
                bloc: _stopAdvanceTimeBloc,
                listener: (context, state) {
                  if (state is DataDictLoaded) {
                    List<DataDict> dataDictList =
                        (_stopAdvanceTimeBloc?.state as DataDictLoaded)
                            .dataDictList;
                    if (dataDictList.length != 0) {
                      // 设置最小开始时间
                      _longStopReportUpload.minStartTime = DateTime.now().add(
                          Duration(hours: -int.parse(dataDictList[0].code)));
                    }
                  }
                },
              ),
            ],
            child: _buildPageLoadedDetail(),
          ),
        ],
      ),
    );
  }

  Widget _buildPageLoadedDetail() {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                Offstage(
                  offstage: widget.enterId != null,
                  child: SelectRowWidget(
                    title: '企业名称',
                    content: _longStopReportUpload.enter?.enterName,
                    onTap: () async {
                      // 打开企业选择界面并等待结果返回
                      Enter enter = await Application.router.navigateTo(
                          context, '${Routes.enterList}?type=1&state=1');
                      if (enter != null) {
                        // 设置已经选中的企业
                        _longStopReportUpload.enter = enter;
                      }
                    },
                  ),
                ),
                widget.enterId != null ? Gaps.empty : Gaps.hLine,
                SelectRowWidget(
                  title: '开始时间',
                  content: DateUtil.formatDate(_longStopReportUpload.startTime,
                      format: DateFormats.y_mo_d_h_m),
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                      locale: DateTimePickerLocale.zh_cn,
                      pickerMode: DateTimePickerMode.datetime,
                      initialDateTime: _longStopReportUpload.startTime,
                      minDateTime: _longStopReportUpload.minStartTime,
                      maxDateTime: _longStopReportUpload.endTime,
                      onClose: () {},
                      onConfirm: (dateTime, selectedIndex) {
                        setState(() {
                          _longStopReportUpload.startTime = dateTime;
                        });
                      },
                    );
                  },
                ),
                Gaps.hLine,
                SelectRowWidget(
                  title: '结束时间',
                  content: DateUtil.formatDate(_longStopReportUpload.endTime,
                      format: DateFormats.y_mo_d_h_m),
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      dateFormat: 'yyyy年MM月dd日 EEE,HH时:mm分',
                      locale: DateTimePickerLocale.zh_cn,
                      pickerMode: DateTimePickerMode.datetime,
                      initialDateTime: _longStopReportUpload.endTime,
                      minDateTime: CommonUtils.getMaxDateTime(
                          _longStopReportUpload.startTime,
                          _longStopReportUpload.minStartTime),
                      onClose: () {},
                      onConfirm: (dateTime, selectedIndex) {
                        setState(() {
                          _longStopReportUpload.endTime = dateTime;
                        });
                      },
                    );
                  },
                ),
                Gaps.hLine,
                TextAreaWidget(
                  title: '备注',
                  hintText: '请输入备注',
                  controller: _longStopReportUpload.remark,
                ),
                Gaps.vGap5,
                // 没有附件则隐藏GridView
                Offstage(
                  offstage: _longStopReportUpload.attachments.length == 0,
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    children: List.generate(
                      _longStopReportUpload.attachments.length,
                      (index) {
                        Asset asset = _longStopReportUpload.attachments[index];
                        return AssetThumb(
                          asset: asset,
                          width: 300,
                          height: 300,
                        );
                      },
                    ),
                  ),
                ),
                Gaps.vGap5,
                Row(
                  children: <Widget>[
                    ClipButton(
                      text: '选择图片',
                      icon: Icons.image,
                      color: Colors.green,
                      onTap: () async {
                        _longStopReportUpload.attachments =
                            await SystemUtils.loadAssets(
                                _longStopReportUpload.attachments);
                        setState(() {});
                      },
                    ),
                    Gaps.hGap20,
                    ClipButton(
                      text: '提交',
                      icon: Icons.file_upload,
                      color: Colors.lightBlue,
                      onTap: () {
                        _uploadBloc.add(Upload(data: _longStopReportUpload));
                      },
                    ),
                  ],
                ),
                Gaps.vGap20,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
