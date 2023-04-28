import 'package:Data4Diabetes/app/modules/Otp/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '/app/core/base/base_view.dart';

class OtpView extends BaseView<OtpController> {
  FocusNode textFieldFocusNode = FocusNode();
  String otpCode = '';
  final double radiusConst = 18.0;
  final double verticalPadding = 15.0;
  final OtpController _otpController = Get.find();

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 22),
              _otpTextFormWidget(),
              const SizedBox(height: 15),
              _resendOtpWidget(),
              const SizedBox(height: 15),
              _confirmButtonWidget(context),
              _cancelButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpTextFormWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              appLocalization.otpEnterOtp,
              style: settingsItemStyle,
            ),
            const SizedBox(
              width: 5,
            ),
            Obx(() {
              return _otpController.loginController.isControl.value
                  ? Text(
                      _otpController.loginController.sharePhoneNumber.value,
                      style: boldTitleStyle,
                    )
                  : Text(
                      _otpController.registerController.sharePhoneNumber.value,
                      style: boldTitleStyle,
                    );
            }),
          ],
        ),
        Card(
          elevation: 0,
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: _pinInputWidget(),
          ),
        ),
      ],
    );
  }

  Widget _resendOtpWidget() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            appLocalization.otpNotReceive,
            style: settingsItemStyle,
          ),
          TextButton(
            onPressed: () {
              _otpController.resendOTP();
            },
            child: Text(
              appLocalization.otpResend,
              style: boldTitlePrimaryColorStyle,
            ),
          )
        ]);
  }

  Widget _confirmButtonWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        children: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColors.colorAccent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radiusConst),
                ),
              ),
            ),
            onPressed: () {
              if (_otpController.verifyOtpController.text != "") {
                FocusScope.of(context).requestFocus(FocusNode());
                _otpController.verifyOTP();
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 4,
                  vertical: verticalPadding),
              child: Text(
                appLocalization.otpConfirm,
                style: boldTitleWhiteStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cancelButtonWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextButton(
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
            onPressed: () {
              Get.back();
            },
            child: Text(
              appLocalization.otpCancel,
              style: boldTitlePrimaryColorStyle,
            ),
          )
        ],
      ),
    );
  }

  Widget _pinInputWidget() {
    return PinFieldAutoFill(
      controller: _otpController.verifyOtpController,
      autoFocus: true,
      focusNode: textFieldFocusNode,
      decoration: UnderlineDecoration(
        textStyle: const TextStyle(fontSize: 18, color: Colors.black),
        colorBuilder: FixedColorBuilder(Colors.grey),
      ),
      currentCode: otpCode,
      onCodeSubmitted: (val) {
        return;
      },
      onCodeChanged: (val) {
        return;
      },
      codeLength: 6,
    );
  }
}
