import 'package:package_info_plus/package_info_plus.dart';

import '/app/core/base/base_controller.dart';

class SettingsController extends BaseController {
  String ver="";
  String build="";
  @override
  void onInit() {
    packageInfo();
    super.onInit();
  }

  packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    ver = packageInfo?.version ?? "";
    build = packageInfo?.buildNumber ?? "";
  }
}
