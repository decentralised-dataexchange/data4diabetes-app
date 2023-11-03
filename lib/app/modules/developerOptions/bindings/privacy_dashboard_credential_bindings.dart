
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controllers/privacy_dashboard_credential_controller.dart';

class PrivacyDashboardCredentialsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyDashboardCredentialController>(
          () => PrivacyDashboardCredentialController(),
    );
  }
}