import 'package:pollution_source/module/common/common_model.dart';

class CommonUtils {
  /// 获取一个数组中的最大数
  static double getMax(List<double> items) {
    if (items.length == 0) return 0;
    double temp = items[0];
    items.forEach((item) {
      if (item > temp) {
        temp = item;
      }
    });
    return temp;
  }

  /// 获取一个数组中的最小数
  static double getMin(List<double> items) {
    if (items.length == 0) return 0;
    double temp = items[0];
    items.forEach((item) {
      if (item < temp) {
        temp = item;
      }
    });
    return temp;
  }

  /// 获取Y轴的间隔（坐标轴默认显示5个坐标）
  static double getYAxisInterval(List<ChartData> chartDataList) {
    double maxY = getMax(
        chartDataList.where((chartData) => chartData.checked).map((chartData) {
          return chartData.maxY;
        }).toList());
    double minY = getMin(
        chartDataList.where((chartData) => chartData.checked).map((chartData) {
          return chartData.minY;
        }).toList());
    return (maxY - minY) / (4);
  }

  /// 获取X轴的间隔（坐标轴默认显示7个坐标）
  static double getXAxisInterval(List<ChartData> chartDataList) {
    double maxX = getMax(
        chartDataList.where((chartData) => chartData.checked).map((chartData) {
          return chartData.maxX;
        }).toList());
    double minX = getMin(
        chartDataList.where((chartData) => chartData.checked).map((chartData) {
          return chartData.minX;
        })?.toList());
    return (maxX - minX) / (6);
  }

  /// 判断String是否是数字
  static bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  /// 获取两个时间中更小的时间
  static DateTime getMaxDateTime(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime1 == null)
      return dateTime2;
    else if (dateTime2 == null)
      return dateTime1;
    else if (dateTime1.isAfter(dateTime2))
      return dateTime1;
    else
      return dateTime2;
  }

  /// 格式化文件大小
  static String formatSize(double value) {
    if (null == value) {
      return '未知大小';
    }
    List<String> unitArr = List()..add('B')..add('KB')..add('MB')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}
