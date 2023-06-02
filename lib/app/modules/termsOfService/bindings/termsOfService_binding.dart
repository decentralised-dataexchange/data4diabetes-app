

import 'package:Data4Diabetes/app/modules/privacyPolicy/controllers/privacyPolicy_controller.dart';
import 'package:Data4Diabetes/app/modules/termsOfService/controllers/termsOfService_controller.dart';
import 'package:get/get.dart';

class TermsOfServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsOfServiceController>(
          () => TermsOfServiceController(),
      fenix: true,
    );


  }
}
