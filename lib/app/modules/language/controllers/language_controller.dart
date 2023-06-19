import 'package:Data4Diabetes/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../LanguageSupport.dart';
import '/app/core/base/base_controller.dart';

class LanguageController extends BaseController {
  RxString languageCode = ''.obs;

  @override
  void onInit() async {
    super.onInit();
  //  languageCode.value = Get.locale?.languageCode ?? 'en';
    getLanguageCode();
  }
  getLanguageCode()async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    languageCode.value= _prefs.getString('languageCode')!;
  }
  void updateLanguage(BuildContext context, String langauge) async {
    if (langauge == 'English') {
      var locale = const Locale(ENGLISH);
      setLocale(ENGLISH);
      await Get.updateLocale(locale);
      print("english clicked");
      languageCode.value = 'en';
    } else {
      var locale = const Locale(SWEDISH);
      setLocale(SWEDISH);
      await Get.updateLocale(locale);
      print("swedish clicked");
      languageCode.value = 'sv';
    }
    final SettingsController sideMenuController = Get.find();
    sideMenuController.refreshLanguage();
  }
}
