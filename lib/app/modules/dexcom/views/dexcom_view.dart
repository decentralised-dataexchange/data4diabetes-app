import 'package:Data4Diabetes/app/modules/Dexcom/controllers/dexcom_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '/app/core/base/base_view.dart';
import '/app/core/widget/custom_app_bar.dart';

class DexcomView extends BaseView<DexcomController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: '',
      backgroundColor: Colors.white,
    );
  }

  final DexcomController _dexcomController = Get.find();
  @override
  Widget body(BuildContext context) {
    return WebViewWidget(controller: _dexcomController.controller);
  }
}
