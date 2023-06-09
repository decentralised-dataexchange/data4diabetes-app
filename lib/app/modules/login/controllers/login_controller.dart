import 'package:Data4Diabetes/app/data/model/login/LoginRequest.dart';
import 'package:Data4Diabetes/app/modules/Otp/views/otp_view.dart';
import 'package:Data4Diabetes/app/network/exceptions/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../data/model/login/LoginResponse.dart';
import '../../../data/repository/user_repository_impl.dart';
import '/app/core/base/base_controller.dart';

class LoginController extends BaseController {
  PhoneNumber number = PhoneNumber(isoCode: 'SE');
  final UserRepositoryImpl _impl = UserRepositoryImpl();
  final TextEditingController phoneNumberController = TextEditingController();
  var sharePhoneNumber = "".obs;
  var isControl = true.obs;
  String? isdCode;

  loginUser() async {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    showLoading();
    if(phoneNumberController.text==""){
      hideLoading();
      GetSnackToast(message: appLocalization.loginPhoneNumberValidationText);
    }
    else if(!regExp.hasMatch(phoneNumberController.text)){
      hideLoading();
      GetSnackToast(message:appLocalization.loginValidPhoneNumberValidationText);
    }
    else{
      sharePhoneNumber.value = isdCode! + phoneNumberController.text;
      debugPrint("shared number:" + sharePhoneNumber.value);
      LoginRequest request =
      LoginRequest(mobile_number: isdCode! + phoneNumberController.text);
      try {
        LoginResponse response = await _impl.login(request);
        if (response.msg == "OTP sent") {
          hideLoading();
          phoneNumberController.clear();
          isControl.value = true;
          Get.to(OtpView());
          phoneNumberController.clear();
        }
      } catch (e) {
        // showToast((e as ApiException).message);
        GetSnackToast(message: (e as ApiException).message);

        hideLoading();
      }
      finally{
        hideLoading();
      }
    }

  }
}
