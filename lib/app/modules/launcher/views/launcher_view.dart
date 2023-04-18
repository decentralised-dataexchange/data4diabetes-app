import 'package:Data4Diabetes/app/modules/launcher/controller/launcher_controller.dart';
import 'package:Data4Diabetes/app/modules/login/views/login_view.dart';
import 'package:Data4Diabetes/app/modules/main/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_view.dart';

class LauncherView extends BaseView<LauncherController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  final LauncherController _launcherController = Get.find();
  @override
  Widget body(BuildContext context) {
   return FutureBuilder(
     future:_launcherController.chooseScreen() ,
       builder:(BuildContext context,AsyncSnapshot snapshot){
     if(snapshot.hasData){
       return snapshot.data != "" ? MainView() : LoginView();
     }

     return SizedBox() ;
   });
  }
}
