import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/app/core/base/base_controller.dart';

class SettingsController extends BaseController {
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
  final ver = Rx<String>("");
  String build = "";

  RxString languageCode = 'en'.obs;

  @override
  void onInit() {
    packageInfo();
    super.onInit();
    languageCode.value = Get.locale?.languageCode ?? 'en';
  }

  packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    ver.value = packageInfo?.version ?? "";
    print(ver.value);
    build = packageInfo?.buildNumber ?? "";
  }

  void refreshLanguage() {
    languageCode.value = Get.locale?.languageCode ?? 'en';
  }
}
