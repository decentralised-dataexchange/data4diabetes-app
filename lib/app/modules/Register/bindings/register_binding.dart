

import 'package:Data4Diabetes/app/modules/Register/controllers/register_controller.dart';
import 'package:get/get.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(),
      fenix: true,
    );


  }
}
