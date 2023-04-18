import 'package:Data4Diabetes/app/data/local/preference/preference_manager.dart';
import 'package:Data4Diabetes/app/data/local/preference/preference_manager_impl.dart';
import 'package:Data4Diabetes/app/data/model/verifyOTP/VerifyOtpRequest.dart';
import 'package:Data4Diabetes/app/data/model/verifyOTP/VerifyOtpResponse.dart';
import 'package:Data4Diabetes/app/modules/Register/controllers/register_controller.dart';
import 'package:Data4Diabetes/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repository/user_repository_impl.dart';
import '../../main/views/main_view.dart';
import '/app/core/base/base_controller.dart';

class OtpController extends BaseController {
  final RegisterController registerController = Get.find();
  final LoginController loginController = Get.find();
  final TextEditingController verifyOtpController = TextEditingController();
  final UserRepositoryImpl _impl = UserRepositoryImpl();
  final PreferenceManagerImpl _preferenceManagerImpl = PreferenceManagerImpl();

  void verifyOTP() async {
    showLoading();

    VerifyOtpRequest request = VerifyOtpRequest(
      otp: verifyOtpController.text,
    );
    try {
      VerifyOtpResponse response = await _impl.verifyOTP(request);
      if (response.token != null) {

        _preferenceManagerImpl.setString('token', response.token!);
        hideLoading();
        verifyOtpController.clear();
        Get.offAll(MainView());
      } else if (response.msg == "Invalid OTP") {
        hideLoading();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
