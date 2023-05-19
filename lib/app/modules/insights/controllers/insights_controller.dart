import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/model/estimatedGlucoseValue/EgvsResponse.dart';
import '/app/core/base/base_controller.dart';

class InsightsController extends BaseController {
  final List<String> items = ['TODAY', 'LAST 7 DAYS', 'LAST 30 DAYS'];
  RxString selectedValue = 'TODAY'.obs;
  var totalGlucose = 0;
  var val1 = 3.31;
  var val2 = 0.02392;
  var percentage = 100;
  var gMIpercentage = 0.0.obs;
  var averageBloodGlucose = 0.0.obs;
  var averageValue = 0.0.obs;
  var convertMgValToMmolVal = 0.0555;
  var targetRangeFrom = 3.9;
  var targetRangeTo = 10.0;
  var tIRPercentage = 0.0.obs;
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
  List<String> todaysGlucoseLevel = [];
  List<String> last7DaysGlucoseLevel = [];
  List<String> last30DaysGlucoseLevel = [];
  var y1 = 0.obs;
  var y2 = 0.obs;
  var y3 = 0.obs;
  var y4 = 0.obs;
  var y5 = 0.obs;
  RxList<ChartData> chartData = List<ChartData>.empty().obs;
  var lowRangeTo = 3.8;
  var highRangeFrom = 10.1;
  var highRangeTo = 13.9;
  List glucoseMmolvaluesList = [];
  List veryLowList = [];
  List lowList = [];
  List targetRangeList = [];
  List highList = [];
  List veryHighList = [];
  var totalGlucoseMmolValues = 0.0.obs;
  var totalVaryLow = 0.0.obs;
  var totalLow = 0.0.obs;
  var totalTargetRange = 0.0.obs;
  var totalHigh = 0.0.obs;
  var totalVaryHigh = 0.0.obs;

  estimatedGlucoseValues() async {
    todaysGlucoseLevel.clear();
    last7DaysGlucoseLevel.clear();
    last30DaysGlucoseLevel.clear();
    var response = await platform.invokeMethod('QueryCredentials',
        {"CredDefId": "CXcE5anqfGrnQEguoh8QXw:3:CL:376:default"});
    List<GlucoseData> evgsDataList = (jsonDecode(response) as List<dynamic>)
        .map((item) => GlucoseData.fromJson(item))
        .toList();
    print('glucose values');
    for (var e in evgsDataList) {
      print(e.evgsValue);
      DateTime currentDate = DateTime.now();
      DateTime sevenDaysAgo = currentDate.subtract(const Duration(days: 7));
      DateTime thirtyDaysAgo = currentDate.subtract(const Duration(days: 30));
      if (e.collectedDate == DateFormat('dd-MM-yyyy').format(currentDate)) {
        todaysGlucoseLevel.add(e.evgsValue!);
      }
      if (DateFormat('dd-MM-yyyy')
          .parse(e.collectedDate!)
          .isAfter(sevenDaysAgo) ||
          DateFormat('dd-MM-yyyy').parse(e.collectedDate!) == sevenDaysAgo) {
        last7DaysGlucoseLevel.add(e.evgsValue!);
      }
      if (DateFormat('dd-MM-yyyy')
          .parse(e.collectedDate!)
          .isAfter(thirtyDaysAgo) ||
          DateFormat('dd-MM-yyyy').parse(e.collectedDate!) == thirtyDaysAgo) {
        last30DaysGlucoseLevel.add(e.evgsValue!);
      }
    }
  }

  gMICalculator(String selectedValue) {
    switch (selectedValue) {
      case 'TODAY':
        gMI(todaysGlucoseLevel);
        break;
      case 'LAST 7 DAYS':
        gMI(last7DaysGlucoseLevel);
        break;
      case 'LAST 30 DAYS':
        gMI(last30DaysGlucoseLevel);
        break;
    }
  }

