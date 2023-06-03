import 'dart:ui';

import 'package:Data4Diabetes/app/Constants/dexcom_values.dart';
import 'package:Data4Diabetes/app/data/model/dexcom/AccessTokenResponse.dart';
import 'package:Data4Diabetes/app/network/http_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../flavors/build_config.dart';
import '../../../data/model/dexcom/EstimatedGlucoseValue.dart';
import '/app/core/base/base_controller.dart';

class DexcomController extends BaseController {
  final DexcomValues _dexcomValues = DexcomValues();
  static final String? dexComBaseUrl =
      BuildConfig.instance.config.dexComBaseUrl;
  late final WebViewController controller;
  var visibilityValue = false.obs;
  var clientID;
  var clientSecret;
  var redirectUri;
  var getGlucoseValues;
  int maxProgressValue=100;
  EstimatedGlucoseValue? evgsDataList;
  @override
  void onInit() {
    clientID = _dexcomValues.clientID;
    clientSecret = _dexcomValues.clientSecret;
    redirectUri = _dexcomValues.redirectUri;
    dexcomLogin();
    super.onInit();
  }

  dexcomLogin() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if(progress!=maxProgressValue)
              {
                showLoading();
              }
            else{
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
            if (request.url.startsWith(redirectUri)) {
              final uri = Uri.parse(request.url);
              String? code = uri.queryParameters['code'];
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              await _prefs.setString('authorization_code', code!);
              obtainAccessToken(code);

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          '$dexComBaseUrl/v2/oauth2/login?client_id=$clientID&redirect_uri=$redirectUri&response_type=code&scope=offline_access'));
  }

  void obtainAccessToken(code) async {
    HttpProvider _httpProvider = HttpProvider();
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['client_id'] = clientID;
    data['client_secret'] = clientSecret;
    data['code'] = code;
    data['grant_type'] = 'authorization_code';
    data['redirect_uri'] = redirectUri;
    var response = await _httpProvider.postData('/v2/oauth2/token', data);
    var resultedData = AccessTokenResponse.fromJson(response);
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('access_token', resultedData.accessToken!);
    await _prefs.setString('refresh_token', resultedData.refreshToken!);
    evgsDataList  =getEgvs();
  }

  getEgvs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('access_token');
    HttpProvider _httpProvider = HttpProvider();
    DateTime now = DateTime.now();
    DateTime thirtyDaysAgo = now.subtract(const Duration(days: 30));
    String startDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(thirtyDaysAgo);
    String endDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

    var response = await _httpProvider.getEGVs(
      token!,
      url: '/v3/users/self/egvs',
      startDate: startDate.toString(),
      endDate: endDate.toString(),
    );
    var resultedData = EstimatedGlucoseValue.fromJson(response);
    print(resultedData.userId);


    return resultedData;
  }
}
