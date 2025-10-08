import 'package:flutter/services.dart';

import '/app/core/base/base_controller.dart';

import 'package:flutter/services.dart';
import '/app/core/base/base_controller.dart';
import 'package:get/get.dart';

class HomeController extends BaseController {
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');

  // Reactive glucose value
  var glucoseValue = 0.0.obs; // initial default value

  // Method to update glucose
  void updateGlucose(double value) {
    glucoseValue.value = value;
  }
}