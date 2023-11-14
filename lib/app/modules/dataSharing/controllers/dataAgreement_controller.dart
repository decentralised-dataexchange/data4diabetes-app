import 'dart:convert';
import 'dart:ui';

import 'package:Data4Diabetes/app/core/base/base_controller.dart';
import 'package:Data4Diabetes/app/modules/Register/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../login/views/login_view.dart';

class DataAgreementContoller extends BaseController {
  final RegisterController _registerController = Get.find();
  WebViewController? controller;
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
  var dataAgreementId = "654cf0db9684ed907ce07c5";

  var thirdPartyOrgName = "Data4Diabetes";
  String? accessToken;
  var redirectUrl = "https://www.govstack.global/";
  // invokeDataAgreement() {
  //   controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setBackgroundColor(const Color(0x00000000))
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) {
  //           // if (progress != maxProgressValue) {
  //           //   showLoading();
  //           // } else {
  //           //   hideLoading();
  //           // }
  //
  //           return;
  //         },
  //         onPageStarted: (String url) {
  //           /// show progress on loading
  //           // showLoading();
  //
  //           return;
  //         },
  //         onPageFinished: (String url) {
  //           /// stop progress after loading
  //           // hideLoading();
  //
  //           return;
  //         },
  //         onWebResourceError: (WebResourceError error) {
  //           return;
  //         },
  //         onNavigationRequest: (NavigationRequest request) async {
  //           if (request.url.startsWith('https://www.govstack.global/')) {
  //             final uri = Uri.parse(request.url);
  //             print('the response uri:${uri.queryParameters}');
  //             if (uri.queryParameters.containsKey('error')) {
  //               // Handle error response
  //               String? error = uri.queryParameters['error'];
  //               String? errorDescription = uri.queryParameters['errorDescription'];
  //               print('Error: $error, Description: $errorDescription');
  //               GetSnackToast(message: errorDescription??"something went wrong");
  //               Get.off(LoginView());
  //             } else if (uri.queryParameters.containsKey('credentials')) {
  //               // Decode the base64-encoded credentials
  //               print('got scueess data');
  //               String? credentialsBase64 = uri.queryParameters['credentials'];
  //               // Ensure that the base64 string has the correct length and padding
  //               String paddedCredentialsBase64 = credentialsBase64! + '=' * (4 - credentialsBase64.length % 4);
  //
  //               // Decode the padded base64 string
  //               List<int> bytes = base64.decode(paddedCredentialsBase64);
  //               String decodedCredentialsJson = utf8.decode(bytes);
  //
  //               Map<String, dynamic> decodedCredentials = json.decode(decodedCredentialsJson);
  //
  //               // Accessing user information
  //               Map<String, dynamic> userInfo = decodedCredentials['userInfo'];
  //               String subject = userInfo['subject'];
  //               String email = userInfo['email'];
  //               bool emailVerified = userInfo['emailVerified'];
  //
  //               print('Subject: $subject');
  //               print('Email: $email');
  //               print('Email Verified: $emailVerified');
  //
  //               // Accessing token information
  //               Map<String, dynamic> token = decodedCredentials['token'];
  //               String accessToken = token['accessToken'];
  //               int expiresIn = token['expiresIn'];
  //               String refreshToken = token['refreshToken'];
  //
  //               print('Access Token: $accessToken');
  //               print('Expires In: $expiresIn');
  //               print('Refresh Token: $refreshToken');
  //
  //               SharedPreferences _prefs = await SharedPreferences.getInstance();
  //               await _prefs.setString('dataSharingAccessToken',accessToken );
  //               await _prefs.setInt('dataSharingTokenExpiresIn',expiresIn );
  //               await _prefs.setString('dataSharingRefreshToken',refreshToken );
  //               Get.back();
  //               int index = _registerController.selectedPage.value + 1;
  //               _registerController.pageController.animateToPage(index,
  //                   duration: const Duration(milliseconds: 500),
  //                   curve: Curves.ease);
  //
  //
  //               GetSnackToast(message: 'Authorized successfully',color: Colors.green);
  //             }
  //
  //             return NavigationDecision.navigate;
  //           }
  //
  //           return NavigationDecision.navigate;
  //         },
  //       ),
  //     )
  //     ..loadRequest(Uri.parse(
  //         'https://staging-consent-bb-iam.igrant.io/realms/3pp-application/protocol/openid-connect/auth?client_id=3pp&response_type=code&redirect_uri=https%3A%2F%2Fstaging-consent-bb-api.igrant.io%2Fv2%2Fservice%2Fdata-sharing%3FdataAgreementId%3D654cf0db9684ed907ce07c5f%26thirdPartyOrgName%3DData4Diabetes%26dataSharingUiRedirectUrl%3Dhttps%3A%2F%2Fwww.govstack.global%2F'));
  // }

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
            return;
          },
          onPageFinished: (String url) {
            /// stop progress after loading
            return;
          },
          onWebResourceError: (WebResourceError error) {
            return;
          },
          onNavigationRequest: (NavigationRequest request) async {
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
                // Decode the base64-encoded credentials
                String? credentialsBase64 = uri.queryParameters['credentials'];
                // Ensure that the base64 string has the correct length and padding
                String paddedCredentialsBase64 = credentialsBase64! +
                    '=' * (4 - credentialsBase64.length % 4);
                // Decode the padded base64 string
                List<int> bytes = base64.decode(paddedCredentialsBase64);
                String decodedCredentialsJson = utf8.decode(bytes);
                Map<String, dynamic> decodedCredentials =
                    json.decode(decodedCredentialsJson);
                // Accessing user information
                // Map<String, dynamic> userInfo = decodedCredentials['userInfo'];
                // String subject = userInfo['subject'];
                // String email = userInfo['email'];
                // bool emailVerified = userInfo['emailVerified'];
                // Accessing token information
                Map<String, dynamic> token = decodedCredentials['token'];
                accessToken = token['accessToken'];
                // int expiresIn = token['expiresIn'];
                // String refreshToken = token['refreshToken'];
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                await _prefs.setString('dataSharingAccessToken', accessToken!);

                var response = await platform.invokeMethod('DataSharing', {
                  "accessToken": accessToken,
                  "dataAgreementID": "65530f3507a0b7e06bdd9383",
                  "baseUrl": "https://staging-consent-bb-api.igrant.io/v2/"
                });
                Map<String, dynamic> responseMap = json.decode(response);
                if (responseMap['optIn'] == false) {
                  Get.back();
                  int index = _registerController.selectedPage.value + 1;
                  _registerController.pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                } else {
                  GetSnackToast(message: 'something went wrong');
                }
              }

              return NavigationDecision.navigate;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://staging-consent-bb-iam.igrant.io/realms/3pp-application/protocol/openid-connect/auth?client_id=3pp&response_type=code&redirect_uri=https%3A%2F%2Fstaging-consent-bb-api.igrant.io%2Fv2%2Fservice%2Fdata-sharing%3FdataAgreementId%3D654cf0db9684ed907ce07c5f%26thirdPartyOrgName%3DData4Diabetes%26dataSharingUiRedirectUrl%3Dhttps%3A%2F%2Fwww.govstack.global%2F'));
  }
}
