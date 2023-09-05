import 'dart:async';
import 'dart:ui';
import 'package:Data4Diabetes/app/Constants/Palette.dart';
import 'package:Data4Diabetes/app/Constants/dexcom_values.dart';
import 'package:Data4Diabetes/app/data/model/dexcom/AccessTokenRequest.dart';
import 'package:Data4Diabetes/app/data/model/dexcom/AccessTokenResponse.dart';
import 'package:Data4Diabetes/app/data/model/dexcom/EstimatedGlucoseValueRequest.dart';
import 'package:Data4Diabetes/app/network/http_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../flavors/build_config.dart';
import '../../../data/model/dexcom/EstimatedGlucoseValue.dart';
import '../../../data/repository/user_repository_impl.dart';
import '/app/core/base/base_controller.dart';

class DexcomController extends BaseController {
  final DexcomValues _dexcomValues = DexcomValues();
  var dexComBaseUrl = ''.obs;

    WebViewController? controller;
  var visibilityValue = false.obs;
  var clientID;
  var clientSecret;
  var redirectUri;
  var getGlucoseValues;
  int maxProgressValue = 100;
  var secondsRemaining = 0.obs;
  Timer? timer;
  final UserRepositoryImpl _impl = UserRepositoryImpl();
  @override
  void onInit() {
    
    dexComBaseUrl.value = BuildConfig.instance.config.dexComBaseUrl!;
    clientID = _dexcomValues.clientID;
    clientSecret = _dexcomValues.clientSecret;
    redirectUri = _dexcomValues.redirectUri;
    //dexcomLogin();
    super.onInit();
  }

  dexcomLogin() {
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
            if (request.url.startsWith(redirectUri)) {
              final uri = Uri.parse(request.url);
              String? code = uri.queryParameters['code'];
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              await _prefs.setString('authorization_code', code!);
              obtainAccessToken(code);
              Get.back();

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          '${dexComBaseUrl.value}/v2/oauth2/login?client_id=$clientID&redirect_uri=$redirectUri&response_type=code&scope=offline_access'));
  }

  void obtainAccessToken(code) async {
    // AccessTokenRequest request = AccessTokenRequest(
    //     clientID: clientID,
    //     clientSecret: clientSecret,
    //     code: code,
    //     grantType: 'authorization_code',
    //     redirectUri: redirectUri);
    // AccessTokenResponse response=await _impl.obtainAccessToken(request);
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
    secondsRemaining.value = resultedData.expiresIn!;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (secondsRemaining.value < 1) {
        timer?.cancel();
        refreshToken();
        // Call the API when the countdown reaches 0
      } else {
        secondsRemaining.value = secondsRemaining.value - 1;
      }
    });
  }

  Future<void> refreshToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var refreshToken = _prefs.getString('refresh_token');
    HttpProvider _httpProvider = HttpProvider();
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['client_id'] = clientID;
    data['client_secret'] = clientSecret;
    data['refresh_token'] = refreshToken;
    data['grant_type'] = 'refresh_token';
    data['redirect_uri'] = redirectUri;
    // AccessTokenRequest request = AccessTokenRequest(
    //     clientID: clientID,
    //     clientSecret: clientSecret,
    //     code: code,
    //     grantType: 'refresh_token',
    //     redirectUri: redirectUri);
    // AccessTokenResponse response=await _impl.obtainAccessToken(request);
    var response = await _httpProvider.postData('/v2/oauth2/token', data);
    var resultedData = AccessTokenResponse.fromJson(response);
    await _prefs.setString('access_token', resultedData.accessToken!);
    await _prefs.setString('refresh_token', resultedData.refreshToken!);
    secondsRemaining.value = resultedData.expiresIn!;
    startTimer();
  }

  Future<EstimatedGlucoseValue> getEgvs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    HttpProvider _httpProvider = HttpProvider();
    DateTime now = DateTime.now();
    DateTime thirtyDaysAgo = now.subtract(const Duration(days: 30));
    String startDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(thirtyDaysAgo);
    String endDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

    while (true) {
      var token = _prefs.getString('access_token'); // Retrieve the current access token
      var response = await _httpProvider.getEGVs(
        token!,
        url: '/v3/users/self/egvs',
        startDate: startDate.toString(),
        endDate: endDate.toString(),
      );
      if (response == '401') {
        await refreshToken(); // Refresh the token
        continue; // Continue the loop to retry the API call with the new token
      }

      EstimatedGlucoseValue resultedData = EstimatedGlucoseValue.fromJson(response);

      return resultedData;
    }
  }


}
