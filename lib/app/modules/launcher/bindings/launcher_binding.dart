import 'package:Data4Diabetes/app/modules/launcher/controller/launcher_controller.dart';
import 'package:get/get.dart';
import '../../Otp/controllers/otp_controller.dart';
import '../../Register/controllers/register_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../language/controllers/language_controller.dart';
import '../../login/controllers/login_controller.dart';
import '../../main/controllers/main_controller.dart';
import '../../scan_and_check/controllers/scanAndCheck_controller.dart';
import '../../settings/controllers/settings_controller.dart';


class LauncherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LauncherController>(
          () => LauncherController(),
      fenix: true,
    );
    Get.lazyPut<LoginController>(
          () => LoginController(),
      fenix: true,
    );
    Get.lazyPut<OtpController>(
          () => OtpController(),
      fenix: true,

    );
    Get.lazyPut<RegisterController>(
          () => RegisterController(),
      fenix: true,

    );
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