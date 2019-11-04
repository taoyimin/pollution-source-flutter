import 'package:equatable/equatable.dart';
import 'package:pollution_source/module/common/common_model.dart';

//异常申报单详情
class ReportDetail extends Equatable {
  final String enterId; //企业ID
  final String monitorId; //监控点ID
  final String enterName; //企业名称
  final String enterAddress; //企业地址
  final String outletName; //排口名称
  final String monitorName; //监控点名称
  final String areaName; //区域
  final String type; //0：排口异常 1：因子异常
  final String reportTime; //申报时间
  final String startTime; //开始时间
  final String endTime; //结束时间
  final String abnormalFactor; //异常因子
  final String abnormalType; //异常类型
  final String reportReason; //申报原因
  final String reviewOpinion; //审核意见
  final List<Attachment> attachmentList; //证明材料

  const ReportDetail({
    this.enterId,
    this.monitorId,
    this.enterName,
    this.enterAddress,
    this.outletName,
    this.monitorName,
    this.areaName,
    this.type,
    this.reportTime,
    this.startTime,
    this.endTime,
    this.abnormalFactor,
    this.abnormalType,
    this.reportReason,
    this.reviewOpinion,
    this.attachmentList,
  });

  @override
  List<Object> get props => [
        enterId,
        monitorId,
        enterName,
        enterAddress,
        outletName,
        monitorName,
        areaName,
        type,
        reportTime,
        startTime,
        endTime,
        abnormalFactor,
        abnormalType,
        reportReason,
        reviewOpinion,
        attachmentList,
      ];

  static ReportDetail fromJson(dynamic json) {
    return ReportDetail(
      enterId: json['stopApply']['enterId'],
      monitorId: json['stopApply']['monitorId'],
      enterName: json['stopApply']['enterpriseName'],
      enterAddress: '没有该字段',
      outletName: json['stopApply']['disOutName'],
      monitorName: json['stopApply']['disMonitorName'],
      areaName: '没有该字段',
      type: json['stopApply']['disMonitorName'],
      reportTime: json['stopApply']['applayTimeStr'],
      startTime: json['stopApply']['startTimeStr'],
      endTime: json['stopApply']['endTimeStr'],
      abnormalFactor: json['stopApply']['factorName'],
      abnormalType: json['stopApply']['stopTypeStr'],
      reportReason: json['stopApply']['stopReason'],
      reviewOpinion: json['stopApply']['remark'],
      attachmentList: [
        Attachment(type: 0, fileName: "文件名文件名.png", url: "", size: "1.2M"),
        Attachment(type: 1, fileName: "文件名文件名文件名.doc", url: "", size: "56KB"),
        Attachment(
            type: 3, fileName: "文件文件名文件文件文件名.pdf", url: "", size: "4.3M"),
        Attachment(type: 5, fileName: "文件文件名文件文件名.psd", url: "", size: "412KB"),
      ],
    );
  }
}
