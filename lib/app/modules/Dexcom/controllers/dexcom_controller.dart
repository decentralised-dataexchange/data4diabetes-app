import 'dart:ui';

import 'package:webview_flutter/webview_flutter.dart';

import '/app/core/base/base_controller.dart';

class DexcomController extends BaseController {
  late final WebViewController controller;
  var clientID = 'Gf2kuGsl8xsvP2Ijdpywdwttto3Dzkrz';
  var redirectUri = "https://data4diabetes.com/abc";

  //sandbox
  //use this to get the code without login access(for testing)
  var dexComBaseUrl = "https://sandbox-api.dexcom.com";

  /*//prod
  var dexComBaseUrl = "https://api.dexcom.com";*/

  @override
  void onInit() {
    DexcomLogin();
    super.onInit();
  }

  DexcomLogin() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            return;
          },
          onPageStarted: (String url) {
            //todo show progress on loading
            return;
          },
          onPageFinished: (String url) {
            //todo stop progress after loading
            return;
          },
          onWebResourceError: (WebResourceError error) {
            return;
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(redirectUri)) {

              //todo get the code from here then continue our process
              print(request.url);

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          '$dexComBaseUrl/v2/oauth2/login?client_id=$clientID&redirect_uri=$redirectUri&response_type=code&scope=offline_access'));
  }
}
