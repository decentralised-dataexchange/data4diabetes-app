

import 'package:Data4Diabetes/app/modules/privacyPolicy/controllers/privacyPolicy_controller.dart';
import 'package:get/get.dart';

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyController>(
          () => PrivacyPolicyController(),
      fenix: true,
    );


  }
}