  void gMI(List<String> glucoseLevel) {
    totalGlucose = 0;
    if (glucoseLevel.isNotEmpty) {
      for (var e in glucoseLevel) {
        totalGlucose = int.parse(e) + totalGlucose;
      }
    }
    averageBloodGlucose.value = totalGlucose / todaysGlucoseLevel.length;
    averageValue.value = averageBloodGlucose.value / percentage;
    gMIpercentage.value = (val1 + (val2 * averageBloodGlucose.value));
    print('gmi value: $gMIpercentage');
  }

  tIRCalculator(String selectedValue) {
    switch (selectedValue) {
      case 'TODAY':
        tIR(todaysGlucoseLevel);
        break;
      case 'LAST 7 DAYS':
        tIR(last7DaysGlucoseLevel);
        break;
      case 'LAST 30 DAYS':
        tIR(last30DaysGlucoseLevel);
        break;
    }
  }

  void tIR(List<String> glucoseLevel) {
    veryLowList.clear();
    veryHighList.clear();
    lowList.clear();
    targetRangeList.clear();
    highList.clear();
    veryHighList.clear();
    glucoseMmolvaluesList.clear();
    totalGlucoseMmolValues = 0.0.obs;
    totalVaryLow = 0.0.obs;
    totalLow = 0.0.obs;
    totalTargetRange = 0.0.obs;
    totalHigh = 0.0.obs;
    totalVaryHigh = 0.0.obs;

    for (var e in glucoseLevel) {
      var glucoseMmolValue = double.parse(e) * convertMgValToMmolVal;
      glucoseMmolvaluesList.add(glucoseMmolValue);
    }
    for (var e in glucoseMmolvaluesList) {
      totalGlucoseMmolValues.value = totalGlucoseMmolValues.value + e;
      if (e < 3.0) {
        veryLowList.add(e);
      } else if (e >= 3.0 && e <= lowRangeTo) {
        lowList.add(e);
      } else if (e >= targetRangeFrom && e <= targetRangeTo) {
        targetRangeList.add(e);
      } else if (e >= highRangeFrom && e <= highRangeTo) {
        highList.add(e);
      } else {
        veryHighList.add(e);
      }
    }
    for (var e in veryLowList) {
      totalVaryLow.value = totalVaryLow.value + e;
    }
    for (var e in lowList) {
      totalLow.value = totalVaryLow.value + e;
    }
    for (var e in targetRangeList) {
      totalTargetRange.value = totalVaryLow.value + e;
    }
    for (var e in highList) {
      totalHigh.value = totalVaryLow.value + e;
    }
    for (var e in veryHighList) {
      totalVaryHigh.value = totalVaryLow.value + e;
    }
  }

  void addChartDataValues(String selectedValue) {
    switch (selectedValue) {
      case 'TODAY':
        chartDataValues();
        break;
      case 'LAST 7 DAYS':
        chartDataValues();
        break;
      case 'LAST 30 DAYS':
        chartDataValues();
        break;
    }
  }

  void chartDataValues() {
    y1.value =
        ((totalVaryLow.value / totalGlucoseMmolValues.value) * percentage)
            .toInt();
    y2.value =
        ((totalLow.value / totalGlucoseMmolValues.value) * percentage).toInt();
    y3.value =
        ((totalTargetRange.value / totalGlucoseMmolValues.value) * percentage)
            .toInt();
    y4.value =
        ((totalHigh.value / totalGlucoseMmolValues.value) * percentage).toInt();
    y5.value =
        ((totalVaryHigh.value / totalGlucoseMmolValues.value) * percentage)
            .toInt();
    chartData.add(ChartData('', y1, y2, y3, y4, y5));
  }
}

class ChartData {
  final String x;
  var y1 = 0.obs;
  var y2 = 0.obs;
  var y3 = 0.obs;
  var y4 = 0.obs;
  var y5 = 0.obs;
  ChartData(this.x, this.y1, this.y2, this.y3, this.y4, this.y5);
}
