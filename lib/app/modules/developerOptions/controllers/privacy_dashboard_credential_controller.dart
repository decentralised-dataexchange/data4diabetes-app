import 'dart:convert';

import 'package:Data4Diabetes/app/Constants/privacy_dashboard.dart';
import 'package:Data4Diabetes/app/core/base/base_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../launcher/views/launcher_view.dart';

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
    print('apiKeyController.text${apiKeyController.text}');
  }

  submitButtonAction() async {
    var response = await platform.invokeMethod('CreateIndividual', {
      "apiKey": apiKeyController.text,
      "baseUrl": baseUrlController.text,
    });
    Map<String, dynamic> responseMap = json.decode(response);
    Map<String, dynamic> individual = responseMap['individual'];
    String? id = individual['id'];
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('privacyDashboardApiKey', apiKeyController.text);
    _prefs.setString('privacyDashboardorgId', orgIdController.text);
    _prefs.setString('privacyDashboardbaseUrl', baseUrlController.text);
    _prefs.setString('privacyDashboarduserId', id ?? "");
    Get.rawSnackbar(
        message: 'Updated : Close and Reopen the app to reflect the changes',
        backgroundColor: Colors.green);
    privacyDashboardCredentials();
  }

  resetButtonAction(BuildContext context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('privacyDashboardApiKey', PrivacyDashboard().apiKey);
    _prefs.setString('privacyDashboardorgId', "64f09f778e5f3800014a879a");
    _prefs.setString('privacyDashboardbaseUrl', PrivacyDashboard().baseUrl);
    _logout(context);

  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Alert'),
          content: const Text('To reset privacy dashboard credentials you need to logout and login. Please confirm to continue'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Logout'),
              onPressed: () async {
                privacyDashboardCredentials();
                Get.rawSnackbar(
                    message:
                    'Updated : Close and Reopen the app to reflect the changes',
                    backgroundColor: Colors.green);
                SharedPreferences _prefs = await SharedPreferences.getInstance();
                Set<String> keys = _prefs.getKeys();

                for (String key in keys) {
                  if (key != 'languageCode') {
                    await _prefs.remove(key);
                  }
                }
                Get.offAll(const LauncherView());
              },
            ),
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );

  }
}
