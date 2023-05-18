import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/model/estimatedGlucoseValue/EgvsResponse.dart';
import '/app/core/base/base_controller.dart';

//import 'package:charts_flutter/flutter.dart' as charts;
class InsightsController extends BaseController {
  final List<String> items = ['TODAY', 'LAST 7 DAYS', 'LAST 30 DAYS'];
  RxString selectedValue = 'TODAY'.obs;
  var totalGlucose = 0;
  var val1=3.31;
  var val2=0.02392;
  var gMIpercentage=0.0.obs;
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
  List<String> todaysGlucoseLevel = [];
  List<String> last7DaysGlucoseLevel = [];
  List<String> last30DaysGlucoseLevel = [];
  @override
  void onInit() {
    //estimatedGlucoseValues();
    super.onInit();
  }

  estimatedGlucoseValues() async {
    todaysGlucoseLevel.clear();
    last7DaysGlucoseLevel.clear();
    last30DaysGlucoseLevel.clear();
    var response = await platform.invokeMethod('QueryCredentials');
    // var parsedData = jsonDecode(response);
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

    print('today');
    print(todaysGlucoseLevel);
    print('last 7 days');
    print(last7DaysGlucoseLevel);
    print('last 30 days');
    print(last30DaysGlucoseLevel);
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

  gMI(List<String> glucoseLevel) {
    totalGlucose=0;
    if (glucoseLevel.isNotEmpty) {
      for (var e in glucoseLevel) {
        totalGlucose = int.parse(e) + totalGlucose;
      }
    }
    var averageBloodGlucose = totalGlucose / todaysGlucoseLevel.length;
     gMIpercentage.value =( val1 + (val2* averageBloodGlucose));
     print('gmi value: $gMIpercentage');
  }


}
