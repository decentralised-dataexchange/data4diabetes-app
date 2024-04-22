import 'package:Data4Diabetes/app/data/model/deleteAccount/deleteAccountRequest.dart';
import 'package:flutter/cupertino.dart';

import 'package:Data4Diabetes/app/modules/Dexcom/controllers/dexcom_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../flavors/build_config.dart';
import '../../../data/local/preference/preference_manager_impl.dart';
import '../../../data/repository/user_repository_impl.dart';
import '../../Dexcom/controllers/dexcom_controller.dart';
import '../../Dexcom/views/dexcom_view.dart';
import '../../launcher/views/launcher_view.dart';
import '/app/core/base/base_controller.dart';

class SettingsController extends BaseController {
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
  final ver = Rx<String>("");
  final build = Rx<String>("");
  RxString languageCode = ''.obs;
  final UserRepositoryImpl _impl = UserRepositoryImpl();
  int successWithoutContent = 204;
  int unauthorizedStatusCode = 400;

  var firstRadioButtonSelected = true.obs;
  final DexcomController _dexcomController = Get.find();
  @override
  void onInit() {
    packageInfo();
    super.onInit();
    languageCode.value = Get.locale?.languageCode ?? '';
  }

  packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    ver.value = packageInfo?.version ?? "";
    build.value = packageInfo?.buildNumber ?? "";
  }

  void refreshLanguage() async {
    languageCode.value = Get.locale?.languageCode ?? '';
  }

  Future<void> logout() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    // _prefs.clear();
    Set<String> keys = _prefs.getKeys();

    for (String key in keys) {
      if (key != 'languageCode') {
        await _prefs.remove(key);
      }
    }
    //delete wallet
    platform.invokeMethod('DeleteWallet');
    Get.offAll(const LauncherView());
  }

  void deleteAccount() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var mobileNumber= _prefs.getString('userMobileNumber');
    print("user mobile number with code is :$mobileNumber");
    DeleteAccountRequest request =
    DeleteAccountRequest(mobile_number: mobileNumber);
    int response = await _impl.deleteUserAccount(request);
    debugPrint('this is the response:$response');
    if (response == successWithoutContent) {
      GetSnackToast(
          message: appLocalization.settingsDeleteAccountSuccess,
          color: Colors.green);
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.clear();
      // delete wallet
      platform.invokeMethod('DeleteWallet');
      Get.offAll(const LauncherView());
    } else {
      GetSnackToast(message: appLocalization.settingsDeleteAccountFail);
    }
  }

  void dexcomLoginWidget(BuildContext context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('access_token');
    if (token == null) {
      Get.to(DexcomView());
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(appLocalization.settingsAlert),
            content: Text(appLocalization.settingsDexcomAlert),
            actions: [
              CupertinoDialogAction(
                child: Text(appLocalization.settingsDexcomLoginYes),
                onPressed: () {
                  _prefs.remove('access_token');
                  Get.back();
                },
              ),
              CupertinoDialogAction(
                child: Text(appLocalization.settingsDexcomLoginNo),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void defaultDexcomEnvironment() {
    _dexcomController.dexComBaseUrl.value =
        BuildConfig.instance.config.dexComBaseUrl!;
  }

  void limitedDexcomEnvironment() {
    _dexcomController.dexComBaseUrl.value = 'https://api.dexcom.com';
    print('changed url${_dexcomController.dexComBaseUrl.value}');
  }
}
