import 'package:Data4Diabetes/app/data/model/register/RegisterRequest.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterResponse.dart';
import 'package:Data4Diabetes/app/data/repository/user_repository_impl.dart';
import 'package:Data4Diabetes/app/modules/Otp/views/otp_view.dart';
import 'package:Data4Diabetes/app/network/exceptions/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../login/controllers/login_controller.dart';
import '/app/core/base/base_controller.dart';
class RegisterController extends BaseController {
  var selectedPage=0.obs;
  var selectedIndex=0.obs;
  final pageCount = 3;
  late final PageController pageController;
  final LoginController loginController = Get.find();
  final TextEditingController firstNameController = TextEditingController();
  //final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController cgmDataController = TextEditingController();
  final TextEditingController insightsController = TextEditingController();
  final TextEditingController scannedImagesController = TextEditingController();
  final UserRepositoryImpl _impl = UserRepositoryImpl();
  var sharePhoneNumber = "".obs;
  var shareFirstName = "".obs;
  var shareLastName = "".obs;
  PhoneNumber number = PhoneNumber(isoCode: 'SE');
  String? isdCode;
  @override
  void onInit() {
    pageController = PageController(initialPage: selectedPage.value);
    super.onInit();
  }
  void registerUser() async {
    showLoading();
    shareFirstName.value = firstNameController.text;
    //shareLastName.value = lastNameController.text;
    shareLastName.value = "";
    sharePhoneNumber.value = isdCode! + mobileNumberController.text;
    RegisterRequest request = RegisterRequest(
        firstname: firstNameController.text,
        lastname: "no last name",
        mobile_number: isdCode! + mobileNumberController.text);
    try {
      RegisterResponse response = await _impl.register(request);

      if (response.msg == "OTP sent") {
        hideLoading();
        loginController.isControl.value=false;
        Get.off(OtpView());
        firstNameController.clear();
        //lastNameController.clear();
        mobileNumberController.clear();
      }
    } catch (e) {
      firstNameController.clear();
      //lastNameController.clear();
      mobileNumberController.clear();
      GetSnackToast(message: (e as ApiException).message);

      hideLoading();
    }
    finally{
      hideLoading();
    }
  }
}
