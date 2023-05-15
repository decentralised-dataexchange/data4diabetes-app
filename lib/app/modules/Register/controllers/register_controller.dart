import 'dart:io';

import 'package:Data4Diabetes/app/data/model/register/RegisterRequest.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterResponse.dart';
import 'package:Data4Diabetes/app/data/repository/user_repository_impl.dart';
import 'package:Data4Diabetes/app/modules/Otp/views/otp_view.dart';
import 'package:Data4Diabetes/app/modules/privacyPolicy/controllers/privacyPolicy_controller.dart';
import 'package:Data4Diabetes/app/modules/termsOfService/views/termsOfService_view.dart';
import 'package:Data4Diabetes/app/network/exceptions/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../login/controllers/login_controller.dart';
import '/app/core/base/base_controller.dart';

class RegisterController extends BaseController {
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
  var selectedPage = 0.obs;
  var selectedIndex = 0.obs;
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
        loginController.isControl.value = false;
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
    } finally {
      hideLoading();
    }
  }

  void showDataAgreement() {
    if (Platform.isAndroid) {
      switch (selectedIndex.value) {
        case 0:
          {
            platform.invokeMethod('DataAgreementPolicy', {
              "ApiKey":
                  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2NDVhNDE0YmI5YjA1NTAwMDE1MGIyNDciLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcxNDc0MDg4Nn0.u6pBpv12ZfdHYMPoQHYR-oBR9ZOZVeHiChaQ8yiEMxE',
              "orgId": '645a4172b9b055000150b248',
              "dataAgreementId": '0900ccb0-73d5-4175-ae79-a3fc14a14e9e'
            });
          }
          break;

        case 1:
          {
            platform.invokeMethod('DataAgreementPolicy', {
              "ApiKey":
                  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2NDVhNDE0YmI5YjA1NTAwMDE1MGIyNDciLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcxNDc0MDg4Nn0.u6pBpv12ZfdHYMPoQHYR-oBR9ZOZVeHiChaQ8yiEMxE',
              "orgId": '645a4172b9b055000150b248',
              "dataAgreementId": '43bbd177-a6bf-4e97-a771-4f77fca4960e'
            });
          }
          break;
        case 2:
          {
            platform.invokeMethod('DataAgreementPolicy', {
              "ApiKey":
                  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2NDVhNDE0YmI5YjA1NTAwMDE1MGIyNDciLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcxNDc0MDg4Nn0.u6pBpv12ZfdHYMPoQHYR-oBR9ZOZVeHiChaQ8yiEMxE',
              "orgId": '645a4172b9b055000150b248',
              "dataAgreementId": '6759b7ba-e12e-4ff8-915b-598a759c77d0'
            });
          }
          break;
        default:
          break;
      }
    } else if (Platform.isIOS) {
      showToast('Coming soon');
    }
  }
 void  termsOfServices(){
    Get.to(TermsOfServiceView());
  }
}
