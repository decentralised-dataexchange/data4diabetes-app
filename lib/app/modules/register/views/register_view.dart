import 'package:Data4Diabetes/app/modules/Register/controllers/register_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '/app/core/base/base_view.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class RegisterView extends BaseView<RegisterController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: InkWell(
          onTap: () {
            _registerController.firstNameController.clear();
            _registerController.mobileNumberController.clear();
            _registerController.selectedIndex.value = 0;
            _registerController.selectedPage.value = 0;
            _registerController.validateVisibility.value = false;
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios)),
    );
  }

  final double blankContainerHeight = 0.3;
  final double radiusConst = 18.0;
  final double verticalPadding = 15.0;
  final double buttonRadius = 50.0;
  final double circularProgressSize = 20.0;
  final double cardRadius = 15.0;
  final double sizedBox = 0.12;
  final double buttonSizedWidth = 0.20;
  final double buttonSizedHeight = 0.02;
  final _registerFormKey = GlobalKey<FormState>();
  final bool autoValidate = false;
  final RegisterController _registerController = Get.find();
  @override
  Widget body(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _registerController.firstNameController.clear();
        _registerController.mobileNumberController.clear();
        _registerController.selectedIndex.value = 0;
        _registerController.selectedPage.value = 0;
        _registerController.validateVisibility.value = false;

        return true;
      },
      child: GestureDetector(
        onTap:(){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _registerController.pageController,
                  onPageChanged: (page) {
                    _registerController.selectedPage.value = page;
                    _registerController.selectedIndex.value = page;
                  },
                  children: [
                    _firstPage(context),
                    _secondPage(context),
                    _thirdPage(context),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Obx(
                  () => PageViewDotIndicator(
                    currentItem: _registerController.selectedPage.value,
                    count: _registerController.pageCount,
                    unselectedColor: Colors.black26,
                    selectedColor: Colors.black,
                    duration: const Duration(milliseconds: 200),
                    boxShape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
          bottomNavigationBar: _bottomNavigationBar(context),
        ),
      ),
    );
  }

  Widget _firstNameWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 3.0),
      child: TextFormField(
        autofocus: false,
        controller: _registerController.firstNameController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),

          hintText: appLocalization.registerFirstName,
         fillColor: AppColors.pageBackground,

          filled: true,
          errorStyle: const TextStyle(height: 0, color: Colors.red),
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.silverAppBarOverlayColor,
            fontStyle: FontStyle.italic,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(cardRadius),
              topRight: Radius.circular(cardRadius),
            ),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(cardRadius),
              topRight: Radius.circular(cardRadius),
            ),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(cardRadius),
              topRight: Radius.circular(cardRadius),
            ),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(cardRadius),
              topRight: Radius.circular(cardRadius),
            ),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(cardRadius),
              topRight: Radius.circular(cardRadius),
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _mobileNumberWidget() {
    return _internationalPhoneNumberInputWidget();
  }

  Widget _internationalPhoneNumberInputWidget() {
    String pattern = "";
    _registerController.isdCode == "+91"
        ? pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)'
        : pattern = r'(^(?:[+0]9)?[0-9]{9,11}$)';

    RegExp regExp = RegExp(pattern);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 0.0),
      child: InternationalPhoneNumberInput(
        keyboardAction: TextInputAction.go,
        autoFocus: false,
        formatInput: false,
        onInputChanged: (val) {
          _registerController.isdCode = val.dialCode;
          if (!regExp.hasMatch(val.toString())) {
            _registerController.validateMobileNumber();
          }
        },
        onSubmit: () {
          return;
        },
        ignoreBlank: false,
        initialValue: _registerController.number,
        textFieldController: _registerController.mobileNumberController,
        inputDecoration: const InputDecoration(
          isDense: true,
          fillColor: AppColors.pageBackground,
          filled: true,
          hintText: 'Mobile Number',
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.silverAppBarOverlayColor,
            fontStyle: FontStyle.italic,
          ),
          errorStyle: TextStyle(height: 0, color: Colors.red),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        countries: const ['SE', 'IN'],
      ),
    );
  }

  Widget _bottomContentWidget() {
    return Column(
      children: [
        _trustHeading(),
        _trustContent(),
      ],
    );
  }

  Widget _firstPage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _registerFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appLocalization.register,
                style: bigTitleStyle,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  appLocalization.registerTopContent,
                  style: descriptionTextStyle,
                  textAlign: TextAlign.justify,
                ),
              ),
              Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                color: AppColors.pageBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cardRadius),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.veryLightGreyColor),
                    borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
                  ),
                  child: Column(
                    children: [
                      _firstNameWidget(context),
                      const Divider(),
                      _mobileNumberWidget(),
                    ],
                  ),
                ),
              ),
              _validateUserNumber(),
              _bottomContentWidget(),
            ],
          ),
        ),
      ),
    );
  }

  _trustHeading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        appLocalization.registerData4DiabetesTrust,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  _trustContent() {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: labelStyle,
        children: [
          TextSpan(
            text: appLocalization.registerTrustContent + ' ',
          ),
          WidgetSpan(
            child: InkWell(
              onTap: () {
                _registerController.showDataAgreement();
              },
              child: Text(
                appLocalization.registerDataAgreementDetails,
                style: hyperLinkStyle,
              ),
            ),
          ),
          TextSpan(
            text: ' ' + appLocalization.registerAnd + ' ',
          ),
          WidgetSpan(
            child: InkWell(
              onTap: () {
                _registerController.termsOfServices();
              },
              child: Text(
                appLocalization.registerTermsOfService,
                style: hyperLinkStyle,
              ),
            ),
          ),
        ],
      ),
    );

  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Obx(
      () => BottomAppBar(
        elevation: 0,
        child: _registerController.selectedIndex == 0
            ? _buttonNext(context)
            : _registerController.selectedIndex == 1
                ? _buttonAgree(context)
                : _registerController.selectedIndex == 2
                    ? _buttonAgreeFinish(context)
                    : const SizedBox(),
      ),
    );
  }

  Widget _buttonNext(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * buttonSizedWidth,
          0,
          MediaQuery.of(context).size.width * buttonSizedWidth,
          MediaQuery.of(context).size.height * buttonSizedHeight),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          minimumSize: const Size(double.infinity, 52),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          _registerController.onNextButtonTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Text(
                appLocalization.registerNext,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const Icon(
                CupertinoIcons.forward,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonAgree(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * buttonSizedWidth,
          0,
          MediaQuery.of(context).size.width * buttonSizedWidth,
          MediaQuery.of(context).size.height * buttonSizedHeight),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          minimumSize: const Size(double.infinity, 52),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          _registerController.onAgreeButtonTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Text(
                appLocalization.registerAgree,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const Icon(
                CupertinoIcons.forward,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonAgreeFinish(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * buttonSizedWidth,
          0,
          MediaQuery.of(context).size.width * buttonSizedWidth,
          MediaQuery.of(context).size.height * buttonSizedHeight),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.colorAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
            minimumSize: const Size(double.infinity, 52),
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            _registerController.registerUser();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              appLocalization.registerAgreeFinish,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }

  _secondPage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _skipWidget(),
            Text(
              appLocalization.registerDonateData,
              style: bigTitleStyle,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                appLocalization.registerDonateDataContent,
                style: descriptionTextStyle,
                textAlign: TextAlign.justify,
              ),
            ),
            Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              color: AppColors.pageBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardRadius),

              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.veryLightGreyColor),
                  borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getDataAgreement(context)
                    // _cgmWidget(context),
                    // const Divider(),
                    // _insightsWidget(context),
                    // const Divider(),
                    // _scannedImagesWidget(context),
                  ],
                ),
              ),
            ),
            _bottomContentWidget(),
          ],
        ),
      ),
    );
  }

  Widget getDataAgreement(BuildContext context) {
    return Obx(() {
      if (_registerController.dataAttributes.isNotEmpty) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _registerController.dataAttributes.length,
          itemBuilder: (BuildContext context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12.0),
                  child: Text(
                    _registerController.dataAttributes[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (index < _registerController.dataAttributes.length - 1)
                  const Divider(),
              ],
            );
          },
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Widget _ageWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        appLocalization.registerAge,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _cgmWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        appLocalization.registerCGM,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _insightsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        appLocalization.registerInsights,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  _scannedImagesWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        appLocalization.registerScannedImages,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  _thirdPage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalization.registerBackupAndRestore,
              style: bigTitleStyle,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                appLocalization.registerBackupAndRestoreContent,
                style: descriptionTextStyle,
                textAlign: TextAlign.justify,
              ),
            ),
            Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                color: AppColors.pageBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cardRadius),
                ),
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.veryLightGreyColor),
                      borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
                    ),
                    child: getDataAgreement(context))),
            _bottomContentWidget(),
          ],
        ),
      ),
    );
  }

  Widget _skipWidget() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            children: [
              TextSpan(
                text: appLocalization.registerSkip,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _registerController.onSkipTap();
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateUserNumber() {
    return Obx(
      () => Visibility(
        visible: _registerController.validateVisibility.value,
        child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              appLocalization.registerExistingUser,
              style: const TextStyle(fontSize: 12, color: Colors.redAccent),
            )),
      ),
    );
  }
}
