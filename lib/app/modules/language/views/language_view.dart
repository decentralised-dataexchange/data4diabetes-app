import 'package:Data4Diabetes/app/Constants/Palette.dart';
import 'package:Data4Diabetes/app/modules/language/controllers/language_controller.dart';
import 'package:Data4Diabetes/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_view.dart';
import '/app/core/widget/custom_app_bar.dart';
import 'package:flutter/services.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

class LanguageView extends BaseView<LanguageController> {
  static const double containerHeight = 400;
  static const double containerRaduis = 20;
  static const double switchScaleSize = 0.9;
  static const double imagelogoHeight = 100;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: controller.appLocalization.settingsLanguage,
    );
  }

  @override
  Widget body(BuildContext context) {
    return  Obx(() => Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Palette.white,
                    border: Border.all(color: Palette.white),
                    borderRadius:
                        BorderRadius.all(Radius.circular(containerRaduis))),
                child: Column(
                  children: [
                    _englishWidget(controller, context),
                    const Divider(),
                    _swedishWidget(controller,context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _englishWidget(LanguageController controller, BuildContext context) {
    return ListTile(
        dense: true,
        visualDensity: VisualDensity(horizontal: 0, vertical: -3),
        title: Text(
          controller.appLocalization.settingsEnglish,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        onTap: () {
          controller.updateLanguage(context, 'English');
        },
        trailing:
            Visibility(visible: controller.languageCode.value == 'en', child: Icon(Icons.check_circle_outline)));
  }

  Widget _swedishWidget(LanguageController controller, BuildContext context) {
    return ListTile(
        dense: true,
        visualDensity: VisualDensity(horizontal: 0, vertical: -3),
        title: Text(
          controller.appLocalization.settingsSwedish,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        onTap: () {
          controller.updateLanguage(context, 'Swedish');
        },
        trailing: Visibility(
            visible: controller.languageCode.value == 'sv', child: Icon(Icons.check_circle_outline)));
  }
}
