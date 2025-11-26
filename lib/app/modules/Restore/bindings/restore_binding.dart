import 'package:Data4Diabetes/app/modules/Restore/controllers/restore_controller.dart';
import 'package:get/get.dart';

class RestoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestoreController>(
          () => RestoreController(),
    );
  }
}