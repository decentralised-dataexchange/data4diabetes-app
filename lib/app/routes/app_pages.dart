import 'package:Data4Diabetes/app/modules/Dexcom/bindings/dexcom_bindings.dart';
import 'package:Data4Diabetes/app/modules/Dexcom/views/dexcom_view.dart';
import 'package:Data4Diabetes/app/modules/Otp/bindings/otp_binding.dart';
import 'package:Data4Diabetes/app/modules/Otp/views/otp_view.dart';
import 'package:Data4Diabetes/app/modules/Register/bindings/register_binding.dart';
import 'package:Data4Diabetes/app/modules/Register/views/register_view.dart';
import 'package:Data4Diabetes/app/modules/dataSharing/binding/dataAgreement_binding.dart';
import 'package:Data4Diabetes/app/modules/dataSharing/views/dataAgreement_view.dart';
import 'package:Data4Diabetes/app/modules/insights/bindings/insights_binding.dart';
import 'package:Data4Diabetes/app/modules/insights/views/insights_view.dart';
import 'package:Data4Diabetes/app/modules/language/bindings/language_binding.dart';
import 'package:Data4Diabetes/app/modules/language/views/language_view.dart';
import 'package:Data4Diabetes/app/modules/launcher/bindings/launcher_binding.dart';
import 'package:Data4Diabetes/app/modules/launcher/views/launcher_view.dart';
import 'package:Data4Diabetes/app/modules/login/bindings/login_binding.dart';
import 'package:Data4Diabetes/app/modules/login/views/login_view.dart';
import 'package:Data4Diabetes/app/modules/privacyPolicy/bindings/privacyPolicy_binding.dart';
import 'package:Data4Diabetes/app/modules/privacyPolicy/views/privacyPolicy_view.dart';
import 'package:Data4Diabetes/app/modules/scan_and_check/bindings/scanAndCheck_binding.dart';
import 'package:Data4Diabetes/app/modules/scan_and_check/views/scanAndCheck_view.dart';
import 'package:Data4Diabetes/app/modules/settings/bindings/settings_binding.dart';
import 'package:Data4Diabetes/app/modules/settings/views/settings_view.dart';
import 'package:Data4Diabetes/app/modules/termsOfService/bindings/termsOfService_binding.dart';
import 'package:Data4Diabetes/app/modules/termsOfService/views/termsOfService_view.dart';
import 'package:get/get.dart';

import '../data/local/preference/preference_manager_impl.dart';
import '../modules/developerOptions/bindings/credentials_binding.dart';
import '../modules/developerOptions/bindings/dexcom_credential_bindings.dart';
import '../modules/developerOptions/bindings/privacy_dashboard_credential_bindings.dart';
import '../modules/developerOptions/views/credentials_view.dart';
import '../modules/developerOptions/views/dexcom_credential_view.dart';
import '../modules/developerOptions/views/privacy_dashboard_credential_view.dart';
import '/app/modules/home/bindings/home_binding.dart';
import '/app/modules/home/views/home_view.dart';
import '/app/modules/main/bindings/main_binding.dart';
import '/app/modules/main/views/main_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const INITIAL = Routes.LAUNCHER;

  static final routes = [
    GetPage(
      name: _Paths.LAUNCHER,
      page: () => LauncherView(),
      binding: LauncherBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SCANANDCHECK,
      page: () => ScanAndCheckView(),
      binding: ScanAndCheckBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGE,
      page: () => LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: _Paths.DEXCOM,
      page: () => DexcomView(),
      binding: DexcomBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACYPOLICY,
      page: () => PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: _Paths.INSIGHTS,
      page: () => InsightsView(),
      binding: InsightsBinding(),
    ),
    GetPage(
      name: _Paths.TERMSOFSERVICE,
      page: () => TermsOfServiceView(),
      binding: TermsOfServiceBinding(),
    ),
    GetPage(
      name: _Paths.CREDENTIALSPANEL,
      page: () => CredentailsView(),
      binding: CredentialsBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACYDASHBOARDCREDENTIAL,
      page: () => PrivacyDashboardCredentialView(),
      binding: PrivacyDashboardCredentialsBinding(),
    ),
    GetPage(
      name: _Paths.DEXCOMCREDENTIAL,
      page: () => DexcomCredentialView(),
      binding: DexcomCredentialsBinding(),
    ),
    GetPage(
      name: _Paths.DATAAGREEMENT,
      page: () => DataAgreementView(),
      binding: DataAgreementBinding(),
    ),
  ];
}
