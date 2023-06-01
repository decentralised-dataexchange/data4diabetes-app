import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/model/estimatedGlucoseValue/EgvsResponse.dart';
import '/app/core/base/base_controller.dart';

class InsightsController extends BaseController {
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
  var veryLow = 0.obs;
  var low = 0.obs;
  var targetRange = 0.obs;
  var high = 0.obs;
  var veryHigh = 0.obs;
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

    String jsonString = await platform.invokeMethod('QueryCredentials',
        {"CredDefId": "CXcE5anqfGrnQEguoh8QXw:3:CL:376:default"});
    List<GlucoseData> evgsDataList = (jsonDecode(jsonString) as List<dynamic>)
        .map((item) => GlucoseData.fromJson(item))
        .toList();
    for (var e in evgsDataList) {
      try {
        DateTime currentDate = DateTime.now();
      DateTime sevenDaysAgo = currentDate.subtract(const Duration(days: 7));
      DateTime thirtyDaysAgo = currentDate.subtract(const Duration(days: 30));
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
        if (e.collectedDate == DateFormat('dd-MM-yyyy').format(currentDate)) {
          todaysGlucoseLevel.add(e.evgsValue!);
        }
      } catch (e) {
        print("error == $e");
        // Handle the parsing error, e.g., show an error message or assign a default value
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
        totalGlucose = double.parse(e).round() + totalGlucose;
      }
    }
    averageBloodGlucose.value = totalGlucose / glucoseLevel.length;
    averageValue.value =
        averageBloodGlucose.value.isInfinite || averageBloodGlucose.value.isNaN
            ? 0.0
            : averageBloodGlucose.value / percentage;
    gMIpercentage.value =
        averageBloodGlucose.value.isInfinite || averageBloodGlucose.value.isNaN
            ? 0.0
            : (val1 + (val2 * averageBloodGlucose.value));
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
      totalLow.value = totalLow.value + e;
    }
    for (var e in targetRangeList) {
      totalTargetRange.value = totalTargetRange.value + e;
    }

    for (var e in highList) {
      totalHigh.value = totalHigh.value + e;
    }
    for (var e in veryHighList) {
      totalVaryHigh.value = totalVaryHigh.value + e;
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
    veryLow.value = ((totalVaryLow.value / totalGlucoseMmolValues.value) *
                    percentage)
                .isInfinite ||
            ((totalVaryLow.value / totalGlucoseMmolValues.value) * percentage)
                .isNaN
        ? 0
        : ((totalVaryLow.value / totalGlucoseMmolValues.value) * percentage)
            .round()
            .toInt();
    low.value = ((totalLow.value / totalGlucoseMmolValues.value) * percentage)
                .isInfinite ||
            ((totalLow.value / totalGlucoseMmolValues.value) * percentage).isNaN
        ? 0
        : ((totalLow.value / totalGlucoseMmolValues.value) * percentage)
            .round()
            .toInt();

    targetRange.value =
        ((totalTargetRange.value / totalGlucoseMmolValues.value) * percentage)
                    .isInfinite ||
                ((totalTargetRange.value / totalGlucoseMmolValues.value) *
                        percentage)
                    .isNaN
            ? 0
            : ((totalTargetRange.value / totalGlucoseMmolValues.value) *
                    percentage)
                .round()
                .toInt();
    high.value = ((totalHigh.value / totalGlucoseMmolValues.value) * percentage)
                .isInfinite ||
            ((totalHigh.value / totalGlucoseMmolValues.value) * percentage)
                .isNaN
        ? 0
        : ((totalHigh.value / totalGlucoseMmolValues.value) * percentage)
            .round()
            .toInt();
    veryHigh.value = ((totalVaryHigh.value / totalGlucoseMmolValues.value) *
                    percentage)
                .isInfinite ||
            ((totalVaryHigh.value / totalGlucoseMmolValues.value) * percentage)
                .isNaN
        ? 0
        : ((totalVaryHigh.value / totalGlucoseMmolValues.value) * percentage)
            .round()
            .toInt();
    chartData.add(ChartData('', veryLow, low, targetRange, high, veryHigh));
  }
}

class ChartData {
  final String x;
  var veryLow = 0.obs;
  var low = 0.obs;
  var targetRange = 0.obs;
  var high = 0.obs;
  var veryHigh = 0.obs;
  ChartData(this.x, this.veryLow, this.low, this.targetRange, this.high,
      this.veryHigh);
}
