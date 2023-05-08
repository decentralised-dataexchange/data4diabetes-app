import 'package:Data4Diabetes/app/modules/Otp/controllers/otp_controller.dart';
import 'package:Data4Diabetes/app/modules/privacyPolicy/controllers/privacyPolicy_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widget/custom_app_bar.dart';
import '/app/core/base/base_view.dart';

class PrivacyPolicyView extends BaseView<PrivacyPolicyController> {

  final PrivacyPolicyController _privacyPolicyController = Get.find();

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: '',
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget body(BuildContext context) {
   return WebViewWidget(controller: _privacyPolicyController.controller);
  }

}
