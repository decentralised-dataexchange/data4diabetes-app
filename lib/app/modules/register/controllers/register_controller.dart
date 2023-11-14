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
      var response = await platform.invokeMethod('DataSharing', {
        "apiKey": PrivacyDashboard().apiKey,
        "userId": PrivacyDashboard().userId,
        "dataAgreementID": PrivacyDashboard().backupAndRestoreDataAgreementId,
        "baseUrl": PrivacyDashboard().baseUrl
      });
      Map<String, dynamic> responseMap = json.decode(response);
      if (responseMap['optIn'] == true) {
        // Handle success
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
      } else {
        GetSnackToast(message: 'Something went wrong');
      }
    } catch (e) {
      GetSnackToast(message: e.toString());
    }
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
              sharingtoken: token,
              sharingDataAgreementID:
                  PrivacyDashboard().donateYourDataDataAgreementId);
        }
        break;
      case 2:
        {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          var token = _prefs.getString('dataSharingAccessToken');
          getDataAgreement(
              sharingtoken: token,
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
  onSkipTap()async{

      try {
        getDataAgreement(sharingtoken:accessToken,sharingDataAgreementID:PrivacyDashboard().backupAndRestoreDataAgreementId,isFlag:true);
        // Handle success
        int index = selectedPage.value + 1;
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );

      } catch (e) {
        GetSnackToast(message: e.toString());
      }
    }


  Future<void> onNextButtonTap() async {
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
      Get.to(DataAgreementView());
    }
  }

  // invokeDataAgreement() {
  //   controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setBackgroundColor(const Color(0x00000000))
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) {
  //           return;
  //         },
  //         onPageStarted: (String url) {
  //           /// show progress on loading
  //           return;
  //         },
  //         onPageFinished: (String url) {
  //           /// stop progress after loading
  //           return;
  //         },
  //         onWebResourceError: (WebResourceError error) {
  //           return;
  //         },
  //         onNavigationRequest: (NavigationRequest request) async {
  //           if (request.url.startsWith(redirectUrl)) {
  //             final uri = Uri.parse(request.url);
  //             if (uri.queryParameters.containsKey('error')) {
  //               // Handle error response
  //               String? error = uri.queryParameters['error'];
  //               String? errorDescription =
  //                   uri.queryParameters['errorDescription'];
  //               GetSnackToast(
  //                   message: errorDescription ?? "something went wrong");
  //               Get.off(LoginView());
  //             } else if (uri.queryParameters.containsKey('credentials')) {
  //               // Decode the base64-encoded credentials
  //               String? credentialsBase64 = uri.queryParameters['credentials'];
  //               // Ensure that the base64 string has the correct length and padding
  //               String paddedCredentialsBase64 = credentialsBase64! +
  //                   '=' * (4 - credentialsBase64.length % 4);
  //               // Decode the padded base64 string
  //               List<int> bytes = base64.decode(paddedCredentialsBase64);
  //               String decodedCredentialsJson = utf8.decode(bytes);
  //               Map<String, dynamic> decodedCredentials =
  //                   json.decode(decodedCredentialsJson);
  //               // Accessing user information
  //               Map<String, dynamic> userInfo = decodedCredentials['userInfo'];
  //               String subject = userInfo['subject'];
  //               String email = userInfo['email'];
  //               bool emailVerified = userInfo['emailVerified'];
  //               // Accessing token information
  //               Map<String, dynamic> token = decodedCredentials['token'];
  //               accessToken = token['accessToken'];
  //               int expiresIn = token['expiresIn'];
  //               String refreshToken = token['refreshToken'];
  //               SharedPreferences _prefs =
  //                   await SharedPreferences.getInstance();
  //               await _prefs.setString('dataSharingAccessToken', accessToken!);
  //               Get.back();
  //
  //               int index = selectedPage.value + 1;
  //               pageController.animateToPage(index,
  //                   duration: const Duration(milliseconds: 500),
  //                   curve: Curves.ease);
  //
  //             }
  //
  //             return NavigationDecision.navigate;
  //           }
  //
  //           return NavigationDecision.navigate;
  //         },
  //       ),
  //     )
  //     ..loadRequest(Uri.parse(
  //         'https://staging-consent-bb-iam.igrant.io/realms/3pp-application/protocol/openid-connect/auth?client_id=3pp&response_type=code&redirect_uri=https%3A%2F%2Fstaging-consent-bb-api.igrant.io%2Fv2%2Fservice%2Fdata-sharing%3FdataAgreementId%3D$dataAgreementId%26thirdPartyOrgName%3DData4Diabetes%26dataSharingUiRedirectUrl%3Dhttps%3A%2F%2Fwww.govstack.global%2F'));
  // }

  // void _dataAgreementPopUPWidget() async {
  //   // Display the WebView in a pop-up dialog
  //   final context = Get.context;
  //   if (context != null){
  //     await showDialog(
  //       context: Get.context!,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           content: SizedBox(
  //             width: double.infinity,
  //             height: MediaQuery.of(context).size.height,
  //             child: FutureBuilder<String>(
  //               future: invokeDataAgreement(),
  //               builder: (BuildContext context, snapshot) {
  //                 if (snapshot.connectionState == ConnectionState.waiting) {
  //                   // Display a loading spinner while waiting for the future to complete
  //                   return Center(child: CircularProgressIndicator());
  //                 } else if (snapshot.hasError) {
  //                   // Display an error message if the future throws an error
  //                   return Text('Error: ${snapshot.error}');
  //                 } else {
  //                   // Display the fetched data using WebView
  //                   return FutureBuilder<String>(
  //                     future: invokeDataAgreement(),
  //                     builder: (BuildContext context, snapshot) {
  //                       if (snapshot.connectionState == ConnectionState.waiting) {
  //                         // Display a loading spinner while waiting for the future to complete
  //                         return Center(child: CircularProgressIndicator());
  //                       } else if (snapshot.hasError) {
  //                         // Display an error message if the future throws an error
  //                         return Text('Error: ${snapshot.error}');
  //                       } else {
  //                         // Display the fetched data
  //                         return WebViewWidget(controller:controller!);
  //                       }
  //                     },
  //                   );
  //                 }
  //               },
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }
  //
  // }
  onAgreeButtonTap() async {
     try {
      var response = await platform.invokeMethod('DataSharing', {
        "apiKey": PrivacyDashboard().apiKey,
        "userId": PrivacyDashboard().userId,
        "dataAgreementID": PrivacyDashboard().donateYourDataDataAgreementId,
        "baseUrl": PrivacyDashboard().baseUrl
      });
      Map<String, dynamic> responseMap = json.decode(response);
      if (responseMap['optIn'] == true) {
        getDataAgreement(
            sharingtoken: accessToken,
            sharingDataAgreementID: PrivacyDashboard().backupAndRestoreDataAgreementId,
            isFlag: true);
        // Handle success
        int index = selectedPage.value + 1;
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        GetSnackToast(message: 'Something went wrong');
      }
    } catch (e) {
      GetSnackToast(message: e.toString());
    }
  }

  getDataAgreement(
      {required String? sharingtoken,
      required String? sharingDataAgreementID,
      bool? isFlag}) async {
    try {
      var response = await platform.invokeMethod('GetDataAgreement', {
        "apiKey": PrivacyDashboard().apiKey,
        "userId": PrivacyDashboard().userId,
        "dataAgreementID": sharingDataAgreementID,
        "baseUrl": PrivacyDashboard().baseUrl
      });

      Map<String, dynamic> responseMap = json.decode(response);
      print('response map: $responseMap');

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
      GetSnackToast(message: e.toString());
    }
  }

  getDataAgreementWithApiKey({required String? sharingDataAgreementID}) async {
    try {
      var response = await platform.invokeMethod('GetDataAgreementWithApiKey', {
        "apiKey": PrivacyDashboard().apiKey,
        "userId": PrivacyDashboard().userId,
        "dataAgreementID": sharingDataAgreementID,
        "baseUrl": PrivacyDashboard().baseUrl
      });

      Map<String, dynamic> responseMap = json.decode(response);
      print('response map: $responseMap');

      // call ShowDataAgreementPolicy

      await platform.invokeMethod('ShowDataAgreementPolicy', {
        "dataAgreementResponse": response,
      });

      // // Check if "dataAttributes" is not empty
      // if (responseMap.containsKey("dataAttributes") &&
      //     responseMap["dataAttributes"] is List &&
      //     responseMap["dataAttributes"].isNotEmpty) {
      //
      //   // Clear the existing dataAttributes list
      //   dataAttributes.clear();
      //
      //   // Iterate through the response dataAttributes and add them to the list
      //   for (var attribute in responseMap["dataAttributes"]) {
      //     String nameValue = attribute["name"];
      //     dataAttributes.add(nameValue);
      //
      //   }
      //
      //   // Print the first item in the dataAttributes list
      //   if (dataAttributes.isNotEmpty) {
      //     print('dataAttributes values ${dataAttributes[0]}');
      //   }
      // }
    } catch (e) {
      GetSnackToast(message: e.toString());
    }
  }
}
