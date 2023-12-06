

import 'package:Data4Diabetes/app/core/base/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:get/get.dart';

import '../../../Constants/Palette.dart';
import '../../../Constants/app_text_files.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widget/app_bar_title.dart';
import '../controllers/privacy_dashboard_credential_controller.dart';

class PrivacyDashboardCredentialView
    extends BaseView<PrivacyDashboardCredentialController> {
  static const double containerRaduis = 20;
  final double radiusConst = 18.0;
  final double fontSize = 16;
  final PrivacyDashboardCredentialController
  _privacyDashboardCredentialController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _validate = false.obs;
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.backgroundColor,
      //centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      iconTheme: const IconThemeData(color: AppColors.appBarIconColor),
      title: const AppBarTitle(text: 'Privacy Dashboard Credentials'),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Palette.white,
                      border: Border.all(color: Palette.white),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(containerRaduis))),
                  child: Column(
                    children: [
                      _apiKeyWidget(),
                      const Divider(),
                      _baseUrlWidget(),
                      const Divider(),
                      // _orgIdWidget(),
                      // const Divider(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _buttonSet(context),
            ],
          ),
        ),
      ),
    );
  }

  _apiKeyWidget() {
    return Obx(() {
      return TextField(
        maxLines: null,
        autofocus: false,
        controller: _privacyDashboardCredentialController.apiKeyController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
          label: const Text('API Key'),
          errorText: _validate.value ? "Please enter a API key" : null,
          fillColor: Colors.transparent,
          filled: true,
          errorStyle: const TextStyle(height: 0, color: Colors.red),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.silverAppBarOverlayColor,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
        ),
      );
    });
  }

  _baseUrlWidget() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a base URL';
        }

        return null;
      },
      autofocus: false,
      controller: _privacyDashboardCredentialController.baseUrlController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(16, 10, 0, 10),
        fillColor: Colors.transparent,
        filled: true,
        errorStyle: TextStyle(height: 0, color: Colors.red),
        label: Text('Base URL'),
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.silverAppBarOverlayColor,
          fontStyle: FontStyle.italic,
        ),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        isDense: true,
      ),
    );
  }

  _orgIdWidget() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a organization Id';
        }

        return null;
      },
      autofocus: false,
      controller: _privacyDashboardCredentialController.orgIdController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(16, 10, 0, 10),
        label: Text('Organization ID'),
        fillColor: Colors.transparent,
        filled: true,
        errorStyle: TextStyle(height: 0, color: Colors.red),
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.silverAppBarOverlayColor,
          fontStyle: FontStyle.italic,
        ),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        isDense: true,
      ),
    );
  }


  _submitButton() {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(AppColors.colorAccent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radiusConst),
                ))),
        onPressed: () async {
          _validate.value = _privacyDashboardCredentialController
              .apiKeyController.text.isEmpty;
          if (formKey.currentState?.validate() ?? false) {
            _privacyDashboardCredentialController.submitButtonAction();
          } else {
            print('At least one form field is invalid');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Submit',
            style: AppTextStyles.normalText(
                fontSize: fontSize, color: Colors.white),
          ),
        ));
  }

  _resetButton(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(AppColors.colorAccent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radiusConst),
                ))),
        onPressed: () async {
          _privacyDashboardCredentialController.resetButtonAction(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Reset ',
            style: AppTextStyles.normalText(
                fontSize: fontSize, color: Colors.white),
          ),
        ));
  }

  _buttonSet(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _resetButton(context),
        _submitButton(),
      ],
    );
  }
}
