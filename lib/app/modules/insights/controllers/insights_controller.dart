import 'dart:convert';

import 'package:Data4Diabetes/app/modules/Dexcom/controllers/dexcom_controller.dart';
import 'package:Data4Diabetes/app/modules/Dexcom/views/dexcom_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/model/dexcom/EstimatedGlucoseValue.dart';
import '../../../data/model/estimatedGlucoseValue/EgvsResponse.dart';
import '/app/core/base/base_controller.dart';

class InsightsController extends BaseController {
  final DexcomController _dexcomController = Get.find();
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
  EstimatedGlucoseValue? evgsDataList;
// Define the input formats
  List<String> inputFormats = [
    'dd/MM/yyyy',
    'dd-MM-yyyy',
    'dd.MM.yyyy',
    'yyyy-MM-dd',
    'yyyy/MM/dd',
    'yyyy.MM.dd',
    // Add more formats as needed
  ];

  // estimatedGlucoseValues() async {
  //   todaysGlucoseLevel.clear();
  //   last7DaysGlucoseLevel.clear();
  //   last30DaysGlucoseLevel.clear();
  //   String jsonString = await platform.invokeMethod('QueryCredentials',
  //       {"CredDefId": "CXcE5anqfGrnQEguoh8QXw:3:CL:376:default"});
  //   List<GlucoseData> evgsDataList = (jsonDecode(jsonString) as List<dynamic>)
  //       .map((item) => GlucoseData.fromJson(item))
  //       .toList();
  //   for (var e in evgsDataList) {
  //     DateFormat outputFormat = DateFormat('dd-MM-yyyy');
  //     bool parsedSuccessfully = false;
  //     DateTime? parsedDate;
  //     for (String format in inputFormats) {
  //       try {
  //         String modifiedDate = e.collectedDate!.replaceAll('/', '-').replaceAll('.', '-');
  //         DateFormat inputFormat = DateFormat(format);
  //         parsedDate = inputFormat.parseStrict(modifiedDate);
  //         parsedSuccessfully = true;
  //         break; // Break the loop if parsing is successful
  //       } catch (e) {
  //         print("Error parsing $format: $e");
  //       }
  //     }
  //     if (parsedSuccessfully) {
  //       String formattedDate = outputFormat.format(parsedDate!);
  //       DateTime currentDate = DateTime.now();
  //       DateTime sevenDaysAgo = currentDate.subtract(const Duration(days: 7));
  //       DateTime thirtyDaysAgo = currentDate.subtract(const Duration(days: 30));
  //       if (parsedDate.isAfter(sevenDaysAgo) || parsedDate.isAtSameMomentAs(sevenDaysAgo)) {
  //         last7DaysGlucoseLevel.add(e.evgsValue!);
  //       }
  //       if (parsedDate.isAfter(thirtyDaysAgo) || parsedDate.isAtSameMomentAs(thirtyDaysAgo)) {
  //         last30DaysGlucoseLevel.add(e.evgsValue!);
  //       }
  //       if (formattedDate == outputFormat.format(currentDate)) {
  //         todaysGlucoseLevel.add(e.evgsValue!);
  //       }
  //     } else {
  //       print("Parsing failed for all input formats. Unable to process date: ${e.collectedDate}");
  //     }
  //   }
  //
  // }

