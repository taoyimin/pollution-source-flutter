import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/http/error_handle.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/module/common/upload/upload_repository.dart';
import 'package:pollution_source/module/inspection/param/water/device/water_device_list_model.dart';
import 'package:pollution_source/module/inspection/param/water/upload/water_device_param_upload_model.dart';

class WaterDeviceParamUploadRepository
    extends UploadRepository<WaterDeviceParamUpload, String> {
  @override
  checkData(WaterDeviceParamUpload data) {
    if (data.baiduLocation == null)
      throw DioError(error: InvalidParamException('请先获取位置信息'));
    if (data.waterDeviceParamTypeList == null)
      throw DioError(error: InvalidParamException('请先加载巡检参数'));
    if (data.enter == null)
      throw DioError(error: InvalidParamException('请选择企业'));
    if (data.monitor == null)
      throw DioError(error: InvalidParamException('请选择监控点'));
    if (data.monitor.dischargeId == null) {
      throw DioError(
          error: InvalidParamException(
              'monitorId=${data.monitor.monitorId}的监控点没有对应的排口Id'));
    }
    if (data.device == null)
      throw DioError(error: InvalidParamException('请选择设备'));
    data.waterDeviceParamTypeList.forEach((waterDeviceParamType) {
      waterDeviceParamType.waterDeviceParamNameList
          .forEach((waterDeviceParamName) {
        if (isRequiredParam(waterDeviceParamType, data.device)) {
          // 如果是必要参数，则验证是否输入
          if (waterDeviceParamType.parameterType is TextEditingController &&
              TextUtil.isEmpty(waterDeviceParamType.parameterType.text)) {
            throw DioError(error: InvalidParamException('请填入试剂名称'));
          }
          if (TextUtil.isEmpty(waterDeviceParamName.originalVal.text))
            throw DioError(
                error: InvalidParamException(
                    '请填写 [${waterDeviceParamType.parameterType is TextEditingController ? waterDeviceParamType.parameterType.text : waterDeviceParamType.parameterType}] - [${waterDeviceParamName.parameterName}] 中的原始值（不会填写可以填入 / 代替）'));
          if (TextUtil.isEmpty(waterDeviceParamName.updateVal.text))
            throw DioError(
                error: InvalidParamException(
                    '请填写 [${waterDeviceParamType.parameterType is TextEditingController ? waterDeviceParamType.parameterType.text : waterDeviceParamType.parameterType}] - [${waterDeviceParamName.parameterName}] 中的修改值（不会填写可以填入 / 代替）'));
          if (TextUtil.isEmpty(waterDeviceParamName.modifyReason.text))
            throw DioError(
                error: InvalidParamException(
                    '请填写 [${waterDeviceParamType.parameterType is TextEditingController ? waterDeviceParamType.parameterType.text : waterDeviceParamType.parameterType}] - [${waterDeviceParamName.parameterName}] 中的修改原因（不会填写可以填入 / 代替）'));
        }
      });
    });
  }

  @override
  HttpApi createApi() {
    return HttpApi.deviceParamUpload;
  }

  @override
  Future<FormData> createFormData(WaterDeviceParamUpload data) async {
    FormData formData = FormData();
    // 过滤非必要参数
    List<WaterDeviceParamType> tempList = data.waterDeviceParamTypeList
        .where((waterDeviceParamType) =>
            isRequiredParam(waterDeviceParamType, data.device))
        .toList();
    formData.fields
      ..addAll([MapEntry('latitude', data.baiduLocation.latitude.toString())])
      ..addAll([MapEntry('longitude', data.baiduLocation.longitude.toString())])
      ..addAll([MapEntry('address', data.baiduLocation.locationDetail)])
      ..addAll([MapEntry('enterId', data.enter.enterId.toString())])
      ..addAll([MapEntry('outId', data.monitor.dischargeId.toString())])
      ..addAll([MapEntry('monitorId', data.monitor.monitorId.toString())])
      ..addAll([MapEntry('deviceId', data.device.deviceId.toString())])
      ..addAll([MapEntry('measureMethod', data.device.measureMethod ?? '')])
      ..addAll(
          [MapEntry('measurePrinciple', data.device.measurePrinciple ?? '')])
      ..addAll(
          [MapEntry('measurePrincipleStr', data.measurePrincipleStr ?? '')])
      ..addAll([MapEntry('analysisMethod', data.device.analysisMethod ?? '')])
      ..addAll([MapEntry('analysisMethodStr', data.analysisMethodStr ?? '')])
      ..addAll(tempList.expand((WaterDeviceParamType waterDeviceParamType) {
        return waterDeviceParamType.waterDeviceParamNameList
            .map((WaterDeviceParamName waterDeviceParamName) {
          return MapEntry('parameterType', () {
            if (waterDeviceParamType.parameterType is TextEditingController) {
              return waterDeviceParamType.parameterType.text;
            } else {
              return waterDeviceParamType.parameterType;
            }
          }());
        });
      }))
      ..addAll(tempList.expand((WaterDeviceParamType waterDeviceParamType) {
        return waterDeviceParamType.waterDeviceParamNameList
            .map((WaterDeviceParamName waterDeviceParamName) {
          return MapEntry('parameterName', waterDeviceParamName.parameterName);
        });
      }))
      ..addAll(tempList.expand((WaterDeviceParamType waterDeviceParamType) {
        return waterDeviceParamType.waterDeviceParamNameList
            .map((WaterDeviceParamName waterDeviceParamName) {
          return MapEntry('originalVal', waterDeviceParamName.originalVal.text);
        });
      }))
      ..addAll(tempList.expand((WaterDeviceParamType waterDeviceParamType) {
        return waterDeviceParamType.waterDeviceParamNameList
            .map((WaterDeviceParamName waterDeviceParamName) {
          return MapEntry('updateVal', waterDeviceParamName.updateVal.text);
        });
      }))
      ..addAll(tempList.expand((WaterDeviceParamType waterDeviceParamType) {
        return waterDeviceParamType.waterDeviceParamNameList
            .map((WaterDeviceParamName waterDeviceParamName) {
          return MapEntry(
              'modifyReason', waterDeviceParamName.modifyReason.text);
        });
      }));
    return formData;
  }

  /// 当前参数类型是否为必要参数
  static bool isRequiredParam(
      WaterDeviceParamType waterDeviceParamType, WaterDevice device) {
    if (waterDeviceParamType.parameterTypeId == 906 && device?.deviceId != 31) {
      // 参数类型是明渠流量计，且设备ID不等于31，不是必要参数
      return false;
    } else if (waterDeviceParamType.parameterTypeId == 900 &&
        (device?.measureMethod?.contains('NH1') ?? false)) {
      // 参数类型是测定单元，且measureMethod包含NH1，不是必要参数
      return false;
    }
    return true;
  }
}
