
import 'package:flutter/material.dart';

import '/app/core/base/base_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
class PrivacyPolicyController extends BaseController {
  int maxProgressValue=100;
  late final WebViewController controller;
  @override
  void onInit() {

    initiateWebView();
    super.onInit();

  }
  initiateWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress != maxProgressValue) {
              showLoading();
            } else {
              hideLoading();
            }

            return;
          },
          onPageStarted: (String url) {
            /// show progress on loading
            showLoading();

            return;
          },
          onPageFinished: (String url) {
            /// stop progress after loading
            hideLoading();

            return;
          },
          onWebResourceError: (WebResourceError error) {
            return;
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://igrant.io/privacy.html#privacy_policy'));
  }

}
