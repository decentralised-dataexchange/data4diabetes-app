import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  RxString languageCode = 'en'.obs;
  final PreferenceManagerImpl _preferenceManagerImpl = PreferenceManagerImpl();
  final UserRepositoryImpl _impl = UserRepositoryImpl();
  int successWithoutContent = 204;
  int unauthorizedStatusCode = 400;

  @override
  void onInit() {
    packageInfo();
    super.onInit();
    languageCode.value = Get.locale?.languageCode ?? 'en';
  }

  packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    ver.value = packageInfo?.version ?? "";
    build.value = packageInfo?.buildNumber ?? "";
  }

  void refreshLanguage() {
    languageCode.value = Get.locale?.languageCode ?? 'en';
  }

  Future<void> logout() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
    Get.offAll(const LauncherView());
  }

  void deleteAccount() async {
    int response = await _impl.deleteUserAccount();
    debugPrint('this is the response:$response');
    if (response == successWithoutContent) {
      GetSnackToast(
          message: appLocalization.settingsDeleteAccountSuccess,
          color: Colors.green);
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.clear();
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
}
