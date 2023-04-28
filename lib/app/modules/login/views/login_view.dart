import 'package:Data4Diabetes/app/modules/Otp/views/otp_view.dart';
import 'package:Data4Diabetes/app/modules/Register/views/register_view.dart';
import 'package:Data4Diabetes/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../widgets/logo.dart';
import '/app/core/base/base_view.dart';

class LoginView extends BaseView<LoginController> {
  final double radiusConst = 18.0;
  final double verticalPadding = 15.0;
  final _loginFormKey = GlobalKey<FormState>();
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  final LoginController _loginController = Get.find();
  @override
  Widget body(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Logo(),
                const SizedBox(height: 22),
                _mobileNumberWidget(),
                const SizedBox(height: 30),
                _loginButtonWidget(context),
                _RegisterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobileNumberWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Center(
        child: Column(
          children: <Widget>[
            _internationalPhoneNumberInputWidget(),
          ],
        ),
      ),
    );
  }

  Widget _internationalPhoneNumberInputWidget() {
    return InternationalPhoneNumberInput(
      hintText: '',
      keyboardAction: TextInputAction.go,
      autoFocus: true,
      formatInput: false,
      autoValidateMode: AutovalidateMode.disabled,
      onInputChanged: (val) {
        _loginController.isdCode = val.dialCode;
      },
      onSubmit: () {
        return;
      },
      ignoreBlank: false,
      initialValue: _loginController.number,
      validator: (value) {
        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
        RegExp regExp = RegExp(pattern);
        if (value == null || value.isEmpty) {
          return 'Please enter mobile number';
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter valid mobile number';
        }

        return null;
      },
      textFieldController: _loginController.phoneNumberController,
      inputDecoration: const InputDecoration(
        isDense: true,
        fillColor: AppColors.pageBackground,
        filled: true,
        errorStyle: TextStyle(height: 0, color: Colors.red),
        border: OutlineInputBorder(
            borderRadius:BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Color(0xFF707070), width: .5)),
        enabledBorder: OutlineInputBorder(
            borderRadius:BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Color(0xFF707070), width: .5)),
        focusedBorder: OutlineInputBorder(
            borderRadius:BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Color(0xFF707070), width: .5)),
        errorBorder: OutlineInputBorder(
          borderRadius:BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: Colors.red, width: .5),
        ),
      ),
      countries: const ['SE', 'DE', 'IN'],
    );
  }

  Widget _loginButtonWidget(BuildContext context) {
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
              if (_loginFormKey.currentState!.validate()) {
                FocusScope.of(context).requestFocus(FocusNode());

                _loginController.loginUser();
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 4,
                  vertical: verticalPadding),
              child: Text(
                appLocalization.login,
                style: boldTitleWhiteStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _RegisterWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            appLocalization.loginNotYetUser,
            style: settingsItemStyle,
          ),
          TextButton(
            onPressed: () => {
              Get.to(RegisterView()),
            },
            child: Text(
              appLocalization.loginRegisterNow,
              style: boldTitlePrimaryColorStyle,
            ),
          ),
        ],
      ),
    );
  }
}
