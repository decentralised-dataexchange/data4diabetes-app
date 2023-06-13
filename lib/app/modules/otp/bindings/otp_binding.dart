
import 'package:Data4Diabetes/app/modules/Otp/controllers/otp_controller.dart';
import 'package:get/get.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(
      () => OtpController(),
      fenix: true,
    );


  }
}
