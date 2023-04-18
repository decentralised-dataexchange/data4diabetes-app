import 'package:Data4Diabetes/app/data/model/register/RegisterRequest.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterResponse.dart';
import 'package:Data4Diabetes/app/data/repository/user_repository_impl.dart';
import 'package:Data4Diabetes/app/modules/Otp/views/otp_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../login/controllers/login_controller.dart';
import '/app/core/base/base_controller.dart';

class RegisterController extends BaseController {
  final LoginController loginController = Get.find();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final UserRepositoryImpl _impl = UserRepositoryImpl();
  var sharePhoneNumber = "".obs;
  var shareFirstName = "".obs;
  var shareLastName = "".obs;
  PhoneNumber number = PhoneNumber(isoCode: 'SE');
  String? isdCode;
  void registerUser() async {
    showLoading();
    shareFirstName.value = firstNameController.text;
    shareLastName.value = lastNameController.text;
    sharePhoneNumber.value = isdCode! + mobileNumberController.text;
    RegisterRequest request = RegisterRequest(
        firstname: firstNameController.text,
        lastname: lastNameController.text,
        mobile_number: isdCode! + mobileNumberController.text);
    try {
      RegisterResponse response = await _impl.register(request);

      if (response.msg == "OTP sent") {
        hideLoading();
        loginController.isControl.value=false;
        Get.to(OtpView());
        firstNameController.clear();
        lastNameController.clear();
        mobileNumberController.clear();
      } else {
        Get.snackbar('', response.msg!);
      }
    } catch (e) {
      print('error message');
      print(e);
    }
  }
}
