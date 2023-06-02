//
// import 'package:Data4Diabetes/app/modules/login/views/login_view.dart';
// import 'package:Data4Diabetes/app/modules/main/views/main_view.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
//
// import '../../../data/local/preference/preference_manager_impl.dart';
// import '/app/core/base/base_controller.dart';
//
//
// class LauncherController extends BaseController {
//   //final isLogged= Rxn<String>();
//  var isLogged;
//   final PreferenceManagerImpl _preferenceManagerImpl=PreferenceManagerImpl();
//   // @override
//   // void onInit() async {
//   //   isLogged=await _preferenceManagerImpl.getString('token');
//   //  //chooseScreen();
//   //   super.onInit();
//   //
//   // }
//
//  Future chooseScreen() async{
//    isLogged= await _preferenceManagerImpl.getString('token');
//    print("logged value:"+isLogged);
//
//    return isLogged;
//  }
//   //   if(isLogged != ""){
//   //     Get.to(MainView());
//   //   }
//   //   else{
//   //    Get.to(LoginView());
//   //   }
//   // }
//
// }