  estimatedGlucoseValues() async {
    showLoading();
    todaysGlucoseLevel.clear();
    last7DaysGlucoseLevel.clear();
    last30DaysGlucoseLevel.clear();
    DateTime currentDate = DateTime.now();
    DateTime sevenDaysAgo = currentDate.subtract(const Duration(days: 7));
    DateTime thirtyDaysAgo = currentDate.subtract(const Duration(days: 30));
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('access_token');
    print('token value $token');
    if (token != null) {
      evgsDataList = await _dexcomController.getEgvs();
      if (evgsDataList != null) {
        if (evgsDataList!.records != null) {
          if (evgsDataList!.records!.isNotEmpty) {
            for (var e in evgsDataList!.records!) {
              if (DateFormat('yyyy-MM-dd')
                  .parse(e.systemTime!)
                  .isAfter(sevenDaysAgo) ||
                  DateFormat('yyyy-MM-dd')
                      .parse(e.systemTime!)
                      .isAtSameMomentAs(sevenDaysAgo)) {
                last7DaysGlucoseLevel.add(e.value.toString());
              }
              if (DateFormat('yyyy-MM-dd')
                  .parse(e.systemTime!)
                  .isAfter(thirtyDaysAgo) ||
                  DateFormat('yyyy-MM-dd')
                      .parse(e.systemTime!)
                      .isAtSameMomentAs(thirtyDaysAgo)) {
                last30DaysGlucoseLevel.add(e.value.toString());
              }
              if (DateFormat('yyyy-MM-dd').parse(e.systemTime!) == currentDate) {
                todaysGlucoseLevel.add(e.value.toString());
              }
            }
          }
        }
        hideLoading();
      }
    }
    else{
      hideLoading();
      alertDialog();
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
        if (double.tryParse(e) != null) {
          totalGlucose = double.parse(e).round() + totalGlucose;
        } else {
          print("Skipping invalid input: $e");
        }
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

    for (var e in glucoseLevel) {
      if (double.tryParse(e) != null) {
        var glucoseMmolValue = double.parse(e) * convertMgValToMmolVal;
        glucoseMmolvaluesList.add(glucoseMmolValue);
      } else {
        print("Skipping invalid input: $e");
      }
    }
    for (var e in glucoseMmolvaluesList) {
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
    veryLow.value = ((veryLowList.length / glucoseMmolvaluesList.length) *
                    percentage)
                .isInfinite ||
            ((veryLowList.length / glucoseMmolvaluesList.length) * percentage)
                .isNaN
        ? 0
        : ((veryLowList.length / glucoseMmolvaluesList.length) * percentage)
            .round()
            .toInt();
    low.value = ((lowList.length / glucoseMmolvaluesList.length) * percentage)
                .isInfinite ||
            ((lowList.length / glucoseMmolvaluesList.length) * percentage).isNaN
        ? 0
        : ((lowList.length / glucoseMmolvaluesList.length) * percentage)
            .round()
            .toInt();

    targetRange.value =
        ((targetRangeList.length / glucoseMmolvaluesList.length) * percentage)
                    .isInfinite ||
                ((targetRangeList.length / glucoseMmolvaluesList.length) *
                        percentage)
                    .isNaN
            ? 0
            : ((targetRangeList.length / glucoseMmolvaluesList.length) *
                    percentage)
                .round()
                .toInt();
    high.value = ((highList.length / glucoseMmolvaluesList.length) * percentage)
                .isInfinite ||
            ((highList.length / glucoseMmolvaluesList.length) * percentage)
                .isNaN
        ? 0
        : ((highList.length / glucoseMmolvaluesList.length) * percentage)
            .round()
            .toInt();
    veryHigh.value = ((veryHighList.length / glucoseMmolvaluesList.length) *
                    percentage)
                .isInfinite ||
            ((veryHighList.length / glucoseMmolvaluesList.length) * percentage)
                .isNaN
        ? 0
        : ((veryHighList.length / glucoseMmolvaluesList.length) * percentage)
            .round()
            .toInt();
    chartData.add(ChartData('', veryLow, low, targetRange, high, veryHigh));
  }

  void alertDialog() {
    Get.defaultDialog(
        barrierDismissible: false,
        title: 'Dexcom Login',
        content: const Text(
          'Please login to Dexcom to get your estimated glucose values',
          textAlign: TextAlign.center,
        ),
        actions: [
          CupertinoButton(
              child: const Text('OK'),
              onPressed: () {
                Get.off(DexcomView());
              }),
          CupertinoButton(
              child: const Text('Cancel'),
              onPressed: () {
                Get.back();
              }),
        ]);
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
