import 'package:Data4Diabetes/app/data/model/login/LoginRequest.dart';
import 'package:Data4Diabetes/app/modules/Otp/views/otp_view.dart';
import 'package:Data4Diabetes/app/network/exceptions/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../data/model/login/LoginResponse.dart';
import '../../../data/repository/user_repository_impl.dart';
import '/app/core/base/base_controller.dart';
String? sessionToken;
const int timeWindow = 1 * 60 * 1000; // 1 minute time window
const int maxMessagesPerWindow = 3;
class LoginController extends BaseController {
  PhoneNumber number = PhoneNumber(isoCode: 'SE');
  final UserRepositoryImpl _impl = UserRepositoryImpl();
  final TextEditingController phoneNumberController = TextEditingController();
  var sharePhoneNumber = "".obs;
  var isControl = true.obs;
  String? isdCode;
  int currentTime = 0;
  int lastMessageTime = 0;
  int messageCount = 0;
  loginUser() async {
    String pattern = "";
    isdCode == "+91"
        ? pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)'
        : pattern = r'(^(?:[+0]9)?[0-9]{9,11}$)';
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      sessionToken = generateSessionToken(phoneNumberController.text); // Generate session token
      lastMessageTime = prefs.getInt('last_message_time_$sessionToken') ?? 0;
      messageCount = prefs.getInt('message_count_$sessionToken') ?? 0;
      // Maximum messages allowed per time window
      if (currentTime - lastMessageTime >= timeWindow) {
        // Reset the rate limit if the time window has elapsed
        messageCount = 0;
        lastMessageTime = currentTime;
      }
      if (messageCount >= maxMessagesPerWindow) {
        // Rate limit exceeded, display an error message or take appropriate action
        hideLoading();
        GetSnackToast(
            message:  appLocalization.otpLimitExceeded,);
      }
      else{
        // Within the rate limit, proceed with OTP request
        // Increment message count and update last message time
        messageCount++;
        lastMessageTime = currentTime;
        await prefs.setInt('message_count_$sessionToken', messageCount);
        await prefs.setInt('last_message_time_$sessionToken', lastMessageTime);
        // Execute the code to request OTP
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
          GetSnackToast(message: (e as ApiException).message);
          hideLoading();
        }
        finally{
          hideLoading();
        }
      }
    }
  }
  String generateSessionToken(String phoneNumber) {
    return Uuid()
        .v5(Uuid.NAMESPACE_URL, phoneNumber)
        .toString(); // Generate session token using UUID v5
  }
}
