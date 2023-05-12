
import 'package:get/get.dart';

import '/app/core/base/base_controller.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
class InsightsController extends BaseController {
  final List<String> items = ['TODAY', 'LAST 7 DAYS', 'LAST 30 DAYS'];
  RxString selectedValue = 'TODAY'.obs;


}
class MyData {
  final String category;
  final int value1;


  MyData(this.category, this.value1);
}