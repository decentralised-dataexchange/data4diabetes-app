
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/local/preference/preference_manager_impl.dart';
import '../../../data/repository/user_repository_impl.dart';
import '../../launcher/views/launcher_view.dart';
import '/app/core/base/base_controller.dart';

class SettingsController extends BaseController {
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
  final ver = Rx<String>("");
  final build = Rx<String>("");
  RxString languageCode = ''.obs;
  final PreferenceManagerImpl _preferenceManagerImpl = PreferenceManagerImpl();
  final UserRepositoryImpl _impl = UserRepositoryImpl();
  int successWithoutContent = 204;
  int unauthorizedStatusCode = 400;
  @override
  void onInit() {
    packageInfo();
    getLanguageCode();
    super.onInit();
    // languageCode.value = Get.locale?.languageCode??'';
  }
  getLanguageCode()async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    languageCode.value= _prefs.getString('languageCode')!;
  }

  packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    ver.value = packageInfo?.version ?? "";
    build.value = packageInfo?.buildNumber ?? "";
  }

  void refreshLanguage() async{
    //languageCode.value = Get.locale?.languageCode ?? 'en';
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    languageCode.value= _prefs.getString('languageCode')!;
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
    Get.offAll(const LauncherView());
  }

  void deleteAccount() async {
    int response= await _impl.deleteUserAccount();
    debugPrint('this is the response:$response');
    if(response == successWithoutContent){
      GetSnackToast(
                message: appLocalization.settingsDeleteAccountSuccess, color: Colors.green);
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            _prefs.clear();
            Get.offAll(const LauncherView());
    }
    else{
      GetSnackToast(message:appLocalization.settingsDeleteAccountFail);
    }
  }
}
