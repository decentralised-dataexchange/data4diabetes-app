import 'package:Data4Diabetes/app/data/remote/user_remote_data_source.dart';
import 'package:Data4Diabetes/app/modules/Otp/controllers/otp_controller.dart';
import 'package:Data4Diabetes/app/modules/Register/controllers/register_controller.dart';
import 'package:Data4Diabetes/app/modules/dataSharing/controllers/dataAgreement_controller.dart';
import 'package:Data4Diabetes/app/modules/insights/controllers/insights_controller.dart';
import 'package:Data4Diabetes/app/modules/login/controllers/login_controller.dart';
import 'package:Data4Diabetes/app/modules/privacyPolicy/controllers/privacyPolicy_controller.dart';
import 'package:get/get.dart';

import '../../../bindings/initial_binding.dart';
import '../../developerOptions/controllers/credentials_controller.dart';
import '../../developerOptions/controllers/dexcom_credential_controller.dart';
import '../../developerOptions/controllers/privacy_dashboard_credential_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../language/controllers/language_controller.dart';
import '../../main/controllers/main_controller.dart';
import '../../scan_and_check/controllers/scanAndCheck_controller.dart';
import '../../services/controllers/services_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import '../../termsOfService/controllers/termsOfService_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
      fenix: true,
    );
    Get.lazyPut<OtpController>(
      () => OtpController(),
      fenix: true,
    );
    Get.lazyPut<RegisterController>(
      () => RegisterController(),
      fenix: true,
    );
    Get.lazyPut<MainController>(
      () => MainController(),
      fenix: true,
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true,
    );
    Get.lazyPut<ScanAndCheckController>(
      () => ScanAndCheckController(),
      fenix: true,
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
      fenix: true,
    );
    Get.lazyPut<LanguageController>(
      () => LanguageController(),
      fenix: true,
    );
    Get.lazyPut<PrivacyPolicyController>(
      () => PrivacyPolicyController(),
      fenix: true,
    );

    Get.lazyPut<InsightsController>(
      () => InsightsController(),
      fenix: true,
    );
    Get.lazyPut<TermsOfServiceController>(
          () => TermsOfServiceController(),
      fenix: true,
    );
    Get.lazyPut<CredentialsController>(
          () => CredentialsController(),
      fenix: true,
    );
    Get.lazyPut<PrivacyDashboardCredentialController>(
          () => PrivacyDashboardCredentialController(),
      fenix: true,
    );
    Get.lazyPut<DexcomCredentailController>(
          () => DexcomCredentailController(),
      fenix: true,
    );
    Get.lazyPut<DataAgreementContoller>(
          () => DataAgreementContoller(),
      fenix: true,
    );
    Get.lazyPut<ServicesController>(
          () => ServicesController(),
      fenix: true,
    );
  }
}
