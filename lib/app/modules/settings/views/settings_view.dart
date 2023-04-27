import 'package:Data4Diabetes/app/Constants/Palette.dart';
import 'package:Data4Diabetes/app/modules/language/views/language_view.dart';
import 'package:Data4Diabetes/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_view.dart';
import '/app/core/widget/custom_app_bar.dart';
import 'dart:io' show Platform;

class SettingsView extends BaseView<SettingsController> {
  static const double containerHeight = 400;
  static const double containerRaduis = 20;
  static const double switchScaleSize = 0.9;
  static const double imagelogoHeight = 100;
  var switchValue = false.obs;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Settings',
    );
  }

  final SettingsController _settingsController = SettingsController();

  @override
  Widget body(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Palette.backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _settingsSection1(),
                _settingsSection2(),
              ],
            ),
          ),
          bottomNavigationBar: _igrantLogo(),
        ));
  }

  Widget _settingsSection1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Palette.white,
            border: Border.all(color: Palette.white),
            borderRadius: BorderRadius.all(Radius.circular(containerRaduis))),
        child: Column(
          children: [
            _myWalletWidget(),
            const Divider(),
            _mySharedDataWidget(),
            const Divider(),
            _preferenceWidget(),
            const Divider(),
            _notifications(),
          ],
        ),
      ),
    );
  }

  Widget _settingsSection2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Palette.white,
            border: Border.all(color: Palette.white),
            borderRadius: BorderRadius.all(Radius.circular(containerRaduis))),
        child: Column(
          children: [
            _languageWidget(controller),
            const Divider(),
            _securityWidget(controller),
          ],
        ),
      ),
    );
  }

  Widget _languageWidget(SettingsController controller) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      title: Text(
        controller.appLocalization.settingsLanguage,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      onTap: () {
        Get.to(LanguageView());
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            (controller.languageCode.value) == 'en'
                ? controller.appLocalization.settingsEnglish
                : controller.appLocalization.settingsSwedish,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 14,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _securityWidget(SettingsController controller) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      title: Text(
        controller.appLocalization.settingsSecurity,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      trailing: Transform.scale(
        scale: switchScaleSize,
        child: Obx(() {
          return CupertinoSwitch(
            value: switchValue.value,
            activeColor: CupertinoColors.activeGreen,
            onChanged: (bool? value) {
              switchValue.value = value ?? false;
            },
          );
        }),
      ),
    );
  }

  Widget _myWalletWidget() {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      title: Text(
        controller.appLocalization.settingsMyWallet,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15.0,
      ),
      onTap: () {
        if (Platform.isAndroid) {
          _settingsController.platform.invokeMethod('Wallet');
        } else if (Platform.isIOS) {
          showToast('Coming soon');
        }
      },
    );
  }

  Widget _mySharedDataWidget() {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      title: Text(
        controller.appLocalization.settingsMySharedData,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15.0,
      ),
      onTap: () {
        if (Platform.isAndroid) {
          _settingsController.platform.invokeMethod('MySharedData');
        } else if (Platform.isIOS) {
          showToast('Coming soon');
        }
      },
    );
  }

  Widget _preferenceWidget() {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      title: Text(
        controller.appLocalization.settingsPrivacyDashboard,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15.0,
      ),
      onTap: () {
        if (Platform.isAndroid) {
          _settingsController.platform.invokeMethod('Preferences');
        } else if (Platform.isIOS) {
          showToast('Coming soon');
        }
      },
    );
  }

  Widget _igrantLogo() {
    _settingsController.packageInfo();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'images/igrant_icon.png',
          height: imagelogoHeight,
        ),
        Text("v " + _settingsController.ver.value),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _notifications() {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      title: Text(
        controller.appLocalization.settingsNotification,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15.0,
      ),
      onTap: () {
        if (Platform.isAndroid) {
          _settingsController.platform.invokeMethod('Notifications');
        } else if (Platform.isIOS) {
          showToast('Coming soon');
        }
      },
    );
  }
}
