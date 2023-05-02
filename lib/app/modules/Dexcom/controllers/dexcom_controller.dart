
import 'dart:ui';

import 'package:webview_flutter/webview_flutter.dart';

import '/app/core/base/base_controller.dart';

class DexcomController extends BaseController {
  late final WebViewController controller;
  var clientID='Gf2kuGsl8xsvP2Ijdpywdwttto3Dzkrz';
  @override
  void onInit() {
    DexcomLogin();
    super.onInit();
  }
  DexcomLogin(){
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            return;
          },
          onPageStarted: (String url) {
            return;
          },
          onPageFinished: (String url) {
            return;
          },
          onWebResourceError: (WebResourceError error) {
            return;
          },
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            // return NavigationDecision.prevent;
            // }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://api.dexcom.com/v2/oauth2/login?client_id=$clientID&response_type=code&scope=offline_access'));
  }

}
