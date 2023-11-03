
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controllers/dexcom_credential_controller.dart';

class DexcomCredentialsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DexcomCredentailController>(
          () => DexcomCredentailController(),
    );
  }
}