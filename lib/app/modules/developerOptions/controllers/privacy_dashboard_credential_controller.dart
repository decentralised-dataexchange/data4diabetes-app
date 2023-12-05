import 'package:Data4Diabetes/app/Constants/privacy_dashboard.dart';
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
        : apiKeyController.text = PrivacyDashboard().apiKey;
    orgId != null
        ? orgIdController.text = orgId
        : orgIdController.text = "64f09f778e5f3800014a879a";
    baseUrl != null
        ? baseUrlController.text = baseUrl
        : baseUrlController.text = PrivacyDashboard().baseUrl;
    userId != null
        ? userIdController.text = userId
        : userIdController.text = PrivacyDashboard().userId;
    print('apiKeyController.text${apiKeyController.text}');
  }

  submitButtonAction() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('privacyDashboardApiKey', apiKeyController.text);
    _prefs.setString('privacyDashboardorgId', orgIdController.text);
    _prefs.setString('privacyDashboardbaseUrl', baseUrlController.text);
    _prefs.setString('privacyDashboarduserId', userIdController.text);
    Get.rawSnackbar(
        message: 'Updated : Close and Reopen the app to reflect the changes',
        backgroundColor: Colors.green);
    privacyDashboardCredentials();
  }

  resetButtonAction() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('privacyDashboardApiKey', PrivacyDashboard().apiKey);
    _prefs.setString('privacyDashboardorgId', "64f09f778e5f3800014a879a");
    _prefs.setString('privacyDashboardbaseUrl', PrivacyDashboard().baseUrl);
    _prefs.setString('privacyDashboarduserId', PrivacyDashboard().userId);
    privacyDashboardCredentials();
    Get.rawSnackbar(
        message:
            'Success : Please logout and login, also reopen the app to reflect the changes',
        backgroundColor: Colors.green);
    privacyDashboardCredentials();
  }
}
