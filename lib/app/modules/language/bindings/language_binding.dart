import 'package:Data4Diabetes/app/modules/language/controllers/language_controller.dart';
import 'package:get/get.dart';


class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageController>(
      () => LanguageController(),
    );
  }
}
