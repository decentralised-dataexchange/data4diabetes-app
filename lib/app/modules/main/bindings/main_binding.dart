import 'package:Data4Diabetes/app/modules/language/controllers/language_controller.dart';
import 'package:Data4Diabetes/app/modules/scan_and_check/controllers/scanAndCheck_controller.dart';
import 'package:Data4Diabetes/app/modules/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';

import '/app/modules/home/controllers/home_controller.dart';
import '/app/modules/main/controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
      fenix: true,
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true,
    );
    Get.lazyPut<ScanAndCheckController>(
          () => ScanAndCheckController(),
      fenix: true,
    );
    Get.lazyPut<SettingsController>(
          () => SettingsController(),
      fenix: true,
    );
    Get.lazyPut<LanguageController>(
          () => LanguageController(),
      fenix: true,
    );
  }
}
