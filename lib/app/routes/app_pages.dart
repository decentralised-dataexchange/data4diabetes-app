import 'package:Data4Diabetes/app/modules/Otp/bindings/otp_binding.dart';
import 'package:Data4Diabetes/app/modules/Otp/views/otp_view.dart';
import 'package:Data4Diabetes/app/modules/Register/bindings/register_binding.dart';
import 'package:Data4Diabetes/app/modules/Register/views/register_view.dart';
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
import 'package:get/get.dart';

import '../data/local/preference/preference_manager_impl.dart';
import '/app/modules/home/bindings/home_binding.dart';
import '/app/modules/home/views/home_view.dart';
import '/app/modules/main/bindings/main_binding.dart';
import '/app/modules/main/views/main_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const INITIAL = Routes.LAUNCHER;

  static final routes = [
    GetPage(name:_Paths.LAUNCHER ,
      page: () => LauncherView(),
      binding: LauncherBinding(),),
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
      name: _Paths.PRIVACYPOLICY,
      page: () => PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
  ];
}
