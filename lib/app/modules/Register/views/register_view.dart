import 'package:Data4Diabetes/app/modules/Otp/views/otp_view.dart';
import 'package:Data4Diabetes/app/modules/Register/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

import '../../../widgets/circular_progress_indicator.dart';
import '../../../widgets/logo.dart';
import '/app/core/base/base_view.dart';

class RegisterView extends BaseView<RegisterController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  final double radiusConst = 18.0;
  final double verticalPadding = 15.0;
  final _registerFormKey = GlobalKey<FormState>();
  final RegisterController _registerController = Get.find();
  @override
  Widget body(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _registerFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Logo(),
                const SizedBox(height: 22),
                _firstNameWidget(context),
                _lastNameWidget(),
                _mobileNumberWidget(),
                const SizedBox(height: 20),
                _confirmButtonWidget(context),
                _cancelButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
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
              if (_registerFormKey.currentState!.validate()) {
                FocusScope.of(context).requestFocus(FocusNode());

                _registerController.registerUser();
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 4,
                  vertical: verticalPadding),
              child: Text(
                appLocalization.register,
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
            onPressed: () {
              Get.back();
            },
            child: Text(
              appLocalization.registerCancel,
              style: boldTitlePrimaryColorStyle,
            ),
          )
        ],
      ),
    );
  }

  Widget _firstNameWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        autofocus: true,
        controller: _registerController.firstNameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter firstname';
          }

          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
          hintText: appLocalization.registerFirstName,
          fillColor: AppColors.pageBackground,
          filled: true,
          errorStyle: const TextStyle(height: 0, color: Colors.red),
          hintStyle: settingsItemStyle,
          border: const OutlineInputBorder(
              borderRadius:BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xFF707070), width: .5)),
          enabledBorder: const OutlineInputBorder(
              borderRadius:BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xFF707070), width: .5)),
          focusedBorder: const OutlineInputBorder(
              borderRadius:BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xFF707070), width: .5)),
          errorBorder: const OutlineInputBorder(
            borderRadius:BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.red, width: .5),
          ),
        ),
      ),
    );
  }

  Widget _lastNameWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        controller: _registerController.lastNameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter lastname';
          }

          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
          hintText: appLocalization.registerLastName,
          fillColor: AppColors.pageBackground,
          filled: true,
          errorStyle: const TextStyle(height: 0, color: Colors.red),
          hintStyle: settingsItemStyle,
          border: const OutlineInputBorder(
              borderRadius:BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xFF707070), width: .5)),
          enabledBorder: const OutlineInputBorder(
              borderRadius:BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xFF707070), width: .5)),
          focusedBorder: const OutlineInputBorder(
              borderRadius:BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xFF707070), width: .5)),
          errorBorder: const OutlineInputBorder(
            borderRadius:BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.red, width: .5),
          ),
        ),
      ),
    );
  }

  Widget _mobileNumberWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
        _registerController.isdCode = val.dialCode;
      },
      onSubmit: () {
        return;
      },
      ignoreBlank: false,
      initialValue: _registerController.number,
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
      textFieldController: _registerController.mobileNumberController,
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
}
