
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controllers/credentials_controller.dart';

class CredentialsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CredentialsController>(
          () => CredentialsController(),
    );
  }
}