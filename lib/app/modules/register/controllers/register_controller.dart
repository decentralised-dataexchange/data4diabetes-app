import 'dart:convert';

import 'package:Data4Diabetes/app/Constants/privacy_dashboard.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterRequest.dart';
import 'package:Data4Diabetes/app/data/model/register/RegisterResponse.dart';
import 'package:Data4Diabetes/app/data/model/validateMobileNumber/ValidateMobileNumberRequest.dart';
import 'package:Data4Diabetes/app/data/model/validateMobileNumber/ValidateMobileNumberResponse.dart';
import 'package:Data4Diabetes/app/data/repository/user_repository_impl.dart';
import 'package:Data4Diabetes/app/modules/Otp/views/otp_view.dart';
import 'package:Data4Diabetes/app/modules/dataSharing/views/dataAgreement_view.dart';
import 'package:Data4Diabetes/app/modules/login/views/login_view.dart';
import 'package:Data4Diabetes/app/modules/termsOfService/views/termsOfService_view.dart';
import 'package:Data4Diabetes/app/network/exceptions/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
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
  var validateVisibility = false.obs;

  // var circularVisibility=false.obs;
  WebViewController? controller;
  int maxProgressValue = 100;
  var dataAgreementId = "654cf0db9684ed907ce07c5";

  var thirdPartyOrgName = "Data4Diabetes";
  String? accessToken;
  var redirectUrl = "https://www.govstack.global/";
  List dataAttributes = [].obs;

  @override
  void onInit() {
    pageController = PageController(initialPage: selectedPage.value);
    super.onInit();
  }

  void registerUser() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var userId = _prefs.getString('privacyDashboarduserId');
      var response = await platform.invokeMethod('DataSharing', {
        "apiKey": PrivacyDashboard().apiKey,
        "userId": userId,
        "dataAgreementID": PrivacyDashboard().backupAndRestoreDataAgreementId,
        "baseUrl": PrivacyDashboard().baseUrl
      });
      Map<String, dynamic> responseMap = json.decode(response);
      if (responseMap['optIn'] == true) {
        // Handle success
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
              message: appLocalization.otpLimitExceeded);
        }else{
          // Within the rate limit, proceed with OTP request
          // Increment message count and update last message time
          messageCount++;
          lastMessageTime = currentTime;

          await prefs.setInt('message_count_$sessionToken', messageCount);
          await prefs.setInt('last_message_time_$sessionToken', lastMessageTime);
          RegisterRequest request = RegisterRequest(
              firstname: firstNameController.text,
              lastname: userId,
              mobile_number: isdCode! + mobileNumberController.text);
          try {
            RegisterResponse response = await _impl.register(request);

            if (response.msg == "OTP sent") {
              hideLoading();
              loginController.isControl.value = false;
              Get.off(OtpView());
              firstNameController.clear();
              mobileNumberController.clear();
            }
          } catch (e) {
            firstNameController.clear();
            mobileNumberController.clear();
            GetSnackToast(message: (e as ApiException).message);

            hideLoading();
          } finally {
            hideLoading();
          }
        }
      } else {
        GetSnackToast(message: 'Something went wrong');
      }
    } catch (e) {
      GetSnackToast(message: e.toString());
    }
  }

  String generateSessionToken(String phoneNumber) {
    return Uuid()
        .v5(Uuid.NAMESPACE_URL, phoneNumber)
        .toString(); // Generate session token using UUID v5
  }
  Future<void> showDataAgreement() async {
    // if (Platform.isAndroid) {
    switch (selectedIndex.value) {
      case 0:
        {
          getDataAgreementWithApiKey(
              sharingDataAgreementID:
                  PrivacyDashboard().registrationDataAgreementId);
        }
        break;

      case 1:
        {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          var token = _prefs.getString('dataSharingAccessToken');
          getDataAgreement(
              sharingDataAgreementID:
                  PrivacyDashboard().donateYourDataDataAgreementId);
        }
        break;
      case 2:
        {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          var token = _prefs.getString('dataSharingAccessToken');
          getDataAgreement(

              sharingDataAgreementID:
                  PrivacyDashboard().backupAndRestoreDataAgreementId);
        }
        break;
      default:
        break;
    }
    // } else if (Platform.isIOS) {
    //   showToast('Coming soon');
    // }
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

  onSkipTap() async {
    try {
      showLoading();
      getDataAgreement(

          sharingDataAgreementID:
              PrivacyDashboard().backupAndRestoreDataAgreementId,
          isFlag: true);
      hideLoading();
      // Handle success
      int index = selectedPage.value + 1;
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } catch (e) {
      hideLoading();
      GetSnackToast(message: e.toString());
    }
  }

  Future<void> onNextButtonTap() async {
    String pattern = "";
    isdCode == "+91"
        ? pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)'
        : pattern = r'(^(?:[+0]9)?[0-9]{9,11}$)';
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
      var response = await platform.invokeMethod('CreateIndividual', {
        "apiKey": PrivacyDashboard().apiKey,
        "baseUrl": PrivacyDashboard().baseUrl
      });

      Map<String, dynamic> responseMap = json.decode(response);
      Map<String, dynamic> individual = responseMap['individual'];
      String? id = individual['id'];
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString('privacyDashboarduserId', id ?? "");

      Get.to(DataAgreementView());
    }
  }

  onAgreeButtonTap() async {
    try {
      showLoading();
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var userId = _prefs.getString('privacyDashboarduserId');
      var response = await platform.invokeMethod('DataSharing', {
        "apiKey": PrivacyDashboard().apiKey,
        "userId": userId ,
        "dataAgreementID": PrivacyDashboard().donateYourDataDataAgreementId,
        "baseUrl": PrivacyDashboard().baseUrl
      });
      Map<String, dynamic> responseMap = json.decode(response);
      if (responseMap['optIn'] == true) {
        getDataAgreement(

            sharingDataAgreementID:
                PrivacyDashboard().backupAndRestoreDataAgreementId,
            isFlag: true);
        // Handle success
        int index = selectedPage.value + 1;
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        GetSnackToast(message: 'Something went wrong.Please try again');
      }
      hideLoading();
    } catch (e) {
      hideLoading();
      GetSnackToast(message: e.toString());
    }
  }

  getDataAgreement(
      {
      required String? sharingDataAgreementID,
      bool? isFlag}) async {
    try {
      showLoading();
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var userId = _prefs.getString('privacyDashboarduserId');
      var response = await platform.invokeMethod('GetDataAgreement', {
        "apiKey": PrivacyDashboard().apiKey,
        "userId": userId ,
        "dataAgreementID": sharingDataAgreementID,
        "baseUrl": PrivacyDashboard().baseUrl
      });

      Map<String, dynamic> responseMap = json.decode(response);
      print('response map: $responseMap');
      hideLoading();
      // call ShowDataAgreementPolicy
      if (isFlag != true) {
        await platform.invokeMethod('ShowDataAgreementPolicy', {
          "dataAgreementResponse": response,
        });
      }

      // Check if "dataAttributes" is not empty
      if (responseMap.containsKey("dataAttributes") &&
          responseMap["dataAttributes"] is List &&
          responseMap["dataAttributes"].isNotEmpty) {
        // Clear the existing dataAttributes list
        dataAttributes.clear();

        // Iterate through the response dataAttributes and add them to the list
        for (var attribute in responseMap["dataAttributes"]) {
          String nameValue = attribute["name"];
          dataAttributes.add(nameValue);
        }

        // Print the first item in the dataAttributes list
        if (dataAttributes.isNotEmpty) {
          print('dataAttributes values ${dataAttributes[0]}');
        }
      }
    } catch (e) {
      hideLoading();
      GetSnackToast(message: e.toString());
    }
  }

  getDataAgreementWithApiKey({required String? sharingDataAgreementID}) async {
    try {
      showLoading();
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var userId = _prefs.getString('privacyDashboarduserId');
      var response = await platform.invokeMethod('GetDataAgreementWithApiKey', {
        "apiKey": PrivacyDashboard().apiKey,
        "userId": userId ,
        "dataAgreementID": sharingDataAgreementID,
        "baseUrl": PrivacyDashboard().baseUrl
      });

      Map<String, dynamic> responseMap = json.decode(response);
      print('response map: $responseMap');
      hideLoading();
      // call ShowDataAgreementPolicy

      await platform.invokeMethod('ShowDataAgreementPolicy', {
        "dataAgreementResponse": response,
      });
      //  hideLoading();
    } catch (e) {
      hideLoading();
      GetSnackToast(message: e.toString());
    }
  }
}
