import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/res/constant.dart';

//异常申报单详情
class DischargeReportDetail extends Equatable {
  final String reportId; //排口异常申报ID
  final String enterId; //企业ID
  final String dischargeId; //排口ID
  final String monitorId; //监控点ID
  final String enterName; //企业名称
  final String enterAddress; //企业地址
  final String dischargeName; //排口名称
  final String monitorName; //监控点名称
  final String districtName; //区域
  final String reportTimeStr; //申报时间
  final String startTimeStr; //开始时间
  final String endTimeStr; //结束时间
  final String stopTypeStr; //异常类型
  final String stopReason; //停产原因
  final String reviewOpinion; //审核意见
  final List<Attachment> attachmentList; //证明材料

  const DischargeReportDetail({
    this.reportId,
    this.enterId,
    this.dischargeId,
    this.monitorId,
    this.enterName,
    this.enterAddress,
    this.dischargeName,
    this.monitorName,
    this.districtName,
    this.reportTimeStr,
    this.startTimeStr,
    this.endTimeStr,
    this.stopTypeStr,
    this.stopReason,
    this.reviewOpinion,
    this.attachmentList,
  });

  @override
  List<Object> get props => [
        reportId,
        enterId,
        dischargeId,
        monitorId,
        enterName,
        enterAddress,
        dischargeName,
        monitorName,
        districtName,
        reportTimeStr,
        startTimeStr,
        endTimeStr,
        stopTypeStr,
        stopReason,
        reviewOpinion,
        attachmentList,
      ];

  static DischargeReportDetail fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return DischargeReportDetail(
        reportId: json['stopApply']['stopApplyId'].toString(),
        enterId: json['stopApply']['enterId'].toString(),
        dischargeId: json['stopApply']['outId'].toString(),
        monitorId: json['stopApply']['monitorId'].toString(),
        enterName: json['stopApply']['enterpriseName'],
        enterAddress: '-',
        dischargeName: json['stopApply']['disOutName'],
        monitorName: json['stopApply']['disMonitorName'],
        districtName: '-',
        reportTimeStr: json['stopApply']['applayTimeStr'],
        startTimeStr: json['stopApply']['startTimeStr'],
        endTimeStr: json['stopApply']['endTimeStr'],
        stopTypeStr: json['stopApply']['stopTypeStr'],
        stopReason: json['stopApply']['stopReason'],
        reviewOpinion: '-',
        attachmentList: [
          Attachment(fileName: "*文件名文件名.png", url: "*", size: 534345),
          Attachment(fileName: "*文件名文件名文件名.doc", url: "*", size: 5454),
          Attachment(fileName: "*文件文件名文件文件文件名.pdf", url: "*", size: 34534),
          Attachment(fileName: "*文件文件名文件文件名.psd", url: "*", size: 5354),
        ],
      );
    } else {
      return DischargeReportDetail(
        reportId: json['reportId'],
        enterId: json['enterId'],
        dischargeId: json['dischargeId'],
        monitorId: json['monitorId'],
        enterName: json['enterName'],
        enterAddress: json['enterAddress'],
        dischargeName: json['dischargeName'],
        monitorName: json['monitorName'],
        districtName: json['districtName'],
        reportTimeStr: json['reportTimeStr'],
        startTimeStr: json['startTimeStr'],
        endTimeStr: json['endTimeStr'],
        stopTypeStr: json['stopTypeStr'],
        stopReason: json['stopReason'],
        reviewOpinion: '-',
        attachmentList: Attachment.fromJsonArray(json['attachments']),
      );
    }
  }
}
