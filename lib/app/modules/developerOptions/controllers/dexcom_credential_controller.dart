import 'package:Data4Diabetes/app/core/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../flavors/build_config.dart';
import '../../Dexcom/controllers/dexcom_controller.dart';

class DexcomCredentailController extends BaseController{
  final DexcomController _dexcomController = Get.find();
  var firstRadioButtonSelected = true.obs;
  final TextEditingController baseUrlController = TextEditingController();
  @override
  void onInit() async {
    super.onInit();
    // Retrieve the stored value from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getBool('firstRadioButtonSelected');

    if (storedValue != null) {
      // Use the stored value if it exists
      firstRadioButtonSelected.value = storedValue;
    } else {
      // If no value is stored, set the default value
      firstRadioButtonSelected.value = true;

      // You may also want to store the default value
      prefs.setBool('firstRadioButtonSelected', true);
    }
  }
  // Update the selected value and store it in SharedPreferences
  void updateSelectedValue(bool value) async {
    firstRadioButtonSelected.value = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstRadioButtonSelected', value);
  }
  Future<void> defaultDexcomEnvironment() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('dexcomStoredBaseUrl', BuildConfig.instance.config.dexComBaseUrl!);
    _dexcomController.dexComBaseUrl.value =
    BuildConfig.instance.config.dexComBaseUrl!;
    Get.rawSnackbar(message: 'Dexcom environment has been changed successfully',backgroundColor: Colors.green);
  }

  Future<void> limitedDexcomEnvironment() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('dexcomStoredBaseUrl', 'https://api.dexcom.com');
    _dexcomController.dexComBaseUrl.value = 'https://api.dexcom.com';

   print('changed url${_dexcomController.dexComBaseUrl.value}');
    Get.rawSnackbar(message: 'Dexcom environment has been changed successfully',backgroundColor: Colors.green);
  }
}