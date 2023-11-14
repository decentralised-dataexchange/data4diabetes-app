import 'package:Data4Diabetes/app/core/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyDashboardCredentialController extends BaseController {
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');

  final TextEditingController apiKeyController = TextEditingController();
  final TextEditingController baseUrlController = TextEditingController();
  final TextEditingController orgIdController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    privacyDashboardCredentials();
  }

  privacyDashboardCredentials() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var apiKey = _prefs.getString('privacyDashboardApiKey');
    var orgId = _prefs.getString('privacyDashboardorgId');
    var baseUrl = _prefs.getString('privacyDashboardbaseUrl');
    var userId = _prefs.getString('privacyDashboarduserId');
    print('apikey now:$apiKey');
    apiKey != null
        ? apiKeyController.text = apiKey
        : apiKeyController.text =
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsic2VydmljZSJdLCJPcmdhbmlzYXRpb25JZCI6IjY0ZjA5Zjc3OGU1ZjM4MDAwMTRhODc5YSIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2NTBhZTFmYmJlMWViNDAwMDE3MTFkODciLCJleHAiOjE3MzAyMjMyODh9.DlU8DjykYr3eBmbgsKLR4dnaChiRqXdxofKOuk4LiRM";
    orgId != null
        ? orgIdController.text = orgId
        : orgIdController.text = "64f09f778e5f3800014a879a";
    baseUrl != null
        ? baseUrlController.text = baseUrl
        : baseUrlController.text = "https://demo-consent-bb-api.igrant.io/v2";
    userId != null
        ? userIdController.text = userId
        : userIdController.text = "653fe90efec9f34efed23619";
    print('apiKeyController.text${apiKeyController.text}');
  }

  submitButtonAction() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('privacyDashboardApiKey', apiKeyController.text);
    _prefs.setString('privacyDashboardorgId', orgIdController.text);
    _prefs.setString('privacyDashboardbaseUrl', baseUrlController.text);
    _prefs.setString('privacyDashboarduserId', userIdController.text);
    Get.rawSnackbar(
        message: 'updated credentials successfully',
        backgroundColor: Colors.green);
    privacyDashboardCredentials();
  }
  resetButtonAction() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('privacyDashboardApiKey', "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTY29wZXMiOlsic2VydmljZSJdLCJPcmdhbmlzYXRpb25JZCI6IjY0ZjA5Zjc3OGU1ZjM4MDAwMTRhODc5YSIsIk9yZ2FuaXNhdGlvbkFkbWluSWQiOiI2NTBhZTFmYmJlMWViNDAwMDE3MTFkODciLCJleHAiOjE3MzAyMjMyODh9.DlU8DjykYr3eBmbgsKLR4dnaChiRqXdxofKOuk4LiRM");
    _prefs.setString('privacyDashboardorgId', "64f09f778e5f3800014a879a");
    _prefs.setString('privacyDashboardbaseUrl', "https://demo-consent-bb-api.igrant.io/v2");
    _prefs.setString('privacyDashboarduserId', "653fe90efec9f34efed23619");
    privacyDashboardCredentials();
    Get.rawSnackbar(
        message: 'Reset to default credentials',
        backgroundColor: Colors.green);
    privacyDashboardCredentials();
  }
}
