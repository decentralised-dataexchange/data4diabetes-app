import 'dart:ui';

import 'package:get/get.dart';

import '../../../LanguageSupport.dart';
import '/app/core/base/base_controller.dart';
import '/app/modules/main/model/menu_code.dart';

class MainController extends BaseController {
  final _selectedMenuCodeController = MenuCode.HOME.obs;

  MenuCode get selectedMenuCode => _selectedMenuCodeController.value;

  final lifeCardUpdateController = false.obs;

  @override
  void onInit() async {
    super.onInit();

    var locales = Locale(await getLocale());

    if (locales.languageCode == "en") {
      locales = Locale(ENGLISH);
      setLocale(ENGLISH);
      Get.updateLocale(locales);
      print("english");
    } else if (locales.languageCode == "sv") {
      locales = Locale(SWEDISH);
      setLocale(SWEDISH);
      Get.updateLocale(locales);
      print("swedish");
    }
  }

  onMenuSelected(MenuCode menuCode) async {
    _selectedMenuCodeController(menuCode);
  }
}
