import 'package:Data4Diabetes/app/core/base/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:get/get.dart';

import '../../../Constants/Palette.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widget/app_bar_title.dart';
import '../controllers/dexcom_credential_controller.dart';

class DexcomCredentialView extends BaseView<DexcomCredentailController> {
  final DexcomCredentailController _dexcomCredentailController = Get.find();
  static const double containerRaduis = 20;
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
      title: const AppBarTitle(text: 'Dexcom Credentials'),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Container(
            decoration: BoxDecoration(
                color: Palette.white,
                border: Border.all(color: Palette.white),
                borderRadius:
                    const BorderRadius.all(Radius.circular(containerRaduis))),
            child: Column(
              children: [
                _baseUrlWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _baseUrlWidget() {
    // return Padding(
    //   padding:
    //   const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    //   child: Container(
    //     decoration: BoxDecoration(
    //         color: Palette.white,
    //         border: Border.all(color: Palette.white),
    //         borderRadius: const BorderRadius.all(
    //             Radius.circular(containerRaduis))),
    //     child: Column(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.symmetric(
    //               horizontal: 0.0, vertical: 3.0),
    //           child: TextFormField(
    //             autofocus: false,
    //             controller:_dexcomCredentailController
    //                 .baseUrlController,
    //             decoration: const InputDecoration(
    //               contentPadding:
    //               EdgeInsets.fromLTRB(16, 0, 0, 0),
    //               hintText: 'Base URL',
    //               fillColor: AppColors.pageBackground,
    //               filled: true,
    //               errorStyle:
    //               TextStyle(height: 0, color: Colors.red),
    //               hintStyle: TextStyle(
    //                 fontSize: 14,
    //                 fontWeight: FontWeight.w400,
    //                 color: AppColors.silverAppBarOverlayColor,
    //                 fontStyle: FontStyle.italic,
    //               ),
    //               border: InputBorder.none,
    //               focusedBorder: InputBorder.none,
    //               enabledBorder: InputBorder.none,
    //               errorBorder: InputBorder.none,
    //               disabledBorder: InputBorder.none,
    //             ),
    //           ),
    //
    //
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    //
    return Obx(() {
      return ListTileTheme(
        dense: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Sandbox URL'),
              value: true, // Set this to 'true' to make it selected by default
              groupValue:
                  _dexcomCredentailController.firstRadioButtonSelected.value,
              onChanged: (value) {
                _dexcomCredentailController.updateSelectedValue(value as bool);
                _dexcomCredentailController.defaultDexcomEnvironment();
              },
            ),
            const Divider(),
            RadioListTile(
              title: const Text('Limited Users url'),
              value: false, // Set this to 'false' as the other option
              groupValue:
                  _dexcomCredentailController.firstRadioButtonSelected.value,
              onChanged: (value) {
                _dexcomCredentailController.updateSelectedValue(value as bool);
                _dexcomCredentailController.limitedDexcomEnvironment();
              },
            ),
          ],
        ),
      );
    });
  }
}
