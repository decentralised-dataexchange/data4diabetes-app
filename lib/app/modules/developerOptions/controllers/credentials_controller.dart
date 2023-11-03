import 'package:Data4Diabetes/app/core/base/base_controller.dart';

import 'package:get/get.dart';

import '../views/dexcom_credential_view.dart';
import '../views/privacy_dashboard_credential_view.dart';

class CredentialsController extends BaseController{
setPrivacyDashboardCred(){
Get.to(PrivacyDashboardCredentialView());
}
setDexcomCred(){
  Get.to(DexcomCredentialView());
}
}