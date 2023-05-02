import 'package:Data4Diabetes/app/modules/Dexcom/controllers/dexcom_controller.dart';
import 'package:get/get.dart';


class DexcomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DexcomController>(
          () => DexcomController(),
    );
  }
}
