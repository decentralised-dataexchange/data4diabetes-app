import 'package:Data4Diabetes/app/network/ApiEndPoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/local/preference/preference_manager_impl.dart';
import '../../../data/repository/user_repository_impl.dart';
import '../../../network/http_provider.dart';
import '../../launcher/views/launcher_view.dart';
import '/app/core/base/base_controller.dart';

class SettingsController extends BaseController {
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
  final ver = Rx<String>("");
  final build = Rx<String>("");
  RxString languageCode = 'en'.obs;
  final HttpProvider _httpProvider = HttpProvider();
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
    var token = await _preferenceManagerImpl.getString('token');
    int response = await _httpProvider.deleteAccount(
        url: ApiEndPoints.deleteAccount, token: token);
    if (response == successWithoutContent) {
      GetSnackToast(
          message: appLocalization.settingsDeleteAccountSuccess, color: Colors.green);
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.clear();
      Get.offAll(const LauncherView());
    } else if (response == unauthorizedStatusCode) {
      GetSnackToast(message:appLocalization.settingsDeleteAccountFail);
    }
  }
}
