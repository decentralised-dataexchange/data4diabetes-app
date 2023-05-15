
import 'package:Data4Diabetes/app/modules/termsOfService/controllers/termsOfService_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/widget/custom_app_bar.dart';
import '/app/core/base/base_view.dart';

class TermsOfServiceView extends BaseView<TermsOfServiceController> {

  final TermsOfServiceController _termsOfServiceController = Get.find();

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: '',
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget body(BuildContext context) {
    return WebViewWidget(controller: _termsOfServiceController.controller);
  }

}
