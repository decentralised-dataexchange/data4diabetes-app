import 'package:Data4Diabetes/app/modules/scan_and_check/controllers/scanAndCheck_controller.dart';
import 'package:get/get.dart';

class ScanAndCheckBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanAndCheckController>(
      () => ScanAndCheckController(),
    );
  }
}
