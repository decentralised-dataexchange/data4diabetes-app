import 'dart:convert';
import 'dart:ui';

import 'package:Data4Diabetes/app/Constants/privacy_dashboard.dart';
import 'package:Data4Diabetes/app/core/base/base_controller.dart';
import 'package:Data4Diabetes/app/modules/Register/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../language/controllers/language_controller.dart';
import '../../login/views/login_view.dart';

class DataAgreementContoller extends BaseController {
  final RegisterController _registerController = Get.find();
  WebViewController? controller;
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
  final LanguageController _languageController= Get.find();
  var thirdPartyOrgName = "Data4Diabetes";
  String? accessToken;
  var redirectUrl = "https://www.govstack.global/";
  invokeDataAgreement() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
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
            var languageCode = _languageController.languageCode.value;
            if (request.url.startsWith(redirectUrl)) {
              final uri = Uri.parse(request.url);
              if (uri.queryParameters.containsKey('error')) {
                // Handle error response
                String? error = uri.queryParameters['error'];
                String? errorDescription =
                    uri.queryParameters['errorDescription'];
                GetSnackToast(
                    message: errorDescription ?? "something went wrong");
                Get.off(LoginView());
                _registerController.firstNameController.clear();
                _registerController.mobileNumberController.clear();
              } else if (uri.queryParameters.containsKey('credentials')) {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                var userId = _prefs.getString('privacyDashboarduserId');
                try {
                  showLoading();
                  var response = await platform.invokeMethod('DataSharing', {
                    "apiKey": PrivacyDashboard().apiKey,
                    "userId": userId,
                    "dataAgreementID": PrivacyDashboard().registrationDataAgreementId,
                    "baseUrl": PrivacyDashboard().baseUrl,
                    "languageCode": languageCode
                  });
                  Map<String, dynamic> responseMap = json.decode(response);
                  if (responseMap['optIn'] == true) {
                   _registerController.getDataAgreement(sharingDataAgreementID: PrivacyDashboard().donateYourDataDataAgreementId,isFlag:true);
                    Get.back();
                    int index = _registerController.selectedPage.value + 1;
                    _registerController.pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  } else {
                    GetSnackToast(message: 'something went wrong');
                  }
                  hideLoading();
                } catch (e) {
                  hideLoading();
                  GetSnackToast(message: e.toString());
                }
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://staging-consent-bb-iam.igrant.io/realms/3pp-application/protocol/openid-connect/auth?client_id=3pp&response_type=code&redirect_uri=https%3A%2F%2Fstaging-consent-bb-api.igrant.io%2Fv2%2Fservice%2Fdata-sharing%3FdataAgreementId%3D654cf0db9684ed907ce07c5f%26thirdPartyOrgName%3DData4Diabetes%26dataSharingUiRedirectUrl%3Dhttps%3A%2F%2Fwww.govstack.global%2F'));
  }
}
