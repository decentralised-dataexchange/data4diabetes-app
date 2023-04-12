import 'package:Data4Diabetes/app/Constants/Palette.dart';
import 'package:Data4Diabetes/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_view.dart';
import '/app/core/widget/custom_app_bar.dart';
import 'package:flutter/services.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

class SettingsView extends BaseView<SettingsController> {
  static const double containerHeight = 400;
  static const double containerRaduis = 20;
  static const double switchScaleSize = 0.9;
  static const double imagelogoHeight = 100;
  var switchValue = true.obs;
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Settings',
    );
  }
  SettingsController _settingsController=SettingsController();
  @override
  Widget body(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,

          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Palette.white,
                    border: Border.all(color: Palette.white),
                    borderRadius:
                        BorderRadius.all(Radius.circular(containerRaduis))),
                child: Column(
                  children: [
                    _languageWidget(),
                    const Divider(),
                    _securityWidget(),
                    const Divider(),
                    _myWalletWidget(),
                    const Divider(),
                    _mySharedDataWidget(),

                  ],
                ),
              ),
            ),
            _lungsButton(),


          ],
        ),
      ),
      bottomNavigationBar: _igrantLogo() ,
    );
  }

  Widget _languageWidget() {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
      title: const Text(
        'Language',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: GestureDetector(
        onTap: (){return;},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'English',
              style: TextStyle(
                  color: Palette.greyCancel,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 15.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _securityWidget() {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
      title: const Text(
        'Security (Face ID)',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Transform.scale(
        scale: switchScaleSize,
        child: Obx(() {
          return CupertinoSwitch(

            value: switchValue.value,
            activeColor: CupertinoColors.activeGreen,
            onChanged: (bool? value) {
              switchValue.value = value ?? false;
            },
          );
        }),
      ),
    );
  }

Widget  _myWalletWidget() {
  return  ListTile(
    dense: true,
    visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
    title: const Text(
      'My Wallet',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    trailing: GestureDetector(
      onTap: (){
        return;
      },
      child:const Icon(
        Icons.arrow_forward_ios,
        size: 15.0,
      ),
    ),
  );
}

 Widget _mySharedDataWidget() {
   return  ListTile(
     dense: true,
     visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
     title: const Text(
       'My Shared Data',
       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
     ),
     trailing: GestureDetector(
       onTap: (){
         return;
       },
       child:const Icon(
         Icons.arrow_forward_ios,
         size: 15.0,
       ),
     ),
   );
 }

 Widget _lungsButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 100, 20, 0),
      child: Align(
        alignment: Alignment.bottomRight,
          child: GestureDetector(
            onTap: (){return;},
              child: Image.asset('images/lungs.png',scale: 8,))),
    );
 }

 Widget _igrantLogo() {


    return  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'images/igrant_icon.png',
            height: imagelogoHeight,
          ),
          Text( "v"+" 1.0.1"
              //+_settingsController.ver

          ),
          const  SizedBox(height: 10,),
        ],
      );



 }


}
