
import 'package:Data4Diabetes/app/data/model/register/RegisterRequest.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterResponse.dart';
import 'package:Data4Diabetes/app/data/model/validateMobileNumber/ValidateMobileNumberRequest.dart';
import 'package:Data4Diabetes/app/data/model/validateMobileNumber/ValidateMobileNumberResponse.dart';
import 'package:Data4Diabetes/app/data/repository/user_repository_impl.dart';
import 'package:Data4Diabetes/app/modules/Otp/views/otp_view.dart';
import 'package:Data4Diabetes/app/modules/termsOfService/views/termsOfService_view.dart';
import 'package:Data4Diabetes/app/network/exceptions/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
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
  var validateVisibility = false.obs;
  // var circularVisibility=false.obs;
  @override
  void onInit() {
    pageController = PageController(initialPage: selectedPage.value);
    super.onInit();
  }

  void registerUser() async {
    showLoading();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int currentTime = DateTime.now().millisecondsSinceEpoch;
    shareFirstName.value = firstNameController.text;
    //shareLastName.value = lastNameController.text;
    shareLastName.value = "";
    sharePhoneNumber.value = isdCode! + mobileNumberController.text;
    sessionToken = generateSessionToken(sharePhoneNumber.value);
    int lastMessageTime = prefs.getInt('last_message_time_$sessionToken') ?? 0;
    int messageCount = prefs.getInt('message_count_$sessionToken') ?? 0;
    if (currentTime - lastMessageTime >= timeWindow) {
      // Reset the rate limit if the time window has elapsed
      messageCount = 0;
      lastMessageTime = currentTime;
    }
    if (messageCount >= maxMessagesPerWindow) {
      // Rate limit exceeded, display an error message or take appropriate action
      hideLoading();
      GetSnackToast(
          message: "OTP request limit exceeded. Please try again after sometime.");
    } else {
      // Within the rate limit, proceed with OTP request
      // Increment message count and update last message time
      messageCount++;
      lastMessageTime = currentTime;

      await prefs.setInt('message_count_$sessionToken', messageCount);
      await prefs.setInt('last_message_time_$sessionToken', lastMessageTime);
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
  }

  String generateSessionToken(String phoneNumber) {
    return Uuid()
        .v5(Uuid.NAMESPACE_URL, phoneNumber)
        .toString(); // Generate session token using UUID v5
  }

  void showDataAgreement() {
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
  }

  void termsOfServices() {
    Get.to(TermsOfServiceView());
  }

  validateMobileNumber() async {
    ValidateMobileNumberRequest request = ValidateMobileNumberRequest(
        mobile_number: isdCode! + mobileNumberController.text);
    try {
      ValidateMobileNumberResponse response =
          await _impl.validateMobileNumber(request);
      if (response.isValidMobileNumber == true) {
        hideLoading();

        validateVisibility.value = true;
        // circularVisibility.value=false;
      } else if (response.isValidMobileNumber == false) {
        validateVisibility.value = false;
      }
    } catch (e) {
      // showToast((e as ApiException).message);
      GetSnackToast(message: (e as ApiException).message);

      hideLoading();
    } finally {
      hideLoading();
    }
  }

  void onNextButtonTap() {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (firstNameController.text == "") {
      GetSnackToast(message: appLocalization.registerFirstNameValidationText);
    } else if (mobileNumberController.text == "") {
      GetSnackToast(message: appLocalization.registerPhoneNumberValidationText);
    } else if (!regExp.hasMatch(mobileNumberController.text)) {
      GetSnackToast(
          message: appLocalization.registerValidPhoneNumberValidationText);
    } else if (validateVisibility.value == true) {
      GetSnackToast(
        message: appLocalization.registerExistingUser,
      );
    } else {
      int index = selectedPage.value + 1;
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }
}
