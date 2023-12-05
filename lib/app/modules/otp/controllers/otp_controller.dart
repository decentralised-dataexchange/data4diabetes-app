import 'package:Data4Diabetes/app/data/local/preference/preference_manager_impl.dart';
import 'package:Data4Diabetes/app/data/model/verifyOTP/VerifyOtpRequest.dart';
import 'package:Data4Diabetes/app/data/model/verifyOTP/VerifyOtpResponse.dart';
import 'package:Data4Diabetes/app/modules/Register/controllers/register_controller.dart';
import 'package:Data4Diabetes/app/modules/login/controllers/login_controller.dart';
import 'package:Data4Diabetes/app/network/exceptions/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/login/LoginRequest.dart';
import '../../../data/model/login/LoginResponse.dart';
import '../../../data/model/register/RegisterRequest.dart';
import '../../../data/model/register/RegisterResponse.dart';
import '../../../data/repository/user_repository_impl.dart';
import '../../main/views/main_view.dart';
import '/app/core/base/base_controller.dart';

class OtpController extends BaseController {
  final RegisterController registerController = Get.find();
  final LoginController loginController = Get.find();
  final TextEditingController verifyOtpController = TextEditingController();
  final UserRepositoryImpl _impl = UserRepositoryImpl();
  final PreferenceManagerImpl _preferenceManagerImpl = PreferenceManagerImpl();
  final int statusCode = 200;

  void verifyOTP() async {
    showLoading();
    VerifyOtpRequest request = VerifyOtpRequest(
      otp: verifyOtpController.text,
    );
    try {
      VerifyOtpResponse response = await _impl.verifyOTP(request);
      if (response.token != null) {
        _preferenceManagerImpl.setString('token', response.token);
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString('privacyDashboarduserId', response.lastname);
        if(loginController.sharePhoneNumber.value!=""){
          _prefs.setString('userMobileNumber', loginController.sharePhoneNumber.value);
        }else if(registerController.sharePhoneNumber.value!=""){
          _prefs.setString('userMobileNumber', registerController.sharePhoneNumber.value);
        }

        hideLoading();
        verifyOtpController.clear();

        Get.offAll(MainView());
      }
    } catch (e) {
      GetSnackToast(message: 'Invalid otp');
      hideLoading();
    } finally {
      hideLoading();
    }
  }

  void resendOTP() async {
    showLoading();
    loginController.isControl.value ? resendLoginOTP() : resendRegisterOTP();
  }

  void resendLoginOTP() async {
    debugPrint(
        "shared Login Resend number:" + loginController.sharePhoneNumber.value);
    LoginRequest request =
        LoginRequest(mobile_number: loginController.sharePhoneNumber.value);
    try {
      LoginResponse response = await _impl.login(request);
      if (response.msg == "OTP send") {
        hideLoading();
      }
    } catch (e) {
      GetSnackToast(message: (e as ApiException).message);

      hideLoading();
    } finally {
      hideLoading();
    }
  }

  void resendRegisterOTP() async {
    debugPrint("shared Register Resend number:" +
        registerController.sharePhoneNumber.value);
    debugPrint(
        "shared Register firstname:" + registerController.shareFirstName.value);
    debugPrint(
        "shared Register lastname:" + registerController.shareLastName.value);
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userId = _prefs.getString('privacyDashboarduserId');
    RegisterRequest request = RegisterRequest(
        firstname: registerController.shareFirstName.value,
        lastname: userId,
        mobile_number: registerController.sharePhoneNumber.value);
    try {
      RegisterResponse response = await _impl.register(request);

      if (response.msg == "OTP sent") {
        hideLoading();
      }
    } catch (e) {
      GetSnackToast(message: (e as ApiException).message);

      hideLoading();
    } finally {
      hideLoading();
    }
  }
}
