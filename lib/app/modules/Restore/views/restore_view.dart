import 'package:Data4Diabetes/app/Constants/Palette.dart';
import 'package:Data4Diabetes/app/core/values/app_colors.dart';
import 'package:Data4Diabetes/app/core/values/text_styles.dart';
import 'package:Data4Diabetes/app/modules/main/views/main_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/restore_controller.dart';
import '/app/core/base/base_view.dart';
import '/app/core/widget/custom_app_bar.dart';

class RestoreView extends BaseView<RestoreController> {
  static const double headingFontSize = 22;
  static const double headingSizedBoxHeight = 40;
  static const double buttonSizedBoxHeight = 16;
  static const double buttonPadding = 14;
  static const double buttonBorderRadius = 10;
  static const double buttonTextFontSize = 16;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: "Restore",
    );
  }

  final RestoreController _restoreController = Get.find();

  @override
  Widget body(BuildContext context) {
      return Scaffold(
        backgroundColor: Palette.backgroundColor,
        body:  Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _headingWidget(),
                SizedBox(height: headingSizedBoxHeight),

                _restoreButtonWidget(),

                SizedBox(height: buttonSizedBoxHeight),

                _skipButtonWidget(),
              ],
            ),
          ),
        ),
      );
  }

  Widget _headingWidget() {
    return Text(
      "Do you want to restore the backup?",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: headingFontSize,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _restoreButtonWidget() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _restoreController.restore();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: buttonPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          ),
          backgroundColor: AppColors.colorAccent,
        ),
        child: Text(
          "Restore",
          style: boldTitleWhiteStyle,
        ),
      ),
    );
  }

  Widget _skipButtonWidget() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Get.offAll(MainView());
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: buttonPadding),
          side: BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          ),
        ),
        child: Text(
          "Skip",
          style: TextStyle(fontSize: buttonTextFontSize, color: Colors.black87),
        ),
      ),
    );
  }
}
