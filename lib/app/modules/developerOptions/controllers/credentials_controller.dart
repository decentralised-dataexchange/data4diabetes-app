import 'package:Data4Diabetes/app/core/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../launcher/views/launcher_view.dart';
import '../views/dexcom_credential_view.dart';
import '../views/privacy_dashboard_credential_view.dart';

class CredentialsController extends BaseController{
setPrivacyDashboardCred(){
Get.to(PrivacyDashboardCredentialView());
}
setDexcomCred(){
  Get.to(DexcomCredentialView());
}
deleteWallet() async {
  // delete wallet
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
  platform.invokeMethod('DeleteWallet');
  Get.rawSnackbar(
      message: "Wallet deleted successfully",
      backgroundColor: Colors.green);
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  Set<String> keys = _prefs.getKeys();

  for (String key in keys) {
    if (key != 'languageCode') {
      await _prefs.remove(key);
    }
  }
  Get.offAll(const LauncherView());
}
}